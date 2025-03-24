/*
===============================================================================
Stored Procedure: Load Bronze Layer (Source -> Bronze)
===============================================================================
Script Purpose:
    This stored procedure loads data into the 'bronze' schema from external CSV files. 
    It performs the following actions:
    - Truncates the bronze tables before loading data.
    - Uses the `COPY` command to load data from CSV files into bronze tables.

Parameters:
    None. 
    This stored procedure does not accept any parameters or return any values.

Usage Example:
    CALL bronze.load_bronze();
===============================================================================
*/

CREATE OR REPLACE PROCEDURE bronze.load_bronze()
LANGUAGE plpgsql
AS $$
DECLARE
    start_time TIMESTAMP;
    end_time TIMESTAMP;
    batch_start_time TIMESTAMP := clock_timestamp();
    batch_end_time TIMESTAMP;
	
BEGIN
    RAISE NOTICE '=============================================';
    RAISE NOTICE 'Loading Bronze Layer';
    RAISE NOTICE '=============================================';

    -- CRM TABLES
    RAISE NOTICE '---------------------------------------------';
    RAISE NOTICE 'Loading CRM Tables';
    RAISE NOTICE '---------------------------------------------';

    -- CRM Customer Info
    start_time := clock_timestamp();
    RAISE NOTICE '>> Truncating Table: bronze.crm_cust_info';
    TRUNCATE TABLE bronze.crm_cust_info;
	
    RAISE NOTICE '>> Inserting Data Into: bronze.crm_cust_info';
    EXECUTE format('COPY bronze.crm_cust_info FROM %L WITH CSV HEADER DELIMITER '','' ', 
            'C:\Users\anoop\datawarehousing\sql-data-warehouse-project\datasets\source_crm\cust_info.csv');
			
    end_time := clock_timestamp();
    RAISE NOTICE '>> Load Duration: % seconds', extract(epoch FROM (end_time - start_time));

    -- CRM Product Info
    start_time := clock_timestamp();
    RAISE NOTICE '>> Truncating Table: bronze.crm_prd_info';
    TRUNCATE TABLE bronze.crm_prd_info;
	
    RAISE NOTICE '>> Inserting Data Into: bronze.crm_prd_info';
    EXECUTE format('COPY bronze.crm_prd_info FROM %L WITH CSV HEADER DELIMITER '','' ', 
            'C:\Users\anoop\datawarehousing\sql-data-warehouse-project\datasets\source_crm\prd_info.csv');
			
    end_time := clock_timestamp();
    RAISE NOTICE '>> Load Duration: % seconds', extract(epoch FROM (end_time - start_time));

    -- CRM Sales Details
    start_time := clock_timestamp();
    RAISE NOTICE '>> Truncating Table: bronze.crm_sales_details';
    TRUNCATE TABLE bronze.crm_sales_details;
	
    RAISE NOTICE '>> Inserting Data Into: bronze.crm_sales_details';
    EXECUTE format('COPY bronze.crm_sales_details FROM %L WITH CSV HEADER DELIMITER '','' ', 
            'C:\Users\anoop\datawarehousing\sql-data-warehouse-project\datasets\source_crm\sales_details.csv');
			
    end_time := clock_timestamp();
    RAISE NOTICE '>> Load Duration: % seconds', extract(epoch FROM (end_time - start_time));

    -- ERP TABLES
    RAISE NOTICE '---------------------------------------------';
    RAISE NOTICE 'Loading ERP Tables';
    RAISE NOTICE '---------------------------------------------';

    -- ERP Location
    start_time := clock_timestamp();
    RAISE NOTICE '>> Truncating Table: bronze.erp_loc_a101';
    TRUNCATE TABLE bronze.erp_loc_a101;
	
    RAISE NOTICE '>> Inserting Data Into: bronze.erp_loc_a101';
    EXECUTE format('COPY bronze.erp_loc_a101 FROM %L WITH CSV HEADER DELIMITER '','' ', 
            'C:\Users\anoop\datawarehousing\sql-data-warehouse-project\datasets\source_erp\LOC_A101.csv');
			
    end_time := clock_timestamp();
    RAISE NOTICE '>> Load Duration: % seconds', extract(epoch FROM (end_time - start_time));

    -- ERP Customer AZ12
    start_time := clock_timestamp();
    RAISE NOTICE '>> Truncating Table: bronze.erp_cust_az12';
    TRUNCATE TABLE bronze.erp_cust_az12;
	
    RAISE NOTICE '>> Inserting Data Into: bronze.erp_cust_az12';
    EXECUTE format('COPY bronze.erp_cust_az12 FROM %L WITH CSV HEADER DELIMITER '','' ', 
            'C:\Users\anoop\datawarehousing\sql-data-warehouse-project\datasets\source_erp\CUST_AZ12.csv');
			
    end_time := clock_timestamp();
    RAISE NOTICE '>> Load Duration: % seconds', extract(epoch FROM (end_time - start_time));

    -- ERP Product Category
    start_time := clock_timestamp();
    RAISE NOTICE '>> Truncating Table: bronze.erp_px_cat_g1v2';
    TRUNCATE TABLE bronze.erp_px_cat_g1v2;
	
    RAISE NOTICE '>> Inserting Data Into: bronze.erp_px_cat_g1v2';
    EXECUTE format('COPY bronze.erp_px_cat_g1v2 FROM %L WITH CSV HEADER DELIMITER '','' ', 
            'C:\Users\anoop\datawarehousing\sql-data-warehouse-project\datasets\source_erp\PX_CAT_G1V2.csv');
			
    end_time := clock_timestamp(); 
    RAISE NOTICE '>> Load Duration: % seconds', extract(epoch FROM (end_time - start_time));

    batch_end_time := clock_timestamp();
	
    RAISE NOTICE '=============================================';
    RAISE NOTICE 'Loading Bronze Layer is Completed';
    RAISE NOTICE '   - Total Load Duration: % seconds', extract(epoch FROM (batch_end_time - batch_start_time));
    RAISE NOTICE '=============================================';

EXCEPTION
    WHEN OTHERS THEN
        RAISE NOTICE '=============================================';
        RAISE NOTICE 'ERROR OCCURRED DURING LOADING BRONZE LAYER';
        RAISE NOTICE 'Error Message: %', SQLERRM;
        RAISE NOTICE '=============================================';
END;
$$;


CALL bronze.load_bronze();
