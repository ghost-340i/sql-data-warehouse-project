SELECT 
	pn.prd_id AS product_id,
	pn.prd_key AS product_number,
	pn.prd_nm AS product_name,
	pn.cat_id AS category_id,
	pc.cat AS category,
	pc.subcat AS subcategory,
	pc.maintenance,
	pn.prd_cost AS cost,
	pn.prd_line AS product_line,
	pn.prd_start_date AS start_date	
FROM Silver.crm_prd_info AS pn
LEFT JOIN Silver.erp_PX_CAT_G1V2 AS pc
ON pn.cat_id = pc.id
WHERE prd_end_date IS NULL --Filter out all Historical data 
---------------------------------------------------------------------------
/*  After creating table run the query and see the results to get understanding about
data to take decision weather its is dimension table or fact table 
-- In results shows its a dimesion table because when the data is describe something 
in table then its a Dimension table.
-- We are using Surrogate Key to maintain data and its history. 
-- In some cases, if the business ID gets updated and it is related to other tables, 
-- it becomes hard to maintain. So, we use a Surrogate Key.
-- Why we used Surrogate Key here?
-- 1) Business/Source Key (like Customer ID) can change or come in different formats.
-- 2) If business key changes, maintaining relationships with other tables becomes difficult.
-- 3) Surrogate Key is stable (never changes) and is only used inside the Data Warehouse.
-- 4) It also helps to maintain history (SCD Type-2) by creating new versions of the record.
-- 5) Joins are faster because surrogate key is numeric (INT / BIGINT).
-- So, we use surrogate key in Data Warehouse for better performance, stability, and history tracking.
-- After every transformation is done then create View on it 
*/

CREATE VIEW Gold.Dim_products AS 
SELECT 
	ROW_NUMBER () OVER (ORDER BY pn.prd_start_date ,pn.prd_key) AS product_key,
	pn.prd_id AS product_id,
	pn.prd_key AS product_number,
	pn.prd_nm AS product_name,
	pn.cat_id AS category_id,
	pc.cat AS category,
	pc.subcat AS subcategory,
	pc.maintenance,
	pn.prd_cost AS cost,
	pn.prd_line AS product_line,
	pn.prd_start_date AS start_date	
FROM Silver.crm_prd_info AS pn
LEFT JOIN Silver.erp_PX_CAT_G1V2 AS pc
ON pn.cat_id = pc.id
WHERE prd_end_date IS NULL;
Go

SELECT * FROM Gold.Dim_products;
