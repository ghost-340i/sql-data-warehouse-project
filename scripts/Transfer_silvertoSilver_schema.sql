/*
Script Name  : cleanup_transfer_silver_schema.sql
Purpose       : Transfer tables from old lowercase 'silver' schema 
                to new capitalized 'Silver' schema, verify transfer,
                and drop old schema objects safely.

Author        : [Your Name]
Date          : [Date]

Notes:
- Run this only after confirming data backup.
- Verify that all transferred tables exist in 'Silver' before dropping 'silver'.
*/

-- Step 1: Transfer required tables from old 'silver' schema to new 'Silver' schema
ALTER SCHEMA Silver TRANSFER silver.crm_cust_info;

-- Step 2: Verify table transfer
SELECT TABLE_SCHEMA, TABLE_NAME
FROM INFORMATION_SCHEMA.TABLES
WHERE TABLE_NAME = 'crm_cust_info';

-- Step 3: Confirm data exists in new schema
SELECT TOP 10 * FROM Silver.crm_cust_info;

-- Step 4: Drop remaining old tables from 'silver' schema (if confirmed not needed)
DROP TABLE IF EXISTS silver.crm_prd_info;
DROP TABLE IF EXISTS silver.crm_sales_details;
DROP TABLE IF EXISTS silver.erp_px_cat_g1v2;
DROP TABLE IF EXISTS silver.erp_cust_az12;
DROP TABLE IF EXISTS silver.erp_loc_a101;

-- Step 5: Drop the old 'silver' schema after cleanup
DROP SCHEMA IF EXISTS silver;

-- Done: All relevant data now resides in the 'Silver' schema
