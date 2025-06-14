-- Filename: EDA_IMDb_Movies.sql
-- Purpose: Analyze imdb_data and identify intriguing trends
-- Author: Nicholas Louie
-- Last Updated: 2025-06-13

-- How many records are there for each mediaType?
WITH mediaType_distribution AS (
	SELECT mediaType, COUNT(*) AS movieCount
	FROM imdb_data
    WHERE mediaType IS NOT NULL 
	GROUP BY mediaType
)
SELECT *
FROM mediaType_distribution;

-- Which mediaType has the highest and lowest ratings?
WITH mediaType_distribution AS (
	SELECT 
		mediaType, 
		COUNT(*) AS movieCount,
		COUNT(CASE WHEN averageRating >= 8 THEN 1 END)  AS excellentRatingCount,
		COUNT(CASE WHEN averageRating >= 6.5 AND averageRating < 8 THEN 1 END) AS goodRatingCount,
		COUNT(CASE WHEN averageRating < 6.5 THEN 1 END) AS lowRatingCount
	FROM imdb_data
    WHERE 
		mediaType IS NOT NULL 
		AND (averageRating IS NOT NULL OR averageRating != '')
	GROUP BY mediaType
)
SELECT
    mediaType,
    movieCount,
    ROUND(excellentRatingCount/movieCount * 100, 1) AS excellentRatingPercent,
    ROUND(goodRatingCount/movieCount * 100, 1) AS goodRatingPercent,
    ROUND(lowRatingCount/movieCount * 100, 1) AS lowRatingPercent
FROM mediaType_distribution;

-- What's the distribution of movies by releaseYear? Are there more movies in recent years?
WITH movieCountByYear AS (
	SELECT 
		releaseYear, 
		COUNT(*) AS movieCount 
	FROM imdb_data
	WHERE 
		LOWER(mediaType) = 'movie'
	GROUP BY releaseYear
	ORDER BY releaseYear DESC
)
SELECT * FROM movieCountByYear;

-- What does the rating distribution look like for movies across aall the years?
WITH movieCountByYear AS (
	SELECT 
		releaseYear, 
		COUNT(*) AS movieCount,
		COUNT(CASE WHEN averageRating >= 8 THEN 1 END)  AS excellentRatingCount,
		COUNT(CASE WHEN averageRating >= 6.5 AND averageRating < 8 THEN 1 END) AS goodRatingCount,
		COUNT(CASE WHEN averageRating < 6.5 THEN 1 END) AS lowRatingCount
	FROM imdb_data
	WHERE 
		LOWER(mediaType) = 'movie'
		AND (averageRating IS NOT NULL OR averageRating != '')
        AND releaseYear IS NOT NULL
	GROUP BY releaseYear
	ORDER BY releaseYear DESC
)
SELECT * FROM movieCountByYear;

-- Which year had the highest number of low rated, followed by highest rated movies?
WITH movieCountByYear AS (
	SELECT 
		releaseYear, 
		COUNT(*) AS movieCount,
		COUNT(CASE WHEN averageRating >= 8 THEN 1 END)  AS excellentRatingCount,
		COUNT(CASE WHEN averageRating >= 6.5 AND averageRating < 8 THEN 1 END) AS goodRatingCount,
		COUNT(CASE WHEN averageRating < 6.5 THEN 1 END) AS lowRatingCount
	FROM imdb_data
	WHERE 
		LOWER(mediaType) = 'movie'
		AND (averageRating IS NOT NULL OR averageRating != '')
        AND releaseYear IS NOT NULL
	GROUP BY releaseYear
	ORDER BY releaseYear DESC
)
SELECT * FROM movieCountByYear
WHERE lowRatingCount = (
	SELECT MAX(lowRatingCount)
    FROM movieCountByYear
)
UNION ALL
SELECT * FROM movieCountByYear
WHERE excellentRatingCount = (
	SELECT MAX(excellentRatingCount)
    FROM movieCountByYear
);

