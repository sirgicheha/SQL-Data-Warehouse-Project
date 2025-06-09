-- CRM Tables
-- Customer Info Table
-- Full load
TRUNCATE TABLE bronze.crm_cust_info;

BULK INSERT bronze.crm_cust_info
FROM 'D:\SQL-Data-Warehouse-Project\datasets\source_crm\cust_info.csv'
WITH (
	FIRSTROW = 2,
	FIELDTERMINATOR = ',',
	TABLOCK -- lock the table while inserting
);

SELECT COUNT(*)
FROM bronze.crm_cust_info;

SELECT *
FROM bronze.crm_cust_info;


-- Product Info Table
TRUNCATE TABLE bronze.crm_prd_info;

BULK INSERT bronze.crm_prd_info
FROM 'D:\SQL-Data-Warehouse-Project\datasets\source_crm\prd_info.csv'
WITH (
	FIRSTROW = 2,
	FIELDTERMINATOR = ',',
	TABLOCK -- lock the table while inserting
);

SELECT COUNT(*)
FROM bronze.crm_prd_info;

SELECT *
FROM bronze.crm_prd_info;


-- Sales Details Table
TRUNCATE TABLE bronze.crm_sales_details;

BULK INSERT bronze.crm_sales_details
FROM 'D:\SQL-Data-Warehouse-Project\datasets\source_crm\sales_details.csv'
WITH (
	FIRSTROW = 2,
	FIELDTERMINATOR = ',',
	TABLOCK -- lock the table while inserting
);


SELECT COUNT(*)
FROM bronze.crm_sales_details;

SELECT *
FROM bronze.crm_sales_details;



-- ERP Tables
-- Customer AZ12 Table
TRUNCATE TABLE bronze.erp_cust_az12;

BULK INSERT bronze.erp_cust_az12
FROM 'D:\SQL-Data-Warehouse-Project\datasets\source_erp\CUST_AZ12.csv'
WITH (
	FIRSTROW = 2,
	FIELDTERMINATOR = ',',
	TABLOCK -- lock the table while inserting
);

SELECT COUNT(*)
FROM bronze.erp_cust_az12;

SELECT *
FROM bronze.erp_cust_az12;




-- Loc A101 Table
TRUNCATE TABLE bronze.erp_loc_a101;

BULK INSERT bronze.erp_loc_a101
FROM 'D:\SQL-Data-Warehouse-Project\datasets\source_erp\LOC_A101.csv'
WITH (
	FIRSTROW = 2,
	FIELDTERMINATOR = ',',
	TABLOCK -- lock the table while inserting
);

SELECT COUNT(*)
FROM bronze.erp_loc_a101;

SELECT *
FROM bronze.erp_loc_a101;



-- Cat g1v2 Table
TRUNCATE TABLE bronze.erp_px_cat_g1v2;

BULK INSERT bronze.erp_px_cat_g1v2
FROM 'D:\SQL-Data-Warehouse-Project\datasets\source_erp\PX_CAT_G1V2.csv'
WITH (
	FIRSTROW = 2,
	FIELDTERMINATOR = ',',
	TABLOCK -- lock the table while inserting
);

SELECT COUNT(*)
FROM bronze.erp_px_cat_g1v2;

SELECT *
FROM bronze.erp_px_cat_g1v2;