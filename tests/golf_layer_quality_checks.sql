-- Check if they're duplicates
SELECT cst_key, COUNT(*)
FROM (
		SELECT 
			ci.cst_key,
			ci.cst_firstname,
			ci.cst_lastname,
			ci.cst_marital_status,
			ci.cst_gndr,
			ci.cst_create_date,
			ce.bdate,
			ce.gen,
			la.cntry
		FROM silver.crm_cust_info ci
		LEFT JOIN silver.erp_cust_az12 ce
		ON		  ci.cst_key = ce.cid
		LEFT JOIN silver.erp_loc_a101 la
		ON		  ci.cst_key = la.cid
		) test
GROUP BY cst_key
HAVING COUNT(*) > 1;



SELECT prd_key, COUNT(*) 
FROM
(
SELECT 
	pr.prd_id,
	pr.cat_id,
	pr.prd_key,
	pr.prd_nm,
	pr.prd_cost,
	pr.prd_line,
	ca.cat,
	ca.subcat,
	ca.maintenance,
	pr.prd_start_dt
FROM silver.crm_prd_info pr
LEFT JOIN silver.erp_px_cat_g1v2 ca
ON		pr.cat_id = ca.id
WHERE pr.prd_end_dt IS NULL
) test
GROUP BY prd_key
HAVING COUNT(*) > 1;

SELECT DISTINCT
	ci.cst_gndr,
	ce.gen,
	CASE WHEN ci.cst_gndr != 'n/a' THEN ci.cst_gndr
		ELSE COALESCE(ce.gen,'n/a')
	END AS new_gen
FROM silver.crm_cust_info ci
LEFT JOIN silver.erp_cust_az12 ce
ON		  ci.cst_key = ce.cid
LEFT JOIN silver.erp_loc_a101 la
ON		  ci.cst_key = la.cid
ORDER BY 1,2
;


SELECT *
FROM gold.dim_customers;

SELECT DISTINCT gender FROM gold.dim_customers

SELECT *
FROM gold.dim_products;


SELECT *
FROM gold.fact_sales;

SELECT *
FROM gold.fact_sales f
LEFT JOIN gold.dim_customers c
ON		c.customer_key = f.customer_key
WHERE c.customer_key IS NULL

SELECT *
FROM gold.fact_sales f
LEFT JOIN gold.dim_products p
ON		p.product_key = f.product_key
WHERE p.product_key IS NULL

