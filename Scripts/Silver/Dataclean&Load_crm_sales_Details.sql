SELECT * FROM Bronze.crm_sales_details;

-- if you notice that in sls_order_dt, sls_ship_dt and sls_due_dt (CHECK FOR INVALID DATES) are not in date format so we need to fix this
-- but before check any 0 or any outlier values are present or not 
-- for that follow below steps 

SELECT 
	sls_order_dt
FROM Bronze.crm_sales_details
WHERE sls_order_dt < 0;

SELECT 
	sls_order_dt
FROM Bronze.crm_sales_details
WHERE sls_order_dt <= 0;

-- If you notice that in date 0 value showing whcih is not correct so we will replace with NULL 
-- So, to tackle this issue use NULLIF() Function it is used when you want to replace somthing with NULL 

SELECT 
NULLIF(sls_order_dt,0) AS sls_order_dt
FROM Bronze.crm_sales_details
WHERE sls_order_dt <= 0 
OR LEN(sls_order_dt) != 8
OR sls_order_dt > 20250101
OR sls_order_dt < 19000101;

-- Check for Invalid Dates and fix it 

SELECT 
sls_ord_num,
sls_prd_key,
sls_cust_id,
CASE
	WHEN sls_order_dt <= 0 OR LEN(sls_order_dt) != 8
	THEN NULL
	ELSE CAST( CAST (sls_order_dt AS VARCHAR) AS date)
END AS sls_order_date,
CASE	
	WHEN sls_ship_dt <= 0 OR LEN(sls_ship_dt) != 8
	THEN NULL
	ELSE CAST( CAST (sls_ship_dt AS VARCHAR) AS date)
END AS sls_ship_date,
CASE
	WHEN sls_due_dt <= 0 OR LEN(sls_due_dt) != 8
	THEN NULL
	ELSE CAST( CAST (sls_due_dt AS VARCHAR) AS date)
END AS sls_due_date,
sls_sales,
sls_quantity,
sls_price
FROM Bronze.crm_sales_details;

-- When you run this above query (which is correct) but in any project if you face that shipping date is earlier than order date or due date or vice versa then, 
-- NOTE : Order date must always be earlier than the shipping date or Due date 
-- To do this follow below query 
-- Expectation: No Results 

SELECT *
FROM Bronze.crm_sales_details 
WHERE sls_order_dt > sls_ship_dt OR sls_order_dt > sls_due_dt; 

-- After running this query there no any issue so we can move forward to check othe columns as well
----------------------------------------------------------------------------------------------------------
-- If you notice in 'Bronze.crm_sales_details' table sls_sales column and sls_price are showing same values 
-- In business rule Sales = Quantity * Price and negative, zeros, nulls are NOT ALLOWED!
-- So Check Data Consistency: Between Sales, Quantity, and Price
-- Sales = Quantity * Price
-- Values must not be NULL, zero, or negative and to check this follow below Query

SELECT DISTINCT 
sls_sales,
sls_quantity,
sls_price
FROM Bronze.crm_sales_details
WHERE sls_sales != sls_quantity * sls_price
OR sls_sales IS NULL OR sls_quantity IS NULL OR sls_price IS NULL 
OR sls_sales <= 0 OR sls_quantity <= 0 OR sls_price <= 0
ORDER BY sls_sales, sls_quantity,sls_price; 

-- After running above query if you notice that in results show null, negative and zero values 
-- to fix this 
-- # solution 1 : talk with expert who handle the data source and try to resolve the issue directly in data source
-- # Solution 2 : if they don't want to invest to fix this issue then take a support from expert of the data source 
-- and try to resolve this issue in Data Warehouse

SELECT DISTINCT 
sls_sales AS sls_old_sales,
sls_quantity,
sls_price AS sls_old_price,
CASE 
	WHEN sls_sales IS NULL OR sls_sales <= 0  OR sls_sales != sls_quantity* ABS(sls_price)
	THEN sls_quantity * ABS(sls_price)
	ELSE sls_sales
END AS sls_sales_new,
CASE 
	WHEN sls_price IS NULL OR sls_price <= 0
	THEN sls_sales / NULLIF(sls_quantity,0) 
	ELSE sls_price
END AS sls_price_new
FROM Bronze.crm_sales_details	
WHERE sls_sales != sls_quantity * sls_price OR 
sls_sales IS NULL OR sls_quantity IS NULL OR sls_price IS NULL
OR sls_sales <= 0 OR sls_quantity <= 0 OR sls_price <= 0
ORDER BY sls_sales, sls_quantity, sls_price;

-- Now we have resolved successfully above comment problem now add this solution into your main Query 
-- We are using TRUNCATE function in below to avoid any duplication in data 

PRINT '>> Truncating table: Silver.crm_sales_details <<';
TRUNCATE TABLE Silver.crm_sales_details;
PRINT '>> Inserting data into: Silver.crm_sales_details <<';

INSERT INTO Silver.crm_sales_details (
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

	SELECT 
	sls_ord_num,
	sls_prd_key,
	sls_cust_id,
	CASE
		WHEN sls_order_dt <= 0 OR LEN(sls_order_dt) != 8
		THEN NULL
		ELSE CAST( CAST (sls_order_dt AS VARCHAR) AS date)
	END AS sls_order_date,
	CASE	
		WHEN sls_ship_dt <= 0 OR LEN(sls_ship_dt) != 8
		THEN NULL
		ELSE CAST( CAST (sls_ship_dt AS VARCHAR) AS date)
	END AS sls_ship_date,
	CASE
		WHEN sls_due_dt <= 0 OR LEN(sls_due_dt) != 8
		THEN NULL
		ELSE CAST( CAST (sls_due_dt AS VARCHAR) AS date)
	END AS sls_due_date,
	CASE 
		WHEN sls_sales IS NULL OR sls_sales <= 0  OR sls_sales != sls_quantity* ABS(sls_price)
		THEN sls_quantity * ABS(sls_price)
		ELSE sls_sales
	END AS sls_sales,
	sls_quantity,
	CASE 
		WHEN sls_price IS NULL OR sls_price <= 0
		THEN sls_sales / NULLIF(sls_quantity,0) 
		ELSE sls_price
	END AS sls_price
	FROM Bronze.crm_sales_details
	WHERE sls_quantity >= 2;
	
-- All your Transformation has successfully inserted into Silver.crm_sales_details table.
-- To see your Transformations, run below Query 

SELECT * FROM Silver.crm_sales_details;