WITH movieCountByYear AS (
	SELECT 
		releaseYear, 
		COUNT(*) AS movieCount 
	FROM imdb_data
	WHERE LOWER(mediaType) = 'movie'
	GROUP BY releaseYear
	ORDER BY releaseYear DESC
)
SELECT * FROM movieCountByYear
WHERE movieCount = (
	SELECT MAX(movieCount) FROM movieCountByYear
    WHERE releaseYear IS NOT NULL AND releaseYear != ''
);

-- What's the distribution of titles by genre count?
WITH movieCountByGenre AS (
	SELECT 	
		title, 
		genres, 
		releaseYear,
		LENGTH(genres) - LENGTH(REPLACE(genres, ',', '')) + 1 AS genreCount
	FROM imdb_data
	WHERE 	
		genres IS NOT NULL 
		AND genres != ''
		AND releaseYear IS NOT NULL
        AND LOWER(mediaType) = 'movie'
	ORDER BY genreCount DESC
)
SELECT genreCount, COUNT(*) AS movieCount FROM movieCountByGenre
GROUP BY genreCount
ORDER BY genreCount DESC;

-- What are the top 10 most common genres?
DROP TEMPORARY TABLE IF EXISTS genre_split_temp;
CREATE TEMPORARY TABLE genre_split_temp AS
	SELECT 
		releaseYear,
		title,
        mediaType,
        averageRating,
        numVotes,
		TRIM(SUBSTRING_INDEX(SUBSTRING_INDEX(genres, ',', 1), ',', -1)) AS genre
	FROM imdb_data
	WHERE genres IS NOT NULL
    
	UNION ALL
    
	SELECT 
		releaseYear,
		title,
        mediaType,
        averageRating,
        numVotes,
		TRIM(SUBSTRING_INDEX(SUBSTRING_INDEX(genres, ',', 2), ',', -1)) AS genre
	FROM imdb_data
	WHERE genres LIKE '%,%'
    
	UNION ALL
    
	SELECT 
		releaseYear,
		title,
        mediaType,
        averageRating,
        numVotes,
		TRIM(SUBSTRING_INDEX(SUBSTRING_INDEX(genres, ',', 3), ',', -1)) AS genre
	FROM imdb_data
	WHERE genres LIKE '%,%,%';

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

-- What does the rating distribution look like across movie genres?
WITH movieGenre_distribution AS (
	SELECT 
		genre, 
		COUNT(*) AS movieCount,
		COUNT(CASE WHEN averageRating >= 8 THEN 1 END) AS excellentRatingCount,
		COUNT(CASE WHEN averageRating >= 6.5 AND averageRating < 8 THEN 1 END) AS goodRatingCount,
		COUNT(CASE WHEN averageRating < 6.5 THEN 1 END) AS lowRatingCount
	FROM genre_split_temp
	WHERE 
		genre != ''
        AND (averageRating IS NOT NULL OR averageRating != '')
	GROUP BY genre
	ORDER BY movieCount DESC
	LIMIT 10
)
SELECT 
	genre,
    movieCount,
    ROUND(excellentRatingCount/movieCount * 100, 1) AS excellentRatingPercent,
    ROUND(goodRatingCount/movieCount * 100, 1) AS goodRatingPercent,
    ROUND(lowRatingCount/movieCount * 100, 1) AS lowRatingPercent
FROM movieGenre_distribution
ORDER BY excellentRatingPercent DESC;

-- What are the 10 highest rated animation movies?
CALL GetTop10MoviesByGenre('Animation');

-- What are the 10 lowest rated animation movies?
CALL GetBottom10MoviesByGenre('Animation');

-- What are the top 10 highest rated animation tvSeries?
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
ORDER BY averageRating DESC
LIMIT 10;

-- What are the 10 lowest rated animation tvSeries?
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