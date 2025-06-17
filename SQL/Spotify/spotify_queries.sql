-- Filename: spotify_queries.sql
-- Purpose: Load and process Spotify dataset CSV into spotify_data table
-- Author: Nicholas Louie
-- Last Updated: 2025-06-17

-- Objective 1: Identify the most popular music genres in the Spotify dataset
SELECT 
    genre, 
    avg_popularity,
    no_of_songs,
    DENSE_RANK() OVER (ORDER BY avg_popularity DESC) AS popularity_rank
FROM (
	SELECT 
		genre,
        AVG(popularity) AS avg_popularity,
        COUNT(*) AS no_of_songs
    FROM spotify_data
    GROUP BY genre
) AS genre_stats
ORDER BY avg_popularity DESC;

-- Objective 2: Recommend top-selling albums in Rock, Dance, and Pop genres
WITH album_stats AS (
    SELECT
        album,
        genre,
        AVG(popularity) AS avg_popularity
    FROM spotify_data
    GROUP BY album, genre
),
ranked_albums AS (
    SELECT 
        album, 
        genre,
        avg_popularity,
        DENSE_RANK() OVER (PARTITION BY genre ORDER BY avg_popularity DESC) AS popularity_rank
    FROM album_stats
)
SELECT *
FROM ranked_albums
WHERE 
	popularity_rank <= 3
	AND (genre = 'rock' OR genre = 'dance' OR genre = 'pop')
ORDER BY genre, popularity_rank;

-- Objective 3: Do longer songs have higher average popularity across the dataset?
WITH categorized_song_metrics AS (
	SELECT 	
		name, 
        genre,
		popularity,
		ROUND(duration_ms / (1000 * 60), 2) AS duration_min,
		CASE 
			WHEN ROUND(duration_ms / (1000 * 60), 2) < 3 THEN 'Short'
			WHEN ROUND(duration_ms / (1000 * 60), 2) BETWEEN 3 AND 4 THEN 'Average'
			ELSE 'Long'
		END AS length_category
	FROM spotify_data
)
SELECT 
    length_category,
    COUNT(*) AS no_of_songs,
    ROUND(AVG(popularity), 2) AS avg_popularity
FROM categorized_song_metrics
GROUP BY length_category
ORDER BY avg_popularity DESC;

-- This is to get a dataset for visualization purposes for anyone interested.
WITH binned_durations AS (
	SELECT 
		name,
        popularity,
		ROUND(duration_ms / (1000 * 60), 1) AS duration_min_rounded
	FROM spotify_data
)
SELECT 
    duration_min_rounded,
    COUNT(*) AS num_songs,
    ROUND(AVG(popularity), 2) AS avg_popularity
FROM binned_durations
GROUP BY duration_min_rounded
ORDER BY duration_min_rounded;
 
 WITH categorized_song_metrics AS (
	SELECT 	
		name, 
        genre,
		popularity,
		ROUND(duration_ms / (1000 * 60), 2) AS duration_min,
		CASE 
			WHEN ROUND(duration_ms / (1000 * 60), 2) < 3 THEN 'Short'
			WHEN ROUND(duration_ms / (1000 * 60), 2) BETWEEN 3 AND 4 THEN 'Average'
			ELSE 'Long'
		END AS length_category
	FROM spotify_data
)
SELECT
	genre,
	length_category,
	COUNT(*) AS no_of_songs,
	ROUND(AVG(popularity), 2) AS avg_popularity
FROM categorized_song_metrics
GROUP BY genre, length_category
ORDER BY genre, length_category;
 
