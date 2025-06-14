-- Filename: load_imdb_data.sql
-- Purpose: Load and process IMDB dataset CSV into imdb_data table
-- Author: Nicholas Louie
-- Last Updated: 2025-06-13

DROP TABLE IF EXISTS imdb_data;
CREATE TABLE imdb_data (
	id VARCHAR(15),
    	title VARCHAR(255),
    	mediaType VARCHAR(50),
    	genres VARCHAR(100),
    	averageRating DECIMAL(3,1),
    	numVotes INT,
    	releaseYear INT
);

SHOW VARIABLES LIKE 'secure_file_priv';

LOAD DATA INFILE '/your/path/to/imdb_dataset.csv'
INTO TABLE imdb_data
FIELDS TERMINATED BY ',' 
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS
(@id, @title, @mediaType, @genres, @averageRating, @numVotes, @releaseYear)
SET
	title = @title,
    	mediaType = @mediaType,
    	genres = @genres,
    	averageRating = NULLIF(@averageRating, ''),
    	numVotes = NULLIF(@numVotes, ''),
    	releaseYear = NULLIF(@releaseYear, '');
