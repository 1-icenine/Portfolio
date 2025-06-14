-- Filename: make_procedures.sql
-- Purpose: Contains reusable stored procedures for analyzing Spotify data based on user input
-- Author: Nicholas Louie
-- Last Updated: 2025-06-14

# Filters based on a genre and min popularity
DROP procedure IF EXISTS `GetPopularTracksByGenre`;
DELIMITER $$
CREATE PROCEDURE GetPopularTracksByGenre(p_genre VARCHAR(100), min_popularity INT)
BEGIN
	SELECT name, album, artists, popularity
    FROM spotify_data
    WHERE 
		genre = p_genre 
		AND popularity >= min_popularity
    ORDER BY popularity DESC
    ;
END $$
DELIMITER ;

# Procedure: Give N longest songs
DROP procedure IF EXISTS `GetLongestSongs`;
DELIMITER $$
CREATE PROCEDURE GetLongestSongs(p_rank INT)
BEGIN
	WITH song_duration_info AS 
	(
		SELECT 
			name, 
            genre,
			artists, 
			album,
			duration_ms / (1000 * 60) AS duration_min,
			DENSE_RANK() OVER(ORDER BY duration_ms / (1000 * 60) DESC) AS duration_rank
		FROM spotify_data
		ORDER BY duration_ms DESC
	)
	SELECT * FROM song_duration_info
	WHERE duration_rank <= p_rank;
END $$
DELIMITER ;