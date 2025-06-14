-- Filename: load_spotify_data.sql
-- Purpose: Load and process IMDB dataset CSV into imdb_data table
-- Author: Nicholas Louie
-- Last Updated: 2025-06-14

DROP TABLE IF EXISTS spotify_data;
CREATE TABLE spotify_data (
    id VARCHAR(255) NOT NULL,
    name VARCHAR(255) NOT NULL,
    genre VARCHAR(255) NOT NULL,
    artists VARCHAR(255) NOT NULL,
    album VARCHAR(255) NOT NULL,
    popularity INT NOT NULL,
    duration_ms INT NOT NULL,
    explicit VARCHAR(10) NOT NULL
);

SHOW VARIABLES LIKE 'secure_file_priv';

LOAD DATA INFILE '/your/path/to/spotify_dataset.csv'
INTO TABLE spotify_data
FIELDS TERMINATED BY ',' 
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS
(@id, @name, @genre, @artists, @album, @popularity, @duration_ms, @explicit)
SET
	id = @id, 
   	name = @name, 
    	genre = @genre, 
    	artists = @artists, 
    	album = @album, 
   	popularity = @popularity, 
    	duration_ms = @duration_ms, 
    	explicit = TRIM(LOWER(@explicit))
