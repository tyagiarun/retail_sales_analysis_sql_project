--- SQL Retail Sales Analysis Project1
create database retail_sales_db;

 --- create table 
create table retail_sales (
transactions_id	INT PRIMARY KEY,
sale_date DATE,
sale_time TIME,	
customer_id	INT,
gender	VARCHAR(15),
age	INT,
category VARCHAR(15),	
quantiy	INT,
price_per_unit	FLOAT,
cogs FLOAT,	
total_sale FLOAT
)

-- checking for total no. of imported records : 2000
SELECT COUNT(*) AS total_imported_records FROM retail_sales;

SELECT * FROM retail_sales LIMIT 10;

--- checking for null values : 3 records
SELECT * FROM retail_sales 
WHERE 
	transactions_id is null 
	or sale_date is null 
	or sale_time is null 
	or  gender is null
	or category is null 
	or quantiy is null 
	or cogs is null 
	or total_sale is null;

--- Deleting the null values : 3 records -> 0 records
DELETE FROM retail_sales 
WHERE
	transactions_id is null 
	or sale_date is null 
	or sale_time is null 
	or  gender is null
	or category is null 
	or quantity is null 
	or cogs is null 
	or total_sale is null;

--- DATA EXPLORATION

-- checking for total no. of records after deleting : 1997 records
SELECT COUNT(*) AS total_imported_records FROM retail_sales;

-- how many sales we have? : 1997 records
SELECT COUNT(*) AS total_sales FROM retail_sales;

---how many customers we have : 155 customers
SELECT COUNT(DISTINCT customer_id) AS unique_customers FROM retail_sales;

--- distict catogories : Eletronics, Clothing, Beauty
SELECT DISTINCT category FROM retail_sales;

--- BUSINESS PROBLEMS

-- Q.1 Write a SQL query to retrieve all columns for sales made on '2022-11-05
SELECT * FROM retail_sales WHERE sale_date = '2022-11-05';

-- Q.2 Write a SQL query to retrieve all transactions where the category is 'Clothing' and the quantity sold is more than 4 in the month of Nov-2022
SELECT * 
FROM retail_sales 
WHERE sale_date BETWEEN '2022-11-01' AND '2022-11-30'
AND category = 'Clothing' 
AND quantity > 10;

SELECT *
FROM retail_sales
WHERE sale_date BETWEEN '2022-11-01' AND '2022-11-30'
AND category = 'Clothing'
AND quantity >= 4;

-- Q.3 Write a SQL query to calculate the total sales (total_sale) for each category.
SELECT category, SUM(total_sale) as total_sales
FROM retail_sales
GROUP BY category;

-- Q.4 Write a SQL query to find the average age of customers who purchased items from the 'Beauty' category.
SELECT category, ROUND(AVG(age),2)
FROM retail_sales
GROUP BY Category 
HAVING Category = 'Beauty';

-- Q.5 Write a SQL query to find all transactions where the total_sale is greater than 1000.
SELECT * 
FROM retail_sales 
WHERE total_sale > 1000
ORDER BY total_sale DESC;

-- Q.6 Write a SQL query to find the total number of transactions (transaction_id) made by each gender in each category.
SELECT category, gender, COUNT(transactions_id) AS no_of_txns
FROM retail_sales
GROUP BY category, gender;

-- Q.7 Write a SQL query to calculate the average sale for each month. 
SELECT TO_CHAR(sale_date,'YYYY') AS n_year, 
TO_CHAR(sale_date,'MM') AS n_month, 
AVG(total_sale) AS avg_total_sales
FROM retail_sales
GROUP BY n_year, n_month
ORDER BY n_year,avg_total_sales DESC;

--- Q.7/PART-II Find out best selling month in each year
WITH CTE AS (
SELECT TO_CHAR(sale_date,'YYYY') AS n_year, 
TO_CHAR(sale_date,'MM') AS n_month, 
AVG(total_sale) AS avg_total_sales,
RANK() OVER (PARTITION BY TO_CHAR(sale_date,'YYYY') ORDER BY AVG(total_sale) DESC) AS RNK
FROM retail_sales
GROUP BY n_year, n_month) --- ORDER BY n_year,avg_total_sales DESC)
SELECT * FROM CTE WHERE RNK = 1

-- Q.8 Write a SQL query to find the top 5 customers based on the highest total sales 
SELECT customer_id, sum(total_sale) as sum_of_sales
FROM retail_sales
GROUP BY customer_id
ORDER BY sum_of_sales DESC
LIMIT 5;

-- Using CTE / Sub-query 
WITH CTE AS (
SELECT customer_id, SUM(total_sale) AS sum_of_sales 
FROM retail_sales 
GROUP BY customer_id) 
SELECT *, 
RANK() OVER ( ORDER BY sum_of_sales DESC ) AS RNK 
FROM CTE 
ORDER BY sum_of_sales DESC LIMIT 5;

-- Q.9 Write a SQL query to find the number of unique customers who purchased items from each category.
SELECT category, COUNT(DISTINCT customer_id) as count_of_distinct_cx
FROM retail_sales
GROUP BY category

-- Q.10 Write a SQL query to create each shift and number of orders (Example Morning <=12, Afternoon Between 12 & 17, Evening >17)
WITH CTE AS
(SELECT *,
	CASE
		WHEN EXTRACT(HOURS FROM sale_time) < 12 THEN 'Morning'
		WHEN EXTRACT(HOURS FROM sale_time) BETWEEN 12 AND 17 THEN 'Afternoon'
		ELSE 'Evening'
	END AS shift
FROM retail_sales) 
SELECT shift, COUNT(*) AS total_orders 
FROM CTE
GROUP BY shift
ORDER BY total_orders DESC;


