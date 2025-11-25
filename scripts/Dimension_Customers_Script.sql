SELECT 
Ci.cst_id,
Ci.cst_key,
Ci.cst_firstname,
Ci.cst_lastname,
Ci.cst_marital_status,
Ci.cst_gndr,
Ca.gen,
Ca.bdate AS Birth_Date,
Ci.cst_create_date,
la.cntry AS Country
FROM Silver.crm_cust_info AS Ci

LEFT JOIN Silver.erp_CUST_AZ12 AS Ca
ON Ci.cst_key = Ca.cid
LEFT JOIN Silver.erp_LOC_A101 AS la
ON Ci.cst_key = la.cid;

-- After Joining Table, check if any duplicates were introduced by the join logic

SELECT cst_id, COUNT(*) FROM
(
SELECT 
Ci.cst_id,
Ci.cst_key,
Ci.cst_firstname,
Ci.cst_lastname,
Ci.cst_marital_status,
Ci.cst_gndr,
Ca.gen,
Ca.bdate AS Birth_Date,
Ci.cst_create_date,
la.cntry AS Country
FROM Silver.crm_cust_info AS Ci

LEFT JOIN Silver.erp_CUST_AZ12 AS Ca
ON Ci.cst_key = Ca.cid
LEFT JOIN Silver.erp_LOC_A101 AS la
ON Ci.cst_key = la.cid
) AS test
GROUP BY cst_id
HAVING COUNT(*) > 1

/*
  After Executing Query you will notice that there are 2 gender columns in table,
  So Check which column have a correct info with the help of data source expert person and 
-- ask which table is Master table so that we can use gender from that table 
-- and even if we don't know the exact Gender then we have to do data integration method 
-- In this case CRM is a Master data for gender info, 
   so as per the expert if the CRM does not have gender info then take from ERP or vice versa
-- But make sure to get confirmation from Data Source export
*/

SELECT DISTINCT
Ci.cst_gndr,
Ca.gen,
CASE WHEN Ci.cst_gndr != 'N/A' -- CRM is Master from gender info
	 THEN Ci.cst_gndr
	 ELSE COALESCE(Ca.gen,'N/A')
END AS New_gen
FROM Silver.crm_cust_info AS Ci

LEFT JOIN Silver.erp_CUST_AZ12 AS Ca
ON Ci.cst_key = Ca.cid
LEFT JOIN Silver.erp_LOC_A101 AS la
ON Ci.cst_key = la.cid


/* After creating logic for gender add this logic into main query and chenge 
column names as per the general principle of naming conventions Rules
General Principles
• Naming Conventions: Use snake_case, with lowercase letters and underscores ( _ ) to separate words.
• Language: Use English for all names.
• Avoid Reserved Words: Do not use SQL reserved words as object names.
to read column names easily in Golder Layer
Sometimes we have to create new key as a primary key so for that we called as a surrogate key.
Surrogate key is System - Generated Unique Identifier, Assigned to each record in table 
It is a query based Windows Function (Row_Number)
*/
SELECT 
ROW_NUMBER() OVER (ORDER BY cst_id) AS customer_key,
Ci.cst_id AS customer_id,
Ci.cst_key AS customer_number,
Ci.cst_firstname AS first_name,
Ci.cst_lastname AS last_name,
la.cntry AS country,
Ci.cst_marital_status AS marital_status,
CASE WHEN Ci.cst_gndr != 'N/A' -- CRM is Master from gender info
	 THEN Ci.cst_gndr
	 ELSE COALESCE(Ca.gen,'N/A')
END AS New_gender,
Ca.bdate AS Birth_Date,
Ci.cst_create_date
FROM Silver.crm_cust_info AS Ci

LEFT JOIN Silver.erp_CUST_AZ12 AS Ca
ON Ci.cst_key = Ca.cid
LEFT JOIN Silver.erp_LOC_A101 AS la
ON Ci.cst_key = la.cid;	

/* after done all the changes in Query Create view for Dimention tables */

Go
CREATE VIEW Gold.dim_Customers AS
SELECT 
	ROW_NUMBER() OVER (ORDER BY cst_id) AS customer_key,
	Ci.cst_id AS customer_id,
	Ci.cst_key AS customer_number,
	Ci.cst_firstname AS first_name,
	Ci.cst_lastname AS last_name,
	la.cntry AS country,
	Ci.cst_marital_status AS marital_status,
	CASE WHEN Ci.cst_gndr != 'N/A' THEN Ci.cst_gndr -- CRM is Master from gender info
		 ELSE COALESCE(Ca.gen,'N/A')
	END AS New_gender,
Ca.bdate AS Birth_Date,
Ci.cst_create_date
FROM Silver.crm_cust_info AS Ci

LEFT JOIN Silver.erp_CUST_AZ12 AS Ca
ON Ci.cst_key = Ca.cid
LEFT JOIN Silver.erp_LOC_A101 AS la
ON Ci.cst_key = la.cid;	