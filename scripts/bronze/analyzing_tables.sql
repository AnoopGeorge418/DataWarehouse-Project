-- cust_info - table contains "deatils and descriptions of customers"

SELECT * FROM bronze.crm_cust_info
LIMIT 1000;


-- prd_info - table contains "history of products"

SELECT * FROM bronze.crm_prd_info
LIMIT 1000;

-- sales_details - table contains "transaction details of sales - can be used to connect with other tables"

SELECT * FROM bronze.crm_sales_details
LIMIT 1000;

-- cust_az12 - table contains "Extra deatails about the customer"

SELECT * FROM bronze.erp_cust_az12
LIMIT 1000;

-- loc_a101 - table contains "location of customer"

SELECT * FROM bronze.erp_loc_a101
LIMIT 1000;

-- cat_g1v2 - table contains "location of customer"

SELECT * FROM bronze.erp_px_cat_g1v2
LIMIT 1000;
