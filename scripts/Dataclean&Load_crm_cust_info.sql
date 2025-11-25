
-- Cleaning unwanted spaces 

SELECT 
(cst_id) AS cst_id,
(cst_key) AS cst_key,
TRIM (cst_firstname) AS cst_firstname,
TRIM (cst_lastname) AS cst_lastname,
(cst_marital_status) AS cst_marital_status,
(cst_gndr) AS cst_gndr,
(cst_create_date) AS cst_create_date
FROM (
	SELECT 
	*,
	ROW_NUMBER() OVER (PARTITION BY cst_id ORDER BY cst_create_date DESC) AS flag_rank
FROM Bronze.crm_cust_info
WHERE cst_id IS NOT NULL
) AS t WHERE flag_rank = 1;

-- Data Standardization & Consistency

SELECT 
(cst_id) AS cst_id,
(cst_key) AS cst_key,
TRIM (cst_firstname) AS cst_firstname,
TRIM (cst_lastname) AS cst_lastname,
CASE WHEN UPPER (TRIM(cst_marital_status)) = 'M' THEN 'Married'
	 WHEN UPPER (TRIM(cst_marital_status)) = 'S' THEN 'Single'
	 WHEN UPPER (TRIM(cst_gndr)) = 'M' THEN 'Male'
	 WHEN UPPER (TRIM(cst_gndr)) = 'F' THEN 'Female'
	 ELSE 'N/A'
END
cst_create_date
FROM (
	SELECT 
	*,
	ROW_NUMBER() OVER (PARTITION BY cst_id ORDER BY cst_create_date DESC) AS flag_rank
FROM Bronze.crm_cust_info
WHERE cst_id IS NOT NULL
) AS t WHERE flag_rank = 1;

-- After completing Data Standardization & Consistency step we have to INSERT data into Silver layer of crm_cust_info table
-- We are using TRUNCATE function in below to avoid any duplication in data 
PRINT '>> Truncating table: Silver.crm_cust_info <<';
TRUNCATE TABLE Silver.crm_cust_info;
PRINT '>> Inserting data into: Silver.crm_cust_info <<';

INSERT INTO Silver.crm_cust_info
	(cst_id,
	 cst_key,
	 cst_firstname,
     cst_lastname,
	 cst_marital_status,
	 cst_gndr,
	 cst_create_date
	 )
	
		SELECT 
		cst_id,
		cst_key,
		TRIM (cst_firstname) AS cst_firstname,
		TRIM (cst_lastname) AS cst_lastname,
		CASE 
			WHEN UPPER (TRIM(cst_marital_status)) = 'M' THEN 'Married'
			WHEN UPPER (TRIM(cst_marital_status)) = 'S' THEN 'Single'
			ELSE 'N/A'	
		END
		cst_marital_status,
		CASE
			 WHEN UPPER (TRIM(cst_gndr)) = 'M' THEN 'Male'
			 WHEN UPPER (TRIM(cst_gndr)) = 'F' THEN 'Female'
			 ELSE 'N/A'
		END
		cst_gndr,
		cst_create_date
		FROM (
			SELECT 
			*,
			ROW_NUMBER() OVER (PARTITION BY cst_id ORDER BY cst_create_date DESC) AS flag_rank
		FROM Bronze.crm_cust_info
		WHERE cst_id IS NOT NULL
		) AS cust_ranked WHERE flag_rank = 1


SELECT * FROM Silver.crm_cust_info;
