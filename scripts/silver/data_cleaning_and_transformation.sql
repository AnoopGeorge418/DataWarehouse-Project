-- Data Cleaning On crm_cust_info table:
	-- 1. Check for Null or Duplicates Values and all else in each column.
	
SELECT cst_id, 	COUNT(*) FROM bronze.crm_cust_info
GROUP BY cst_id
HAVING COUNT(*) > 1 OR cst_id IS NULL;

-- I need only 1 record which is latest here 3rd record is latest cause its date is 2026-01-27 - we can do cleaning on this id by ranking it FIRST and we can get the first record 
SELECT * FROM bronze.crm_cust_info
WHERE cst_id = 29466;

SELECT * FROM (
	SELECT *,
	ROW_NUMBER() OVER(PARTITION BY cst_id ORDER BY cst_create_date DESC) AS flag_last
	FROM bronze.crm_cust_info
) WHERE flag_last = 1 AND cst_id = 29477;

-- 2. check unwanted spaces

-- has spaces
SELECT cst_firstname FROM bronze.crm_cust_info
WHERE cst_firstname != TRIM(cst_firstname);

-- has spaces
SELECT cst_lastname FROM bronze.crm_cust_info
WHERE cst_lastname != TRIM(cst_lastname);

-- has no spaces but have null values and values are like s, m
SELECT cst_marital_status FROM bronze.crm_cust_info
WHERE cst_marital_status != TRIM(cst_marital_status);

SELECT DISTINCT cst_marital_status FROM bronze.crm_cust_info;

-- has no spaces but have null values and values are like m, f
SELECT cst_gndr FROM bronze.cst_gndr
WHERE cst_gndr != TRIM(cst_gndr);

SELECT DISTINCT cst_gndr FROM bronze.crm_cust_info;

SELECT * FROM bronze.crm_cust_info;


-- Data Cleaning On crm_cust_info table:
	-- 1. Check for Null or Duplicates Values and all else in each column.

-- 1. checking for duplicates and null values - no null values and duplicates in primary key
SELECT prd_id, 	COUNT(*) FROM bronze.crm_prd_info
GROUP BY prd_id
HAVING COUNT(*) > 1 OR prd_id IS NULL;

-- 2. Checking for unwanted space and more in prd_nm column - all good
SELECT prd_nm FROM bronze.crm_prd_info
WHERE prd_nm != TRIM(prd_nm);

-- 3. Checking quality of prd_cost column - No negative values but has 2 null values
SELECT DISTINCT prd_cost FROM bronze.crm_prd_info;

SELECT prd_cost FROM bronze.crm_prd_info
WHERE prd_cost < 0 OR prd_cost IS NULL;

-- 4. standardizing and consosting prd_line
SELECT DISTINCT prd_line FROM bronze.crm_prd_info;

-- 5 and 6 - quality of start and end date
SELECT * FROM bronze.crm_prd_info
WHERE prd_end_dt < prd_start_dt;


-- For comparing this with above add it to end
WHERE REPLACE(SUBSTRING(prd_key, 1, 5), '-', '_') NOT IN 
(SELECT DISTINCT id FROM bronze.erp_px_cat_g1v2);	

SELECT DISTINCT id FROM bronze.erp_px_cat_g1v2;
--------
SELECT sls_prd_key FROM bronze.crm_sales_details;

WHERE SUBSTRING(prd_key, 7, LENGTH(prd_key)) IN 
(SELECT sls_prd_key FROM bronze.crm_sales_details);
--------

SELECT * FROM bronze.crm_prd_info;

-- Data Check in bronze schema crm_sales_deatils:
-- Fixing dates column
SELECT 
	NULLIF(sls_order_dt, 0) sls_order_dt
FROM bronze.crm_sales_details
WHERE sls_order_dt <= 0 
	  OR LENGTH(CAST(sls_order_dt AS TEXT)) != 8 
	  OR sls_order_dt > 20500101 
	  OR sls_order_dt < 19000101;

SELECT 
	NULLIF(sls_ship_dt, 0) sls_ship_dt
FROM bronze.crm_sales_details
WHERE sls_ship_dt <= 0 
	  OR LENGTH(CAST(sls_ship_dt AS TEXT)) != 8 
	  OR sls_ship_dt > 20500101 
	  OR sls_ship_dt < 19000101;

SELECT 
	NULLIF(sls_due_dt, 0) sls_due_dt
FROM bronze.crm_sales_details
WHERE sls_due_dt <= 0 
	  OR LENGTH(CAST(sls_due_dt AS TEXT)) != 8 
	  OR sls_due_dt > 20500101 
	  OR sls_due_dt < 19000101;

SELECT DISTINCT
	   sls_sales AS old_sls_sales, 
	   sls_quantity,
	   sls_price AS old_sls_price,
	   CASE WHEN sls_sales IS NULL OR sls_sales <=0 OR sls_sales != sls_quantity * ABS(sls_price) THEN sls_quantity * ABS(sls_price)
	   		ELSE sls_sales
	   END sls_sales,
	   CASE WHEN sls_price IS NULL OR sls_price <=0 THEN sls_sales / NULLIF(sls_quantity, 0)
	   		ELSE sls_price
	   END sls_price
FROM bronze.crm_sales_details
WHERE sls_sales != sls_quantity * sls_price
	  OR sls_sales IS NULL 
	  OR sls_quantity IS NULL 
	  OR sls_price IS NULL
	  OR sls_sales <= 0
	  OR sls_quantity <= 0
	  OR sls_price <= 0
ORDER BY sls_sales,
		 sls_quantity,
		 sls_price;

SELECT * FROM bronze.crm_sales_details;

-- Data Check in bronze schema erp_cust_az12:
SELECT DISTINCT
	   bdate
FROM bronze.erp_cust_az12
WHERE bdate < '1924-01-01' OR bdate > CURRENT_DATE;

SELECT DISTINCT
	   gen,
	   CASE WHEN TRIM(UPPER(gen)) IN ('F', 'Female') THEN 'Female'
	   		WHEN TRIM(UPPER(gen)) IN ('M', 'Male') THEN 'Male'
	   		ELSE 'n/a'
	   END AS gen
FROM bronze.erp_cust_az12;

SELECT * FROM bronze.erp_cust_az12;

-- Data Check in bronze schema erp_cust_az12:
SELECT 
	cid, 
	REPLACE(cid, '-', '') AS cid
FROM bronze.erp_loc_a101
WHERE REPLACE(cid, '-', '') NOT IN (
	SELECT cst_key FROM silver.crm_cust_info
);

SELECT DISTINCT
    cntry,
    CASE 
        WHEN TRIM(UPPER(cntry)) = 'DE' THEN 'Germany'
        WHEN TRIM(UPPER(cntry)) IN ('US', 'USA') THEN 'United States'
        WHEN COALESCE(TRIM(cntry), '') = '' OR cntry = '[null]' THEN 'n/a'
        ELSE TRIM(cntry)
    END AS cntry_transformed
FROM bronze.erp_loc_a101
ORDER BY cntry_transformed;

-- Data Check in bronze schema erp_cust_az12:
SELECT DISTINCT 
	id 
FROM bronze.erp_px_cat_g1v2;

SELECT DISTINCT 
	cat 
FROM bronze.erp_px_cat_g1v2
WHERE cat != TRIM(cat);

SELECT DISTINCT 
	subcat 
FROM bronze.erp_px_cat_g1v2
WHERE subcat != TRIM(subcat);

SELECT DISTINCT 
	maintenance 
FROM bronze.erp_px_cat_g1v2
WHERE maintenance != TRIM(maintenance);