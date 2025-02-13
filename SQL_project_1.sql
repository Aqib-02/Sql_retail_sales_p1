CREATE DATABASE sql_portfolio_project_;

CREATE TABLE retail_sales (
transactions_id INT,
	sale_date DATE,
	sale_time TIME,
	customer_id INT,
	gender VARCHAR(50),
	age INT,
	category VARCHAR(50),
	quantiy INT,
	price_per_unit INT,
	cogs INT,
	total_sale INT
    )
;

SELECT COUNT(transactions_id)
FROM retail_sales;

SELECT *
FROM retail_sales
LIMIT 10;

/* Checking and Removing Null values*/
SELECT *
FROM retail_sales
WHERE transactions_id IS NULL
OR sale_date IS NULL
OR sale_time IS NULL
OR customer_id IS NULL
OR gender IS NULL
OR age IS NULL
OR category IS NULL
OR quantiy IS NULL
OR price_per_unit IS NULL
OR cogs IS NULL
OR total_sale IS NULL;

/* Data Exploration*/

SELECT COUNT(DISTINCT customer_id) AS total_customers
FROM retail_sales;

SELECT COUNT(DISTINCT category) AS total_categories
FROM retail_sales;

SELECT MAX(age) AS oldest_customer, MIN(age) AS youngest_customer
FROM retail_sales;

SELECT * 
FROM retail_sales
WHERE sale_date='2022-11-05';

/* Retrieve all transactions where the category is 'Clothing' and the quantity sold is more than 4 in the month of Nov-2022*/
SELECT *
FROM retail_sales
WHERE category='Clothing' AND quantiy>=4 AND sale_date LIKE '2022-11%'
ORDER BY 2 ASC;

/*calculate the total sales (total_sale) for each category.*/

SELECT category,SUM(total_sale) AS net_sales,COUNT(*) AS total_orders
FROM retail_sales
GROUP BY category;

/*find the average age of customers who purchased items from the 'Beauty' category.*/
SELECT ROUND(AVG(age),2) as average_age
FROM retail_sales
WHERE category LIKE '%Beauty%';

/*find all transactions where the total_sale is greater than 1000*/
SELECT *
FROM retail_sales
WHERE total_sale>1000;

/*find the total number of transactions (transaction_id) made by each gender in each category*/

SELECT gender, category, COUNT(*) AS total_transactions
FROM retail_sales
GROUP BY gender,category
ORDER BY 1;

/* Calculate the average sale for each month. Find out best selling month in each year*/
WITH most_profitable_month AS(
SELECT
YEAR(sale_date) AS sale_year,
MONTH(sale_date) AS sale_month,
AVG(total_sale) AS avg_sale,
RANK() OVER(PARTITION BY  YEAR(sale_date) ORDER BY AVG(total_sale) DESC) AS rank_month
FROM retail_sales
GROUP BY 1,2)
SELECT * 
FROM most_profitable_month
WHERE rank_month=1;

/* find the top 5 customers based on the highest total sales */
SELECT customer_id,SUM(total_sale)
FROM retail_sales 
GROUP BY 1
ORDER BY 2 DESC
LIMIT 5;

/*find the number of unique customers who purchased items from each category.*/

SELECT 
    category,    
    COUNT(DISTINCT customer_id) as cnt_unique_cs
FROM retail_sales
GROUP BY category;

/* Create each shift and number of orders (Example Morning <12, Afternoon Between 12 & 17, Evening >17) */
WITH hourly_sale AS(
SELECT *,
CASE 
 WHEN HOUR(sale_time)<12 THEN "Morning"
 WHEN HOUR(sale_time)>12 AND HOUR(sale_time)<17 THEN "Afternoon"
 ELSE "Evening"
END AS shift
FROM retail_sales)
SELECT shift,
COUNT(*) AS number_of_orders
FROM hourly_sale 
GROUP BY shift

/* END OF PROJECT*/