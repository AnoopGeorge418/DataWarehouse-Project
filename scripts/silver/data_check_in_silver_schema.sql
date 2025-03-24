-- Data Check in Silver schema crm_cust_info:
	
SELECT cst_id, 	COUNT(*) FROM silver.crm_cust_info
GROUP BY cst_id
HAVING COUNT(*) > 1 OR cst_id IS NULL;

-- 2. check unwanted spaces
-- all good
SELECT cst_firstname FROM silver.crm_cust_info
WHERE cst_firstname != TRIM(cst_firstname);

-- all good
SELECT cst_lastname FROM silver.crm_cust_info
WHERE cst_lastname != TRIM(cst_lastname);

-- all good
SELECT cst_marital_status FROM silver.crm_cust_info
WHERE cst_marital_status != TRIM(cst_marital_status);

SELECT DISTINCT cst_marital_status FROM silver.crm_cust_info;

-- all good
SELECT cst_gndr FROM silver.crm_cust_info
WHERE cst_gndr != TRIM(cst_gndr);

SELECT DISTINCT cst_gndr FROM silver.crm_cust_info;


SELECT * FROM silver.crm_cust_info;

-- Data Check in Silver schema crm_prd_info:

-- 1. checking for duplicates and null values - no null values and duplicates in primary key
SELECT prd_id, 	COUNT(*) FROM silver.crm_prd_info
GROUP BY prd_id
HAVING COUNT(*) > 1 OR prd_id IS NULL;

-- 2. Checking for unwanted space and more in prd_nm column - all good
SELECT prd_nm FROM silver.crm_prd_info
WHERE prd_nm != TRIM(prd_nm);

-- 3. Checking quality of prd_cost column - No negative values but has 2 null values
SELECT DISTINCT prd_cost FROM silver.crm_prd_info;

SELECT prd_cost FROM silver.crm_prd_info
WHERE prd_cost < 0 OR prd_cost IS NULL;

-- 4. standardizing and consosting prd_line
SELECT DISTINCT prd_line FROM silver.crm_prd_info;

-- 5 and 6 - quality of start and end date
SELECT * FROM silver.crm_prd_info
WHERE prd_end_dt < prd_start_dt;

SELECT * FROM silver.crm_prd_info;

-- Data Check in Silver schema erp_cust_az12:
SELECT * FROM silver.erp_cust_az12;

-- Data Check in Silver schema erp_loc_a101:
SELECT * FROM silver.erp_loc_a101;

-- Data Check in Silver schema erp_px_cat_g1v2:
SELECT * FROM silver.erp_px_cat_g1v2;