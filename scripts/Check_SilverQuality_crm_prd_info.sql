-- NOTE : You can check quality of layer in same way as shown below. Just change schema and tables, columns names
-- Check for null or duplicates in Primary Key
-- Expection: No Result 

Select 
prd_id, COUNT(*)
from Silver.crm_prd_info
GROUP BY prd_id
HAVING COUNT(*) > 1 OR prd_id IS NULL ;	

---------------------------------------------------------------------------

SELECT
*,
ROW_NUMBER() OVER (PARTITION BY cst_id ORDER BY cst_create_date DESC) AS flag_last
FROM Silver.crm_prd_info
WHERE cat_id = 'AC-BC-BC-R205';

-- Check for Unwanted Spaces 
-- Expectation: No Results 
SELECT prd_nm 
FROM Silver.crm_prd_info
WHERE prd_nm != TRIM(prd_nm);

-- Check Data Standerdization & Consistency 
-- Expection : No Results
SELECT DISTINCT prd_line
FROM Silver.crm_prd_info;

-- Check for Invalid Date Orders
-- Expectation : No Results
SELECT * 
FROM Silver.crm_prd_info
WHERE prd_end_date < prd_start_date;

SELECT * FROM Silver.crm_sales_details;