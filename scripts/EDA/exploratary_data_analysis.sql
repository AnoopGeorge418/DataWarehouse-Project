-- categories - string/category - dimensions
SELECT DISTINCT 
	category
FROM gold.dim_products;

-- sales_amount - numerics/number - measures
SELECT DISTINCT 
	sales_amount
FROM gold.fact_sales;

-- quantity - numerics/number - measures
SELECT DISTINCT 
	quantity
FROM gold.fact_sales;

-- product_name - string/category - dimensions
SELECT DISTINCT 
	product_name
FROM gold.dim_products;

-- bdate - string/category - dimensions
SELECT DISTINCT 
	birth_date
FROM gold.dim_customers;

-- age - numerics/number - measures
SELECT DISTINCT 
	EXTRACT(year FROM AGE(CURRENT_DATE, birth_date)) AS age
FROM gold.dim_customers;

-- customer_id - string/category - dimensions
SELECT DISTINCT 
	customer_id
FROM gold.dim_customers;

-- DataBase Exploration

-- 1. Exploring all objects in database
SELECT * FROM INFORMATION_SCHEMA.TABLES;

-- 2. Exploring all columns in the database
SELECT * FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_NAME = 'dim_customers';

SELECT * FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_NAME = 'dim_products';

SELECT * FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_NAME = 'fact_sales';

-- Explore all countries of our customers come from
SELECT DISTINCT country FROM gold.dim_customers;

-- Explore all categories in "Major Divisions"
SELECT DISTINCT 
	category, 
	sub_category, 
	product_name 
FROM gold.dim_products ORDER BY 1, 2, 3;

-- Exploring date columns
-- Find the first and last order
SELECT 
	MIN(order_date) AS first_order, 
	MAX(order_date) AS last_order 
FROM gold.fact_sales;

-- How many years of sales are available
SELECT 
    MIN(order_date) AS first_order, 
    MAX(order_date) AS last_order,
    EXTRACT(YEAR FROM MAX(order_date)) - EXTRACT(YEAR FROM MIN(order_date)) AS order_range_years
FROM gold.fact_sales;

-- Find the youngest and oldest birth date
SELECT 
	MIN(birth_date) AS yougest_birthdate,
	EXTRACT(YEAR FROM AGE(CURRENT_DATE, MIN(birth_date))) AS oldest_age,
	MAX(birth_date) AS oldest_birthdate,
	EXTRACT(YEAR FROM AGE(CURRENT_DATE, MAX(birth_date))) AS youngest_age
FROM gold.dim_customers;

-- Exploring the measures
-- Find the total sales
SELECT SUM(sales_amount) AS total_sales FROM gold.fact_sales;

-- Find how many items are sold
SELECT SUM(quantity) AS total_quantity FROM gold.fact_sales;

-- Find the average selling price
SELECT AVG(price) AS avg_price FROM gold.fact_sales;

-- Find the total number of orders
SELECT COUNT(order_number) AS total_orders FROM gold.fact_sales;
SELECT COUNT(DISTINCT order_number) AS total_orders FROM gold.fact_sales;

-- Find the total number of products
SELECT COUNT(DISTINCT product_key) AS total_products FROM gold.dim_products;

-- Find the total number of customers
SELECT COUNT(DISTINCT customer_id) AS total_customers FROM gold.dim_customers;

-- Find the total number of customers that has placed order
SELECT COUNT(DISTINCT customer_id) AS total_customers FROM gold.fact_sales;


-- Report/Conclusion
SELECT 'Total Sales' AS measure_name,  SUM(sales_amount) AS measure_value FROM gold.fact_sales
UNION ALL
SELECT 'Total Quantity',  SUM(quantity) FROM gold.fact_sales
UNION ALL
SELECT 'Total Price', AVG(price) FROM gold.fact_sales
UNION ALL
SELECT 'Total Orders', COUNT(DISTINCT order_number) FROM gold.fact_sales
UNION ALL
SELECT 'Total Products', COUNT(DISTINCT product_key) FROM gold.dim_products
UNION ALL
SELECT 'Total Cusomers', COUNT(DISTINCT customer_id) FROM gold.dim_customers
UNION ALL
SELECT 'Total No. Customers',COUNT(DISTINCT customer_id) FROM gold.fact_sales;


-- magnitude
-- Find the total customers by countries
SELECT 
	country,
	COUNT(customer_key) AS total_customers
