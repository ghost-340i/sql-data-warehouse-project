BULK INSERT Bronze.crm_cust_info
FROM 'D:\Rohit Satpute\SQL data Warehousing Project Practice\sql-data-warehouse-project\datasets\source_crm\cust_info.CSV'
WITH (
	FIRSTROW = 2,
	FIELDTERMINATOR = ',',
	TABLOCK
);

SELECT * FROM Bronze.crm_cust_info;

-- For refresh the Bronze Layer you have to truncate the table and run the bulk insert query 
-- to get fresh new or updated data follow below steps 

-- Step 1 Truncate the entire table 
TRUNCATE TABLE Bronze.crm_cust_info;

-- Step 2 do Bulk insert step to get updated data
BULK INSERT Bronze.crm_cust_info
FROM 'D:\Rohit Satpute\SQL data Warehousing Project Practice\sql-data-warehouse-project\datasets\source_crm\cust_info.CSV'
WITH (
	FIRSTROW = 2,
	FIELDTERMINATOR = ',',
	TABLOCK
);

-- Step 3 RUN below query to view updated table

SELECT * FROM Bronze.crm_cust_info;

BULK INSERT Bronze.crm_prd_info
FROM 'D:\Rohit Satpute\SQL data Warehousing Project Practice\sql-data-warehouse-project\datasets\source_crm\prd_info.CSV'
WITH (
	FIRSTROW = 2,
	FIELDTERMINATOR = ',',
	TABLOCK
);

SELECT * FROM Bronze.crm_prd_info;

BULK INSERT Bronze.crm_sales_details
FROM 'D:\Rohit Satpute\SQL data Warehousing Project Practice\sql-data-warehouse-project\datasets\source_crm\sales_details.csv'
WITH (
	FIRSTROW = 2,
	FIELDTERMINATOR = ',',
	TABLOCK
);

SELECT * FROM Bronze.crm_sales_details;

BULK INSERT Bronze.erp_CUST_AZ12
FROM 'D:\Rohit Satpute\SQL data Warehousing Project Practice\sql-data-warehouse-project\datasets\source_erp\CUST_AZ12.CSV'
WITH (
	FIRSTROW = 2,
	FIELDTERMINATOR = ',',
	TABLOCK
);

SELECT * FROM Bronze.erp_CUST_AZ12;

TRUNCATE TABLE Bronze.erp_LOC_A101
BULK INSERT Bronze.erp_LOC_A101
FROM 'D:\Rohit Satpute\SQL data Warehousing Project Practice\sql-data-warehouse-project\datasets\source_erp\LOC_A101.CSV'
WITH (
	FIRSTROW = 2,
	FIELDTERMINATOR = ',',
	TABLOCK
);

SELECT * FROM Bronze.erp_LOC_A101;

BULK INSERT Bronze.erp_PX_CAT_G1V2
FROM 'D:\Rohit Satpute\SQL data Warehousing Project Practice\sql-data-warehouse-project\datasets\source_erp\PX_CAT_G1V2.CSV'
WITH (
	FIRSTROW = 2,
	FIELDTERMINATOR = ',',
	TABLOCK
);

SELECT * FROM Bronze.erp_PX_CAT_G1V2;