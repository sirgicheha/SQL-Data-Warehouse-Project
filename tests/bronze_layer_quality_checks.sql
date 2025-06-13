-- Customer Information Table
-- Check for Nulls or Duplicates in the Primary Key
-- Expectation: No Result
SELECT cst_id, COUNT(*)
FROM bronze.crm_cust_info
GROUP BY cst_id
HAVING COUNT(*) > 1;

-- Check for unwanted spaces
-- Expectation: No Result
SELECT cst_firstname
FROM bronze.crm_cust_info
WHERE cst_firstname != TRIM(cst_firstname)

-- Data Standardziation and Consistency
SELECT DISTINCT cst_gndr
FROM bronze.crm_cust_info;






-- Product Information Table
SELECT *
FROM bronze.crm_prd_info;

-- Check for Nulls or Duplicates in the Primary Ket
-- Expectation: No Result
SELECT prd_id,COUNT(*)
FROM bronze.crm_prd_info
GROUP BY prd_id
HAVING COUNT(*) > 1;

-- Check for unwanted spaces
-- Expectation: No Result
SELECT prd_nm
FROM bronze.crm_prd_info
WHERE prd_nm != TRIM(prd_nm)

-- Check for Nulls or Negative numbers
-- Expectation: No result
SELECT prd_cost
FROM bronze.crm_prd_info
WHERE prd_cost < 0 OR prd_cost IS NULL

-- Data Standardziation and Consistency
SELECT DISTINCT prd_line
FROM bronze.crm_prd_info;


SELECT * FROM bronze.crm_prd_info
WHERE prd_end_dt < prd_start_dt




--- Sales Details Table
  -- Check for Invalid Dates
SELECT sls_due_dt
FROM bronze.crm_sales_details
WHERE sls_due_dt <= 0 or LEN(sls_due_dt) != 8;

SELECT 
NULLIF(sls_ship_dt, 0) sls_ship_dt
FROM bronze.crm_sales_details
WHERE sls_ship_dt <= 0 or LEN(sls_ship_dt) != 8;
  
  -- Check for inconsistent order dates
SELECT *
FROM bronze.crm_sales_details
WHERE (sls_due_dt < sls_order_dt) OR (sls_ship_dt < sls_order_dt)

 -- Check for validity of transactions; whether the price, quantity and sales price relate
SELECT sls_price, sls_quantity, sls_sales
FROM bronze.crm_sales_details
WHERE sls_sales != (sls_price * sls_quantity) 
		OR sls_price IS NULL OR sls_quantity IS NULL OR sls_sales IS NULL
		OR sls_price <= 0 OR sls_quantity <= 0 OR sls_sales <= 0
ORDER BY sls_sales, sls_quantity, sls_price;



--- ERP Additional Customer Info Table
-- Check for unique Customer IDs
SELECT cid, COUNT(*)
FROM bronze.erp_cust_az12
GROUP BY cid
HAVING COUNT(*) > 1;
 
 -- Match with format in cutomer info table for joining
SELECT SUBSTRING(cid,4, LEN(cid)) AS cid
FROM bronze.erp_cust_az12;

-- Check for invalid dates
SELECT bdate
FROM bronze.erp_cust_az12
WHERE bdate > GETDATE();

--- Check genders
SELECT DISTINCT gen,
CASE WHEN UPPER(TRIM(gen)) IN ('F', 'FEMALE') THEN 'Female'
		WHEN UPPER(TRIM(gen)) IN ('M', 'MALE') THEN 'Male'
		ELSE 'Unknown'
	END AS gen
FROM bronze.erp_cust_az12;

SELECT *
FROM bronze.erp_cust_az12





--- ERP Customer Location Info
SELECT *
FROM bronze.erp_loc_a101;


SELECT DISTINCT cntry,
CASE WHEN TRIM(UPPER(cntry)) IN ('USA','UNITED STATES','US') THEN 'United States'
		WHEN TRIM(UPPER(cntry)) IN ('DE','GERMANY') THEN 'Germany'
		WHEN TRIM(cntry) = '' OR cntry IS NULL THEN 'Unknown'
		ELSE TRIM(cntry)
END AS cntry
FROM bronze.erp_loc_a101;





--- ERP product Categories Table
SELECT *
FROM bronze.erp_px_cat_g1v2
WHERE id NOT IN (SELECT cat_id FROM silver.crm_prd_info);

SELECT *
FROM silver.crm_prd_info;

-- Check for unique values in each column
SELECT DISTINCT cat
FROM bronze.erp_px_cat_g1v2;


-- Check for Unwanted Spaces
SELECT * FROM bronze.erp_px_cat_g1v2
WHERE cat != TRIM(cat) OR subcat != TRIM(subcat) OR maintenance != TRIM(maintenance);