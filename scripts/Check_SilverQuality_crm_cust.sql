-- NOTE : You can check quality of layer in same way as shown below. Just change schema and tables, columns names
-- Check for null or duplicates in Primary Key
-- Expection: No Result 

Select 
cst_id, COUNT(*)
from Silver.crm_cust_info
GROUP BY cst_id
HAVING COUNT(*) > 1 OR cst_id IS NULL ;	

---------------------------------------------------------------------------

SELECT
*,
ROW_NUMBER() OVER (PARTITION BY cst_id ORDER BY cst_create_date DESC) AS flag_last
FROM Silver.crm_cust_info
WHERE cst_id = 29466;

-- Check for Unwanted Spaces 
-- Expectation: No Results 

SELECT cst_firstname
FROM Silver.crm_cust_info
WHERE cst_firstname ! = TRIM(cst_firstname);

SELECT cst_lastname
FROM Silver.crm_cust_info
WHERE cst_lastname ! = TRIM(cst_lastname);

SELECT cst_gndr
FROM Silver.crm_cust_info
WHERE cst_gndr ! = TRIM(cst_gndr);

SELECT * FROM Silver.crm_cust_info;