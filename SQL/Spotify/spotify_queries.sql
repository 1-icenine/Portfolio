-- Filename: spotify_queries.sql
-- Purpose: Load and process Spotify dataset CSV into spotify_data table
-- Author: Nicholas Louie
-- Last Updated: 2025-06-14

-- What are the distinct genres in the dataset? 
SELECT DISTINCT genre FROM spotify_data;

-- How many unique genres are represented?
SELECT COUNT(DISTINCT genre) FROM spotify_data;

-- Which tracks are explicit or longer than 5 minutes?
SELECT name, genre, duration_ms, explicit FROM spotify_data
WHERE 
	explicit = "True" 
	OR duration_ms >= 300000
ORDER BY explicit, duration_ms DESC;

-- Which genre has the most popular songs (>= 70 in popularity)
WITH categorized_song_metrics AS (
	SELECT 	
		name, 
        	genre,
		ROUND(duration_ms/(1000*60), 2) AS duration_min,
		CASE 
			WHEN ROUND(duration_ms/(1000*60), 2) < 3 THEN 'Short'
			WHEN ROUND(duration_ms/(1000*60), 2) BETWEEN 3 AND 4 THEN 'Medium'
			WHEN ROUND(duration_ms/(1000*60), 2) > 4 THEN 'Long'
		END AS length_category,
		popularity,
		CASE 
			WHEN popularity < 30 THEN 'Low'
			WHEN popularity BETWEEN 30 AND 69 THEN 'Mediocre'
			WHEN popularity >= 70 THEN 'High'
		END AS popularity_tier
	FROM spotify_data
)
SELECT
	DISTINCT genre,
    	COUNT(CASE WHEN popularity_tier = 'High' THEN 1 END) OVER(PARTITION BY genre) AS no_high_pop_songs,
    	COUNT(CASE WHEN popularity_tier = 'Mediocre' THEN 1 END) OVER(PARTITION BY genre) AS no_mediocre_pop_songs,
    	COUNT(CASE WHEN popularity_tier = 'Low' THEN 1 END) OVER(PARTITION BY genre) AS no_low_pop_songs
FROM categorized_song_metrics
ORDER BY no_high_pop_songs DESC;

-- Which genre has the most longest songs (> 4 minutes)
WITH categorized_song_metrics AS (
	SELECT 	
		name, 
        	genre,
		ROUND(duration_ms/(1000*60), 2) AS duration_min,
		CASE 
			WHEN ROUND(duration_ms/(1000*60), 2) < 3 THEN 'Short'
			WHEN ROUND(duration_ms/(1000*60), 2) BETWEEN 3 AND 4 THEN 'Average'
			WHEN ROUND(duration_ms/(1000*60), 2) > 4 THEN 'Long'
		END AS length_category
	FROM spotify_data
)
SELECT
	DISTINCT genre,
    	COUNT(CASE WHEN length_category = 'Long' THEN 1 END) OVER(PARTITION BY genre) AS no_long_length_songs,
    	COUNT(CASE WHEN length_category = 'Average' THEN 1 END) OVER(PARTITION BY genre) AS no_average_length_songs,
    	COUNT(CASE WHEN length_category = 'Short' THEN 1 END) OVER(PARTITION BY genre) AS no_short_length_songs
FROM categorized_song_metrics
ORDER BY no_long_length_songs DESC;

-- What are the top 3 songs across all the genres?
WITH popularity_ranking_by_genre AS (
	SELECT 	
		genre,
		name, 
		artists, 
		CONVERT(popularity, DECIMAL) AS popularity,
		DENSE_RANK() OVER(PARTITION BY genre ORDER BY CONVERT(popularity, DECIMAL) DESC) AS genre_ranking
	FROM spotify_data
)
SELECT * FROM popularity_ranking_by_genre
WHERE genre_ranking BETWEEN 1 AND 3;

-- How does the popularity of each song fare against average popularity in their genres?
WITH song_popularity_vs_genre_avg AS (
	SELECT 	
		name, 
		artists, 
		genre,
		popularity,
		ROUND(AVG(popularity) OVER(PARTITION BY genre), 2) AS avg_genre_popularity
	FROM spotify_data
	ORDER BY popularity DESC
)
SELECT 
	DISTINCT genre,
    	avg_genre_popularity,
    	COUNT(CASE WHEN popularity >= avg_genre_popularity THEN 1 END) OVER(PARTITION BY genre) AS no_songs_above_avg,
    	COUNT(CASE WHEN popularity < avg_genre_popularity THEN 1 END) OVER(PARTITION BY genre) AS no_songs_below_avg
FROM song_popularity_vs_genre_avg
ORDER BY avg_genre_popularity DESC;

-- Which albums have the longest names in each genre?
WITH album_title_lengths AS
(
	SELECT 
		DISTINCT album,
        	genre,
        	LENGTH(album) AS album_len,
        	MAX(LENGTH(album)) OVER (PARTITION BY genre) AS max_album_len
	FROM spotify_data
)
SELECT 
	album,
    	genre,
    	album_len
FROM album_title_lengths
WHERE album_len = max_album_len
ORDER BY max_album_len DESC;

-- Procedures
CALL GetPopularTracksByGenre('alt-rock', 50);
CALL GetLongestSongs(10);
