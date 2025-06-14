# 🎬 IMDb Data Exploration with SQL

## 📌 Overview

This project explores and analyzes a large 1M+ IMDb dataset using advanced SQL queries to uncover trends in movie and TV media. It highlights my ability to write clean, efficient SQL for exploratory data analysis (EDA), and includes CTEs, conditional aggregation, stored procedures, and temporary tables.

## 📂 Dataset

The dataset was sourced from Kaggle (https://www.kaggle.com/datasets/octopusteam/full-imdb-dataset). According to the source, it is updated daily at 8:00 AM UTC, so this analysis is up-to-date as of 06/14/2025.

It includes information on:
- Title names
- Media types (e.g., movie, tvSeries, tvMiniSeries)
- Release years
- Genres (multi-labeled)
- Ratings out of 10
- Vote counts

> [!IMPORTANT]
> The CSV file was imported using LOAD DATA INFILE. The path is system-dependent and should be adjusted as needed before execution.

## 🔍 Key Questions Explored

### 📈 Distribution of Media Types
- How many entries exist for each media type?
- Which types dominate the entire dataset?

### ⭐ Rating Quality Breakdown
- What percent of titles are excellent (≥8), good (6.5–8), or low-rated (<6.5)?
- Which media types and genres are more likely to receive high ratings?

### 🕰️ Temporal Trends
- Are more movies being released in recent years?
- Which year had the highest volume of movies?
- Which year had the most highest rated films? How about lowest rated films?

### 🎭 Genre-Based Analysis
- How many genres do most movies belong to?
- What are the most common genres?
- Which genres have the highest rated films? How about lowest rated films?

### 🏆 Top & Bottom 10 Rankings
- 10 Highest/lowest-rated movies in a given genre
- 10 Highest/lowest-rated animation TV series and movies

## ⚙️ SQL Features Demonstrated
- ✅ UNION ALL and filtering (WHERE statements) to split multi-genre rows
- ✅ CTEs (WITH statements) to structure multi-step queries
- ✅ Conditional aggregation with CASE WHEN for rating categories
- ✅ Temporary tables for genre-splitting from comma-separated strings
- ✅ Stored procedures with parameters to retrieve top/bottom entries by genre input
- ✅ Rounding and formatting for clean presentation

## 📌 Setup & Usage

To replicate this project:

1. Import the dataset (edit this for your own machine):

```SQL
LOAD DATA INFILE 'your/path/to/imdb_dataset.csv'
INTO TABLE imdb_data
FIELDS TERMINATED BY ',' ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;
```

2. Run EDA_IMDb_Movies.sql in chunks using a MySQL client.

3. Run the scripts in make_procedures.sql to create procedures needed to run CALL procedures like those below:

```
CALL GetTop10MoviesByGenre('Animation');
CALL GetBottom10MoviesByGenre('Animation');
```