FROM gold.dim_customers
GROUP BY country
ORDER BY total_customers DESC;

-- Find the customers by gender
SELECT 
	gender,
	COUNT(customer_key) AS total_customers
FROM gold.dim_customers
GROUP BY gender
ORDER BY total_customers DESC;

-- Find the total products by category
SELECT 
	category,
	COUNT(product_key) AS total_products
FROM gold.dim_products
GROUP BY category
ORDER BY total_products DESC;

-- What is the average cost in each category?
SELECT 
	category,
	AVG(price) AS avg_cost
FROM gold.dim_products
GROUP BY category
ORDER BY avg_cost DESC;

-- What is the total revenue generated by each category?
SELECT 
	SUM(f.sales_amount) AS total_revenue,
	p.category
FROM gold.fact_sales AS f
LEFT JOIN gold.dim_products AS p
ON p.product_key = f.product_key
GROUP BY p.category
ORDER BY 1, 2;

-- Find the total revenue generated by each customer
SELECT 
	c.customer_key,
	c.firstname, 
	c.lastname,
	SUM(f.sales_amount) AS total_revenue
FROM gold.fact_sales AS f
LEFT JOIN gold.dim_customers AS c
ON c.customer_key = f.customer_id
GROUP BY c.customer_key,
		 c.firstname, 
		 c.lastname
ORDER BY total_revenue DESC;


-- What is the distribution of sold items accross the contries
SELECT 
	c.country,
	SUM(f.quantity) AS total_sold_items
FROM gold.fact_sales AS f
LEFT JOIN gold.dim_customers AS c
ON c.customer_key = f.customer_id
GROUP BY c.country
ORDER BY total_sold_items DESC;


-- Ranking analysis
-- Which 5 products generate the highest revenue?
SELECT 
	p.product_name,
	SUM(f.sales_amount) AS total_revenue
FROM gold.fact_sales AS f
LEFT JOIN gold.dim_products AS p
ON p.product_key = f.product_key
GROUP BY p.product_name
ORDER BY total_revenue DESC
LIMIT 5;

SELECT * FROM(
	SELECT 
		p.product_name,
		SUM(f.sales_amount) AS total_revenue,
		ROW_NUMBER() OVER (ORDER BY SUM(f.sales_amount) DESC) AS rank_product
	FROM gold.fact_sales AS f
	LEFT JOIN gold.dim_products AS p
	ON p.product_key = f.product_key
	GROUP BY p.product_name
	ORDER BY total_revenue DESC
) WHERE rank_product <= 5;

-- Which are the 5-worst products generate in terms of sales?
SELECT 
	p.product_name,
	SUM(f.sales_amount) AS total_revenue
FROM gold.fact_sales AS f
LEFT JOIN gold.dim_products AS p
ON p.product_key = f.product_key
GROUP BY p.product_name
ORDER BY total_revenue
LIMIT 5;

-- Sub category
SELECT 
	p.sub_category,
	SUM(f.sales_amount) AS total_revenue
FROM gold.fact_sales AS f
LEFT JOIN gold.dim_products AS p
ON p.product_key = f.product_key
GROUP BY p.sub_category
ORDER BY total_revenue DESC
LIMIT 5;

SELECT 
	p.sub_category,
	SUM(f.sales_amount) AS total_revenue
FROM gold.fact_sales AS f
LEFT JOIN gold.dim_products AS p
ON p.product_key = f.product_key
GROUP BY p.sub_category
ORDER BY total_revenue
LIMIT 5;

-- Find the top 10 customers who have generated the highest revenue
SELECT 
	c.customer_key, 
	c.firstname,
	c.lastname,
	SUM(f.sales_amount) AS total_amount
FROM gold.fact_sales AS f
LEFT JOIN gold.dim_customers AS c
ON c.customer_key = f.customer_id
GROUP BY c.customer_key, 
		 c.firstname,
		 c.lastname
ORDER BY total_amount
LIMIT 5;

-- the 3 customers with fewest order placed
SELECT 
	c.customer_key, 
	c.firstname,
	c.lastname,
	COUNT(DISTINCT order_number) AS total_orders
FROM gold.fact_sales AS f
LEFT JOIN gold.dim_customers AS c
ON c.customer_key = f.customer_id
GROUP BY c.customer_key, 
		 c.firstname,
		 c.lastname
ORDER BY total_orders DESC
LIMIT 3;


SELECT * FROM gold.dim_products;

