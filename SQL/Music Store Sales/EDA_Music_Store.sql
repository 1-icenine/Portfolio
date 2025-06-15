-- Filename: EDA_Music_Store.sql
-- Purpose: Analyze a fictional music store's data and answer 3 business questions
-- Author: Nicholas Louie
-- Last Updated: 2025-06-15

-- Objective 1: Identify the most popular music genres in the U.S. market
WITH usa_genre_sales AS (
	SELECT 
		g.Name AS genre,
		il.Quantity
	FROM invoice i
	JOIN invoiceline il ON i.InvoiceId = il.InvoiceId
	JOIN track t ON il.TrackId = t.TrackId
	JOIN genre g ON t.GenreId = g.GenreId
	WHERE i.BillingCountry = 'USA'
),
genre_summary AS (
	SELECT 
		genre,
		SUM(Quantity) AS tracks_sold,
		ROUND(SUM(Quantity) * 100.0 / SUM(SUM(Quantity)) OVER (), 2) AS tracks_sold_percentage
	FROM usa_genre_sales
	GROUP BY genre
)
SELECT * FROM genre_summary
ORDER BY tracks_sold DESC;

-- Objective 2: Recommend top-selling albums in Rock, Metal, and Latin genres
WITH album_recommendation AS (
	SELECT 
		g.Name AS genre,
		IFNULL(t.Composer, 'Unknown') AS composer,
		a.Title AS album,
		SUM(il.Quantity) AS tracks_sold
	FROM invoiceline il
	JOIN track t ON il.TrackId = t.TrackId
	JOIN genre g ON t.GenreId = g.GenreId
	JOIN album a ON t.AlbumId = a.AlbumId
	GROUP BY 
		g.Name, 
        t.Composer, 
        a.Title
	ORDER BY tracks_sold DESC, genre DESC
),
ranked_albums AS (
	SELECT *,
    DENSE_RANK() OVER (
		PARTITION BY genre
        ORDER BY tracks_sold DESC
	) AS rank_within_genre
	FROM album_recommendation
)
SELECT * FROM ranked_albums
WHERE 
	rank_within_genre <= 3
    AND (genre = 'Rock' OR genre = 'Latin' OR genre = 'Metal')
ORDER BY genre, rank_within_genre;

-- Objective 3: Evaluate support representatives' sales performance
SELECT 
	e.EmployeeId,
    CONCAT(e.FirstName, ' ', e.LastName) AS employee_name,
	e.Title,
	e.Country,
	SUM(il.UnitPrice * il.Quantity) AS profit_in_USD,
	SUM(il.Quantity) AS total_tracks_sold,
	e.ReportsTo
FROM invoiceline il
JOIN invoice i ON il.InvoiceId = i.InvoiceId
JOIN customer c ON i.CustomerId = c.CustomerId
JOIN employee e ON c.SupportRepId = e.EmployeeId
GROUP BY 
	e.EmployeeId, 
    e.Title, 
    e.Country, 
    e.ReportsTo
ORDER BY profit_in_USD DESC;

-- Sanity checks: Validate invoice and employee/customer relations
SELECT SUM(total) AS Total_Sales
FROM invoice;

SELECT 
	DISTINCT EmployeeId, 
    CONCAT(FirstName, ' ', LastName) AS employee_name
FROM employee;

SELECT DISTINCT SupportRepId
FROM customer;

-- Objective 4: Analyze country-level sales performance
DROP VIEW IF EXISTS country_sales;
CREATE VIEW country_sales AS
	SELECT 
		c.Country,
		SUM(i.Total) AS Total_Purchases,
		COUNT(DISTINCT c.CustomerId) AS Total_Customers,
		COUNT(i.invoiceId) AS Total_Orders
	FROM invoice i
	INNER JOIN customer c ON c.CustomerId = i.CustomerId
	GROUP BY 1;

SELECT * FROM country_sales;

SELECT
	SUM(Total_Purchases) AS Total_Sales_USD,
    SUM(Total_Customers) AS Total_Customers,
    SUM(Total_Orders) AS Total_Orders
FROM country_sales;

-- Sanity checks: Confirm consistency between country_sales view and base data
SELECT COUNT(invoiceId) AS Total_Orders 
FROM invoice;

SELECT COUNT(customerId) AS Total_Customers
FROM customer;

-- Objective 5: Analyze country-level average purchase behavior
WITH country_sales_other AS (
	SELECT
		CASE
			WHEN Total_Customers = 1 THEN 'Other'
			ELSE Country
		END AS country_identification,
		Total_Purchases,
		Total_Customers,
		Total_Orders
	FROM country_sales
),
country_sales_agg AS (
    SELECT
        country_identification,
        SUM(Total_Purchases) AS Total_Sales,
        SUM(Total_Customers) AS Total_Customers,
        SUM(Total_Orders) AS Total_Orders
    FROM country_sales_other
    GROUP BY 1
),
country_variables AS (
    SELECT
        country_identification AS Country,
        Total_Customers,
        Total_Sales, 
        ROUND(CAST(Total_Sales AS FLOAT) / Total_Customers, 2) AS Average_sales_per_customer, 
        ROUND(CAST(Total_Sales AS FLOAT) / Total_Orders, 2) AS Average_order_value
    FROM country_sales_agg
)
SELECT * FROM country_variables
ORDER BY Total_Sales DESC