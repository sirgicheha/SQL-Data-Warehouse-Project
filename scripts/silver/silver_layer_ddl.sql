INSERT INTO silver.crm_cust_info (
	cst_id,
	cst_key,
	cst_firstname,
	cst_lastname,
	cst_marital_status,
	cst_gndr,
	cst_create_date)

SELECT cst_id,
	cst_key,
	TRIM(cst_firstname) AS cst_firstname,
	TRIM(cst_lastname) AS cst_lastname,
	CASE WHEN UPPER(TRIM(cst_gndr)) = 'S' THEN 'Single'
		WHEN UPPER(TRIM(cst_gndr)) = 'M' THEN 'Married'
		ELSE 'Unknown'
		END AS cst_marital_status,
	CASE WHEN UPPER(TRIM(cst_gndr)) = 'F' THEN 'Female'
		WHEN UPPER(TRIM(cst_gndr)) = 'M' THEN 'Male'
		ELSE 'Unknown'
		END AS cst_gndr,
	cst_create_date
FROM (SELECT *,
ROW_NUMBER() OVER (PARTITION BY cst_id ORDER BY cst_create_date) AS flagged 
FROM bronze.crm_cust_info) T
WHERE flagged = 1;

SELECT *
FROM silver.crm_cust_info;