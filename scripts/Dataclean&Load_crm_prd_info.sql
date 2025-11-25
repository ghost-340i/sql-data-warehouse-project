-- Check for null or duplicates in Primary Key
-- Expection: No Result 

Select 
prd_id,  COUNT(*)
from Bronze.crm_prd_info
GROUP BY prd_id
HAVING COUNT(*) > 1 OR prd_id IS NULL ;	

---------------------------------------------------------------------------

-- Create cat_id column from prd_key column 
-- NOTE: first 5 characters are cat_id 

-- Modify and clean your prd_info table

SELECT prd_id,
       prd_key,
       REPLACE(SUBSTRING (prd_key,1,5),'-','_') AS cat_id, -- Extract category key
       SUBSTRING(prd_key,7,LEN(prd_key)) AS prd_key,       -- Extract Product key
       prd_nm,
       ISNULL(prd_cost,0) AS prd_cost,
CASE 
        WHEN UPPER(TRIM(prd_line)) = 'M' THEN 'Mountain'
        WHEN UPPER(TRIM(prd_line)) = 'R' THEN 'Road'
        WHEN UPPER(TRIM(prd_line)) = 'S' THEN 'Other Sales'
        WHEN UPPER(TRIM(prd_line)) = 'T' THEN 'Touring'
        ELSE 'N/A'
END AS prd_line,
       prd_start_date,
       prd_end_date
  FROM Bronze.crm_prd_info;

  --Remove unwanted space in prd-nm values
  -- Results : No Results
  SELECT prd_nm
  FROM Bronze.crm_prd_info
  WHERE prd_nm != TRIM(prd_nm);
  ------------------------------------------------------------
  -- Check for NULLs or Negative Numbers 
  -- Results : No Results
  SELECT prd_cost
  FROM Bronze.crm_prd_info
  WHERE prd_cost < 0 OR prd_cost IS NULL;
  --------------------------------------------------------------
  -- If you found any null Values in Cost column then replace with 0 
  SELECT prd_id,
       prd_key,
       REPLACE(SUBSTRING (prd_key,1,5),'-','_') AS cat_id,
       SUBSTRING(prd_key,7,LEN(prd_key)) AS prd_key,
       prd_nm,
       ISNULL(prd_cost,0) AS prd_cost,
CASE 
        WHEN UPPER(TRIM(prd_line)) = 'M' THEN 'Mountain'
        WHEN UPPER(TRIM(prd_line)) = 'R' THEN 'Road'
        WHEN UPPER(TRIM(prd_line)) = 'S' THEN 'Other Sales'
        WHEN UPPER(TRIM(prd_line)) = 'T' THEN 'Touring'
        ELSE 'N/A'
END AS prd_line,
       prd_start_date,
       prd_end_date
  FROM Bronze.crm_prd_info;
----------------------------------------------------------------------
 -- Check for invalid Date Orders
SELECT * 
FROM Bronze.crm_prd_info
WHERE prd_start_date > prd_end_date;
----------------------------------------------------------------------
-- In this scenario if you notice that the start date and end ate overlapping each other 
SELECT * 
FROM Bronze.crm_prd_info
WHERE prd_key IN ('AC-HE-HL-U509-R', 'AC-HE-HL-U509');
-------------------------------------------------------------------------
-- To Fix this use Windows Function called 'LEAD' 
SELECT 
prd_id,
prd_key,
prd_nm,
prd_cost,
prd_line,
prd_nm,
prd_start_date,
LEAD (prd_start_date) OVER (PARTITION BY prd_key ORDER BY prd_start_date) -1 AS prd_start_date_test,
--used -1 in code because its overlapping by Month and date 
prd_end_date
FROM Bronze.crm_prd_info
WHERE prd_key IN('AC-HE-HL-U509-R', 'AC-HE-HL-U509'); 
-----------------------------------------------------------------------------------
-- If you notice that time is 00:00:00 present in for all dates and it make no sense. so we will change the data type to tackle this issue 
 SELECT prd_id,
       prd_key,
       REPLACE(SUBSTRING (prd_key,1,5),'-','_') AS cat_id,
       SUBSTRING(prd_key,7,LEN(prd_key)) AS prd_key,
       prd_nm,
       ISNULL(prd_cost,0) AS prd_cost,
CASE 
        WHEN UPPER(TRIM(prd_line)) = 'M' THEN 'Mountain'
        WHEN UPPER(TRIM(prd_line)) = 'R' THEN 'Road'
        WHEN UPPER(TRIM(prd_line)) = 'S' THEN 'Other Sales'
        WHEN UPPER(TRIM(prd_line)) = 'T' THEN 'Touring'
        ELSE 'N/A'
END AS prd_line,
CAST(prd_start_date AS DATE) AS prd_start_date,
CAST(LEAD (prd_start_date) OVER (PARTITION BY prd_key ORDER BY prd_start_date) -1 AS DATE) AS prd_end_date_test
FROM Bronze.crm_prd_info;

-- After Cleaning the data Insert this clean data INSERT INTO Silver Layer
-- We are using TRUNCATE function in below to avoid any duplication in data 

PRINT '>> Truncating table: Silver.crm_prd_info <<';
TRUNCATE TABLE Silver.crm_prd_info;
PRINT '>> Inserting data into: Silver.crm_prd_info <<';

INSERT INTO Silver.crm_prd_info(
prd_id,
cat_id,
prd_key,
prd_nm,
prd_cost,
prd_line,
prd_start_date,
prd_end_date
)
 SELECT prd_id,
       REPLACE(SUBSTRING (prd_key,1,5),'-','_') AS cat_id, -- Extract category key
       SUBSTRING(prd_key,7,LEN(prd_key)) AS prd_key,       -- Extract Product key
       prd_nm,
       ISNULL(prd_cost,0) AS prd_cost,
CASE 
        WHEN UPPER(TRIM(prd_line)) = 'M' THEN 'Mountain'
        WHEN UPPER(TRIM(prd_line)) = 'R' THEN 'Road'
        WHEN UPPER(TRIM(prd_line)) = 'S' THEN 'Other Sales'
        WHEN UPPER(TRIM(prd_line)) = 'T' THEN 'Touring'
        ELSE 'N/A'
END AS prd_line,
CAST(prd_start_date AS DATE) AS prd_start_date,
CAST(LEAD (prd_start_date) OVER (PARTITION BY prd_key ORDER BY prd_start_date) -1 AS DATE) AS prd_end_date_test
FROM Bronze.crm_prd_info;

select * from Bronze.crm_prd_info;
select * from Silver.crm_prd_info;

Select * from Silver.crm_prd_info;