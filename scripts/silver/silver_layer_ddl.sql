EXEC silver.load_silver

CREATE OR ALTER PROCEDURE silver.load_silver AS
BEGIN

		PRINT '>> Truncating Table: silver.crm_cust_info';
		TRUNCATE TABLE silver.crm_cust_info;
		PRINT '>> Inserting Data into: silver.crm_cust_info';
		-- Customer Information Table
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
				END AS cst_gndr, -- Mapping gender and marital status to descriptive values
			cst_create_date
		FROM (SELECT *,
		ROW_NUMBER() OVER (PARTITION BY cst_id ORDER BY cst_create_date) AS flagged 
		FROM bronze.crm_cust_info) T --Removing duplicate rows
		WHERE flagged = 1;





		PRINT '>> Truncating Table: silver.crm_prd_info';
		TRUNCATE TABLE silver.crm_prd_info;
		PRINT '>> Inserting Data into: silver.crm_prd_info';
		-- Product Information Table
		INSERT INTO silver.crm_prd_info (
			   prd_id
			  ,cat_id
			  ,prd_key
			  ,prd_nm
			  ,prd_cost
			  ,prd_line
			  ,prd_start_dt
			  ,prd_end_dt)


		SELECT prd_id,
			  REPLACE(SUBSTRING(prd_key, 1, 5), '-', '_') AS cat_id,  -- Separating out the category id for joining with erp category details
			  SUBSTRING(prd_key, 7, LEN(prd_key)) AS prd_key,  -- Separating out the product key for joining with crm sales details
			  prd_nm,
			  ISNULL(prd_cost, 0) AS prd_cost,
			  CASE WHEN UPPER(TRIM(prd_line)) = 'M' THEN 'Mountain'
					WHEN UPPER(TRIM(prd_line)) = 'R' THEN 'Road'
					WHEN UPPER(TRIM(prd_line)) = 'S' THEN 'Other Sales'
					WHEN UPPER(TRIM(prd_line)) = 'T' THEN 'Touring'
					ELSE 'Unkown'
					END AS prd_line, -- Mapping out the product line to descriptive values
			  CAST(prd_start_dt AS DATE) AS prd_start_dt,
			  -- Making sure that the timeline matches up for a product with multiple entries depicting chage of price over time
			  CAST(LEAD(prd_start_dt) OVER (PARTITION BY prd_key ORDER BY prd_start_dt)-1 AS DATE) AS prd_end_dt
		  FROM bronze.crm_prd_info


 
 

		 PRINT '>> Truncating Table: silver.crm_sales_details';
		TRUNCATE TABLE silver.crm_sales_details;
		PRINT '>> Inserting Data into: silver.crm_sales_details';
		  -- Sales Details Table
		  INSERT INTO silver.crm_sales_details (
					sls_ord_num,
					sls_prd_key,
					sls_cust_id,
					sls_order_dt,
					sls_ship_dt,
					sls_due_dt,
					sls_sales,
					sls_quantity,
					sls_price
					)

		SELECT sls_ord_num,
			  sls_prd_key,
			  sls_cust_id,
			  CASE WHEN sls_order_dt = 0 OR LEN(sls_order_dt) != 8 THEN NULL  -- Handling invalid dates and casting order date to date
					ELSE CAST(CAST(sls_order_dt AS VARCHAR) AS DATE)
			  END AS sls_order_dt,
			  CASE WHEN sls_ship_dt = 0 OR LEN(sls_ship_dt) != 8 THEN NULL  -- Handling invalid dates and casting shipping date to date
					ELSE CAST(CAST(sls_ship_dt AS VARCHAR) AS DATE)
			  END AS sls_ship_dt,
			  CASE WHEN sls_due_dt = 0 OR LEN(sls_due_dt) != 8 THEN NULL   -- Handling invalid dates and casting due date to date
					ELSE CAST(CAST(sls_due_dt AS VARCHAR) AS DATE)
			  END AS sls_due_dt,
			  /* Making sure that sales = quantity * price logic holds up by using 2 rules:
			  If sales is null or a negative number recalculate using quantity and a positive price
			  If price is null or negative recalculate by dividing sales by quantity
			  */
			  CASE WHEN sls_sales IS NULL OR sls_sales <= 0 OR sls_sales != sls_quantity * ABS(sls_price)
						THEN sls_quantity * ABS(sls_price)
					ELSE sls_sales
			  END sls_sales,
			  sls_quantity,
			  CASE WHEN sls_price IS NULL OR sls_price <= 0
						THEN ABS(sls_sales)/NULLIF(sls_quantity,0)
					ELSE sls_price
			  END AS sls_price 
		FROM bronze.crm_sales_details







		PRINT '>> Truncating Table: silver.erp_cust_az12';
		TRUNCATE TABLE silver.erp_cust_az12;
		PRINT '>> Inserting Data into: silver.erp_cust_az12';
		--- ERP Additional Customer Information
		INSERT INTO silver.erp_cust_az12 (
				cid,
				bdate,
				gen)

		SELECT
			CASE WHEN cid LIKE 'NAS%'  -- Trimming the NAS that was precedent to the customer key to make sure joinning tables is easy
					THEN SUBSTRING(cid,4, LEN(cid))
				ELSE cid
			END AS cid,
			CASE WHEN bdate > GETDATE() THEN NULL -- Handling future dates
				ELSE bdate
			END AS bdate,
			CASE WHEN UPPER(TRIM(gen)) IN ('F', 'FEMALE') THEN 'Female' -- Standardizing the gender information
				WHEN UPPER(TRIM(gen)) IN ('M', 'MALE') THEN 'Male'
				ELSE 'Unknown'
			END AS gen
		FROM bronze.erp_cust_az12







		PRINT '>> Truncating Table: silver.erp_loc_a101';
		TRUNCATE TABLE silver.erp_loc_a101;
		PRINT '>> Inserting Data into: silver.erp_loc_a101';
		--- ERP Customer Location Info
		INSERT INTO silver.erp_loc_a101 (
				cid, cntry)

		SELECT 
		REPLACE(cid, '-','') AS cid,  -- Removing dash to match customer id in cutomer info table
		-- Standardize Countries
		CASE WHEN TRIM(UPPER(cntry)) IN ('USA','UNITED STATES','US') THEN 'United States'
				WHEN TRIM(UPPER(cntry)) IN ('DE','GERMANY') THEN 'Germany'
				WHEN TRIM(cntry) = '' OR cntry IS NULL THEN 'Unknown'
				ELSE TRIM(cntry)
		END AS cntry
		FROM bronze.erp_loc_a101;






		PRINT '>> Truncating Table: silver.erp_px_cat_g1v2';
		TRUNCATE TABLE silver.erp_px_cat_g1v2;
		PRINT '>> Inserting Data into: silver.erp_px_cat_g1v2';
		--- ERP Product Categories Table
		INSERT INTO silver.erp_px_cat_g1v2 (id,cat,subcat,maintenance)

		SELECT id, cat, subcat, maintenance
		FROM bronze.erp_px_cat_g1v2;
END