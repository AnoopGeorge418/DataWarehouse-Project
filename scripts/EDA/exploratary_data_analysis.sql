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



SELECT * FROM gold.dim_products;