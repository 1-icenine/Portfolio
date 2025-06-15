# 🎵 Spotify Data Exploration with SQL

## 📌 Overview

This project uses SQL to analyze data from the [Chinook sample database](https://github.com/lerocha/chinook-database), which simulates a digital music store. The goal is to explore purchasing trends and sales performance to answer key business questions about genre popularity, album recommendations, employee performance, and regional sales patterns.

> [!NOTE]
> The Chinook sample database randomizes some of the information, so it will not always be consistent.

## 🧠 Lessons Learned
- Used **CTEs** (Common Table Expressions) for cleaner query logic
- Applied **window functions** like `DENSE_RANK()` for ranking for album recs
- Performed **sanity checks** to confirm data accuracy
- Created **SQL views** for reusability and modularity

## 🛠️ Setup & Usage
1. Load the Chinook database in your SQL environment
2. Open and run `EDA_Music_Store.sql`.
3. View outputs from each section to explore insights.

## 🔍 Key Questions Explored
1. Which genres are most popular in the U.S. market?
2. Which albums from the top 3 genres in the U.S. should be promoted?
3. Which sales employees performed best?
4. Which countries generate the most revenue?
5. What are the average order values and spending per customer by country?

## 💡Business Questions Answered 
- The store should invest in Rock, Latin, and Metal because they were the most popular American genres
- The store could consider marketing high-selling albums in those genres like:
  - **Rock:** Chronicle, Vol. 2
  - **Latin:** Minha Historia
  - **Metal:** Living After Midnight
- Jane Peacock was the most profitable sales rep with 796 tracks sold.
- The U.S.A. produced the most sales, excluding countries with only one customer (Other)

## 📊 Sample Output
![image](https://github.com/user-attachments/assets/30d26854-7b38-44cb-9b60-83d97c45cb73)