-- Objective 4: Which genres are most concentrated with high-popularity tracks
WITH categorized_song_metrics AS (
	SELECT 	
		name, 
        genre,
		ROUND(duration_ms/(1000*60), 2) AS duration_min,
		popularity,
		CASE 
			WHEN popularity < 30 THEN 'Low'
			WHEN popularity BETWEEN 30 AND 69 THEN 'Mediocre'
			ELSE 'High'
		END AS popularity_tier
	FROM spotify_data
),
genre_popularity_counts AS (
	SELECT
		genre,
        COUNT(*) AS total_songs,
		COUNT(CASE WHEN popularity_tier = 'High' THEN 1 END) AS high_popularity_songs,
        COUNT(CASE WHEN popularity_tier = 'Mediocre' THEN 1 END) AS mediocre_popularity_songs,
        COUNT(CASE WHEN popularity_tier = 'Low' THEN 1 END) AS low_popularity_songs
	FROM categorized_song_metrics
	GROUP BY genre
)
SELECT 
	genre,
    total_songs,
    high_popularity_songs,
    ROUND(100.0 * high_popularity_songs / total_songs, 2) AS pct_high_popularity,
    ROUND(100.0 * mediocre_popularity_songs / total_songs, 2) AS pct_mediocre_popularity,
    ROUND(100.0 * low_popularity_songs / total_songs, 2) AS pct_low_popularity
FROM genre_popularity_counts
ORDER BY pct_high_popularity DESC;

-- Objective 5: How many songs in each genre are above or below the genre's average popularity?
WITH song_popularity_vs_genre_avg AS (
	SELECT 	
		name, 
		artists, 
		genre,
		popularity,
		AVG(popularity) OVER (PARTITION BY genre) AS avg_genre_popularity
	FROM spotify_data
)
SELECT 
	genre,
	ROUND(avg_genre_popularity, 2) AS avg_genre_popularity,
	COUNT(*) AS total_songs,
	ROUND(100.0 * SUM(CASE WHEN popularity >= avg_genre_popularity THEN 1 ELSE 0 END) / COUNT(*), 2) AS pct_above_avg,
	ROUND(100.0 * SUM(CASE WHEN popularity < avg_genre_popularity THEN 1 ELSE 0 END) / COUNT(*), 2) AS pct_below_avg
FROM song_popularity_vs_genre_avg
GROUP BY genre, avg_genre_popularity
ORDER BY avg_genre_popularity DESC;

-- Objective 6: Does song title length affect the popularity of a song?
WITH title_length_metrics AS (
    SELECT
        name,
        genre,
        popularity,
        LENGTH(name) AS title_length_chars,
        CASE 
            WHEN LENGTH(name) < 10 THEN 'Short Title'
            WHEN LENGTH(name) BETWEEN 10 AND 20 THEN 'Medium Title'
            ELSE 'Long Title'
        END AS title_length_category
    FROM spotify_data
)
SELECT
    title_length_category,
    COUNT(*) AS no_of_songs,
    ROUND(AVG(popularity), 2) AS avg_popularity,
    ROUND(100.0 * SUM(CASE WHEN popularity >= 70 THEN 1 ELSE 0 END) / COUNT(*), 2) AS pct_high_popularity
FROM title_length_metrics
GROUP BY title_length_category
ORDER BY avg_popularity DESC;

-- Objective 7: Which artists do the best within their categories on average?
WITH artist_stats AS (
    SELECT 
        artists,
        genre,
        ROUND(AVG(popularity), 2) AS avg_artist_popularity,
        COUNT(*) AS no_of_tracks
    FROM spotify_data
    GROUP BY artists, genre
),
genre_stats AS (
    SELECT 
        genre,
        ROUND(AVG(popularity), 2) AS avg_genre_popularity
    FROM spotify_data
    GROUP BY genre
)
SELECT 
    a.artists,
    a.genre,
    a.avg_artist_popularity,
    g.avg_genre_popularity,
    a.no_of_tracks,
    ROUND(a.avg_artist_popularity - g.avg_genre_popularity, 2) AS popularity_diff
FROM artist_stats a
JOIN genre_stats g
	ON a.genre = g.genre
ORDER BY popularity_diff DESC;

-- Procedures
CALL GetPopularTracksByGenre('alt-rock', 50);
CALL GetLongestSongs(10);
