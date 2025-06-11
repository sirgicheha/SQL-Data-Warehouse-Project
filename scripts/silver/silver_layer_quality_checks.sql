-- Customer Information Table
-- Check for Nulls or Duplicates in the Primary Ket
SELECT cst_key, COUNT(*)
FROM silver.crm_cust_info
GROUP BY cst_key
HAVING COUNT(*) > 1;

-- Check for unwanted spaces
SELECT cst_firstname
FROM silver.crm_cust_info
WHERE cst_firstname != TRIM(cst_firstname)

-- Data Standardziation and Consistency
SELECT DISTINCT cst_gndr
FROM silver.crm_cust_info;

SELECT *
FROM silver.crm_cust_info;





-- Product Information Table
SELECT *
FROM silver.crm_prd_info;

-- Check for Nulls or Duplicates in the Primary Ket
-- Expectation: No Result
SELECT prd_id,COUNT(*)
FROM silver.crm_prd_info
GROUP BY prd_id
HAVING COUNT(*) > 1;

-- Check for unwanted spaces
-- Expectation: No Result
SELECT prd_nm
FROM silver.crm_prd_info
WHERE prd_nm != TRIM(prd_nm)

-- Check for Nulls or Negative numbers
-- Expectation: No result
SELECT prd_cost
FROM silver.crm_prd_info
WHERE prd_cost < 0 OR prd_cost IS NULL

-- Data Standardziation and Consistency
SELECT DISTINCT prd_line
FROM silver.crm_prd_info;


SELECT * FROM silver.crm_prd_info
WHERE prd_end_dt < prd_start_dt





-- Sales Details Table
  -- Check for inconsistent order dates
SELECT *
FROM silver.crm_sales_details
WHERE (sls_due_dt < sls_order_dt) OR (sls_ship_dt < sls_order_dt)

 -- Check for validity of transactions; whether the price, quantity and sales price relate
SELECT sls_price, sls_quantity, sls_sales
FROM silver.crm_sales_details
WHERE sls_sales != (sls_price * sls_quantity) 
		OR sls_price IS NULL OR sls_quantity IS NULL OR sls_sales IS NULL
		OR sls_price <= 0 OR sls_quantity <= 0 OR sls_sales <= 0
ORDER BY sls_sales, sls_quantity, sls_price;


SELECT *
FROM silver.crm_sales_details





--- ERP Additional Customer Information
-- Check for unique Customer IDs
SELECT cid, COUNT(*)
FROM silver.erp_cust_az12
GROUP BY cid
HAVING COUNT(*) > 1;
 
-- Check for invalid dates
SELECT bdate
FROM silver.erp_cust_az12
WHERE bdate > GETDATE();

--- Check genders
SELECT DISTINCT gen
FROM silver.erp_cust_az12;

SELECT *
FROM silver.erp_cust_az12






--- ERP Customer Location Info
SELECT DISTINCT cntry
FROM silver.erp_loc_a101;

SELECT *
FROM silver.erp_loc_a101;





--- --- ERP Product Categories Table
SELECT *
FROM silver.erp_px_cat_g1v2
WHERE id NOT IN (SELECT cat_id FROM silver.crm_prd_info);

SELECT *
FROM silver.crm_prd_info;

-- Check for unique values in each column
SELECT DISTINCT cat
FROM silver.erp_px_cat_g1v2;


-- Check for Unwanted Spaces
SELECT * FROM silver.erp_px_cat_g1v2
WHERE cat != TRIM(cat) OR subcat != TRIM(subcat) OR maintenance != TRIM(maintenance);


SELECT * 
FROM silver.erp_px_cat_g1v2