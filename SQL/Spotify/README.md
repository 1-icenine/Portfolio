# 🎵 Spotify Data Exploration with SQL

## 📌 Overview

This project uses SQL to explore and analyze a dataset of 600 Spotify tracks. It focuses on analyzing popularity distributions and factors that could affect popularity. It also includes reusable stored procedures for fetching popular tracks and the longest songs.

## 🧠 Lessons Learned
- Used `DENSE_RANK()` for ranking songs and albums within genres.
- Conditional counting with  `COUNT(CASE WHEN ...)` for category breakdowns.
- Window functions `OVER(PARTITION BY ...)` to calculate genre-specific and artist-specific metrics such as average popularity and song counts.

## 🛠️ Setup & Usage

To replicate this project:

1. Import the dataset in your SQL environmennt

2. Run the scripts in load_spotify_data.sql and edit the path to the dataset file:

```SQL
LOAD DATA INFILE 'your/path/to/spotify_dataset.csv'
INTO TABLE spotify_data
FIELDS TERMINATED BY ',' ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;
```

2. Run spotify_queries.sql in chunks and explore insights.

3. *(Optional)* Run the scripts in `make_procedures.sql` to create procedures needed to run `CALL` procedures in `spotify_queries.sql`

```SQL
CALL GetPopularTracksByGenre('alt-rock', 50);
CALL GetLongestSongs(10);
```

## 📂 Dataset

The dataset was sourced from Kaggle: [Spotify Songs Dataset](https://www.kaggle.com/datasets/ambaliyagati/spotify-dataset-for-playing-around-with-sql/data)

It has information on individual Spotify tracks, including:
- Track name, artist(s), album, and genre
- Popularity score (0-100)
- Song duration in ms
- Explicit content flag (yes/no)

> [!NOTE]
> This dataset includes all Spotify track titles without alteration. Any informal, provocative, or edgy titles reflect original artist naming.

## 🔍 Key Questions Explored
- Which genres rank highest in popularity? What albums should be recommended based on that?
- How does song length (Short <3 min, Average 3-4 min, Long >4 min) affect average popularity?
- What is the distribution of song durations by genre?
- What percent of songs in each genre are high, mediocre, or low popularity?
- How many songs fall above or below their genre’s average popularity?
- Does the length of a song’s title correlate with its popularity?
-  Which artists do the best on average compared to their genre average?

## 📊 Sample Output
![image](https://github.com/user-attachments/assets/172e0e33-b020-4475-836b-ff4ba9aeb87a)



