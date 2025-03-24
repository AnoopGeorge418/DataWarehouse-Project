SELECT DISTINCT 
	ci.cst_gndr,
	ca.gen
FROM silver.crm_cust_info AS ci
LEFT JOIN silver.erp_cust_az12 AS ca
ON 		  ci.cst_key = ca.cid
LEFT JOIN silver.erp_loc_a101 AS la
ON 		  ci.cst_key = la.cid 
ORDER BY 1, 2