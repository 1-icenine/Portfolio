# 🎵 Spotify Data Exploration with SQL

## 📌 Overview

This project uses SQL to explore and analyze a dataset of 600 Spotify tracks. It focuses on genre diversity, song popularity, length trends, and album name characteristics. It also includes reusable stored procedures for fetching popular tracks and the longest songs.

## 🧠 Lessons Learned
- Used `DENSE_RANK()` to identify top songs by genre and filter results cleanly with `WHERE` and `LIMIT` logic.
- Leveraged `COUNT(CASE WHEN ...)` to quantify qualitative categories like popularity tiers and duration groups.
- Applied `OVER(PARTITION BY ...)` to calculate genre-specific and artist-specific metrics such as average popularity and song counts.
- Gained experience categorizing numerical data into meaningful labels to support clearer insights.

## 📌 Setup & Usage

To replicate this project:

1. Import the dataset

2. Run the scripts in load_spotify_data.sql and edit the path to the dataset file:

```SQL
LOAD DATA INFILE 'your/path/to/spotify_dataset.csv'
INTO TABLE spotify_data
FIELDS TERMINATED BY ',' ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;
```

2. Run spotify_queries.sql in chunks using a SQL client like MySQL Workbench.

3. Run the scripts in make_procedures.sql to create procedures needed to run CALL procedures like those below:

```SQL
CALL GetPopularTracksByGenre('alt-rock', 50);
CALL GetLongestSongs(10);
```

## 📂 Dataset

The dataset was sourced from Kaggle (https://www.kaggle.com/datasets/ambaliyagati/spotify-dataset-for-playing-around-with-sql/data). As of 06/14/2025, the dataset was last updated a year ago. 

It includes information on:
- Track name
- Song genre
- Artists
- Album
- Popularity
- Song duration in ms
- Whether the song is explicit or not

> [!IMPORTANT]
> The CSV file was imported using LOAD DATA INFILE. The path is system-dependent and should be adjusted as needed before execution.

> [!NOTE]
> This dataset includes all Spotify track titles without alteration. Any informal, provocative, or edgy titles reflect original artist naming.

## 🔍 Key Questions Explored

### 🎼 Genres and Track Attributes
- What are the distinct genres in the dataset?
- How many unique genres are represented?

### 🚫 Explicit and Long Tracks
- Which tracks are explicit or longer than 5 minutes?

### 📈 Popularity Analysis
- Which genre has the most highly popular songs (popularity ≥ 70)?
- How does the popularity of each song compare to the average popularity in its genre?
- What are the top 3 most popular tracks within each genre?

### ⏱️ Duration Analysis
- Which genre has the most long songs (over 4 minutes)?
- How are tracks categorized based on duration (Short, Average, Long)?

### 🎵 Album Naming
- Which albums have the longest names in each genre?

## 📊 Sample Output
![image](https://github.com/user-attachments/assets/35295098-fd2c-4028-8c7f-1848613e783d)


