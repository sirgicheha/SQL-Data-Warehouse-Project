-- Customer Information Table
-- Check for Nulls or Duplicates in the Primary Ket
SELECT cst_id, COUNT(*)
FROM bronze.crm_cust_info
GROUP BY cst_id
HAVING COUNT(*) > 1;

-- Check for unwanted spaces
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
SELECT prd_id,C*)
FROM bronze.crm_cust_info
GROUP BY cst_id
HAVING COUNT(*) > 1;

-- Check for unwanted spaces
SELECT cst_firstname
FROM bronze.crm_cust_info
WHERE cst_firstname != TRIM(cst_firstname)

-- Data Standardziation and Consistency
SELECT DISTINCT cst_gndr
FROM bronze.crm_cust_info;
