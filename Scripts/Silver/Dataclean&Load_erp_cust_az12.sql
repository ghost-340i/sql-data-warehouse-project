SELECT 
	cid,
	bdate,
	gen
FROM Bronze.erp_CUST_AZ12;

-- To create a relationship between crm_cust_info to erp_cust_az12 
-- We need to extract cst_key from cid column of 'erp_CUST_AZ12' table 
-- Run the above query and if you notice that cid vlaue start with 'NAS' which is not in crm_cust_info table 
-- So remove unnecessary things from data 

SELECT 
	cid,
CASE
	WHEN cid LIKE 'NAS%'
	THEN SUBSTRING(cid,4,LEN(cid))
	ELSE cid
END as cid_new,
	bdate,
	gen
FROM Bronze.erp_CUST_AZ12;

-- Identify Out-of-Range Dates

SELECT DISTINCT
bdate
FROM Bronze.erp_CUST_AZ12 
WHERE bdate < '1924-01-01' OR bdate > GETDATE();

-- After running this if you notice that date less than '1924-01-01' and greater than current date so its outlier 
-- To remove this unnecesary data follow the below query 

SELECT 
	cid,
CASE
	WHEN cid LIKE 'NAS%'
	THEN SUBSTRING(cid,4,LEN(cid))
	ELSE cid
END as cid,
CASE 
	WHEN bdate > GETDATE()
	THEN NULL
	ELSE bdate
END AS bdate,
	gen
FROM Bronze.erp_CUST_AZ12
ORDER BY bdate;

-- Data Standerdization & consistency 

SELECT DISTINCT
gen
FROM Bronze.erp_CUST_AZ12;

-- After running this above query you will notice that tyere are some NULL, short forms and blank in gen column 
-- to fix this follow bellow query 

SELECT  
CASE 
	WHEN UPPER(TRIM	(gen)) IN ('F','FEMALE') 
	THEN 'Female'
	WHEN UPPER(TRIM(gen)) IN ('M', 'MALE')
	THEN 'Male'
	ELSE 'N/A'
END AS gen
FROM Bronze.erp_CUST_AZ12;	

-- After all the data corrections INSERT INTO silver.erp_CUST_AZ12 Table
-- -- We are using TRUNCATE function in below to avoid any duplication in data 

PRINT '>> Truncating table: Silver.erp_CUST_AZ12 <<';
TRUNCATE TABLE Silver.erp_CUST_AZ12;
PRINT '>> Inserting data into: Silver.erp_CUST_AZ12 <<';

INSERT INTO Silver.erp_CUST_AZ12(
	cid,
	bdate,
	gen
)
SELECT 
	
CASE
	WHEN cid LIKE 'NAS%'
	THEN SUBSTRING(cid,4,LEN(cid))
	ELSE cid
END as cid,

CASE 
	WHEN bdate > GETDATE()
	THEN NULL
	ELSE bdate
END AS bdate,

CASE 
	WHEN UPPER(TRIM	(gen)) IN ('F','FEMALE') 
	THEN 'Female'
	WHEN UPPER(TRIM(gen)) IN ('M', 'MALE')
	THEN 'Male'
	ELSE 'N/A'
END AS gen
FROM Bronze.erp_CUST_AZ12
ORDER BY bdate;

-- After successfully transformed data inserted into Silver.erp_CUST_AZ12 Table, run Bellow query to ckeck everything is correct 

SELECT * FROM Silver.ersp_CUST_AZ12;