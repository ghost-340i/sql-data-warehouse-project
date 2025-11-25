SELECT DISTINCT * FROM Bronze.erp_LOC_A101
SELECT  * FROM Silver.crm_cust_info

-- After running both query at the same time if you notice in cid values are in '-' from Bronze.erp_LOC_A101 table and 
-- cst_key from Silver.crm_cust_info there are no '-' in key values
-- It will create problem while creating raltionship between tables 
-- So to tackle this follow bellow query remove '-' from cid column 

SELECT 
	REPLACE(cid,'-','') AS cid,
	cntry
FROM Bronze.erp_LOC_A101;

-- Data Standerdizaition & Consistency

SELECT DISTINCT cntry FROM Bronze.erp_LOC_A101
ORDER BY cntry;

-- After executing above query the data is not good there ar esome NULL,blanks and short forms of the country
-- So this is not good as a good quality of data. 
-- To fix this follow below query 

SELECT 
	REPLACE(cid,'-','') AS cid,
CASE 
	WHEN TRIM(cntry) = 'DE'
	THEN 'Germany'
	WHEN TRIM(cntry) = '' OR cntry IS NULL 
	THEN 'N/A'
	WHEN TRIM(cntry) IN ('US','USA')
	THEN 'United States'
	ELSE TRIM(cntry)
END as Country
FROM Bronze.erp_LOC_A101;

-- After Cleanning the data INSERT INTO Silver.erp_LOC_A101 Table 
-- To do this follow given query below

PRINT '>> Truncating table: Silver.erp_LOC_A101 <<';
TRUNCATE TABLE Silver.erp_LOC_A101;
PRINT '>> Inserting data into: Silver.erp_LOC_A101 <<';

INSERT INTO Silver.erp_LOC_A101 (
cid,
cntry
)

	SELECT 
		REPLACE(cid,'-','') AS cid,
	CASE 
		WHEN TRIM(cntry) = 'DE'
		THEN 'Germany'
		WHEN TRIM(cntry) = '' OR cntry IS NULL 
		THEN 'N/A'
		WHEN TRIM(cntry) IN ('US','USA')
		THEN 'United States'
		ELSE TRIM(cntry)
	END as Country
	FROM Bronze.erp_LOC_A101;

