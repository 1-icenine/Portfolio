-- Filename: make_procedures.sql
-- Purpose: Contains reusable stored procedures for analyzing IMDb data based on user input
-- Author: Nicholas Louie
-- Last Updated: 2025-06-13

DROP PROCEDURE IF EXISTS GetTop10MoviesByGenre;
DELIMITER //
CREATE PROCEDURE GetTop10MoviesByGenre(IN genre_input VARCHAR(50))
BEGIN
    SELECT 
        title,
        releaseYear,
        averageRating,
        numVotes,
        genre
    FROM genre_split_temp
    WHERE 
        LOWER(genre) = LOWER(genre_input)
        AND mediaType = 'movie'
        AND numVotes >= 10000
    ORDER BY averageRating DESC
    LIMIT 10;
END //
DELIMITER ;

DROP PROCEDURE IF EXISTS GetBottom10MoviesByGenre;
DELIMITER //
CREATE PROCEDURE GetBottom10MoviesByGenre(IN genre_input VARCHAR(50))
BEGIN
    SELECT 
        title,
        releaseYear,
        averageRating,
        numVotes,
        genre
    FROM genre_split_temp
    WHERE 
        LOWER(genre) = LOWER(genre_input)
        AND mediaType = 'movie'
        AND numVotes >= 10000
    ORDER BY averageRating ASC
    LIMIT 10;
END //
DELIMITER ;

DROP PROCEDURE IF EXISTS GetTop10TVSeriesByGenre;
DELIMITER //
CREATE PROCEDURE GetTop10TVSeriesByGenre(IN genre_input VARCHAR(50))
BEGIN
    SELECT 
		releaseYear,
		title, 
		mediaType, 
		averageRating
	FROM genre_split_temp
	WHERE 
		LOWER(genre) = LOWER(genre_input)
		AND numVotes >= 10000
		AND (mediaType = 'tvSeries' OR mediaType = 'tvMiniSeries')
	ORDER BY averageRating DESC
	LIMIT 10;
END //
DELIMITER ;

DROP PROCEDURE IF EXISTS GetBottom10TVSeriesByGenre;
DELIMITER //
CREATE PROCEDURE GetBottom10TVSeriesByGenre(IN genre_input VARCHAR(50))
BEGIN
	SELECT 
		releaseYear,
		title, 
		mediaType, 
		averageRating
	FROM genre_split_temp
	WHERE 
		LOWER(genre) = 'animation'
		AND numVotes >= 10000
		AND (mediaType = 'tvSeries' OR mediaType = 'tvMiniSeries')
	ORDER BY averageRating ASC
	LIMIT 10;
END //
DELIMITER ;




