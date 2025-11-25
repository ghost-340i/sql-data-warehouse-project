-- create new table cust_info from source_crm folder in Silver layer

IF OBJECT_ID('Silver.crm_cust_info','U') IS NOT NULL 
DROP TABLE Silver.crm_cust_info;
CREATE TABLE Silver.crm_cust_info(
	
	cst_id	INT,
	cst_key NVARCHAR(50),
	cst_firstname NVARCHAR(50),
	cst_lastname NVARCHAR(50),
	cst_marital_status NVARCHAR(50),
	cst_gndr NVARCHAR(50),
	cst_create_date DATE,
	dwh_create_date DATETIME2 DEFAULT GETDATE()
); 

--create new table prd_info from source_crm folder in Silver layer

IF OBJECT_ID('Silver.crm_prd_info','U') IS NOT NULL 
DROP TABLE Silver.crm_prd_info;
CREATE TABLE Silver.crm_prd_info(
	prd_id INT,
	cat_id nvarchar(50),
	prd_key NVARCHAR(50),
	prd_nm NVARCHAR(50),
	prd_cost INT,
	prd_line varchar(50),
	prd_start_date DATE,
	prd_end_date DATE,
	dwh_create_date DATETIME2 DEFAULT GETDATE()
);

--create new table sales_details from source_crm folder in Silver layer

IF OBJECT_ID('Silver.crm_sales_details','U') IS NOT NULL 
DROP TABLE Silver.crm_sales_details;
CREATE TABLE Silver.crm_sales_details(
sls_ord_num NVARCHAR(50),
sls_prd_key NVARCHAR(50),
sls_cust_id INT,
sls_order_dt DATE,
sls_ship_dt DATE,
sls_due_dt DATE,
sls_sales INT,
sls_quantity INT,
sls_price INT,
dwh_create_date DATETIME2 DEFAULT GETDATE()
);

--create new table CUST_AZ12 from source_erp folder in Silver layer

IF OBJECT_ID('Silver.erp_CUST_AZ12','U') IS NOT NULL 
DROP TABLE Silver.erp_CUST_AZ12;
CREATE TABLE Silver.erp_CUST_AZ12(
cid NVARCHAR(50),
bdate DATE,
gen	 NVARCHAR(50),
dwh_create_date DATETIME2 DEFAULT GETDATE()
);

--create new table CUST_AZ12 from source_erp folder in Silver layer

IF OBJECT_ID('Silver.erp_LOC_A101','U') IS NOT NULL 
DROP TABLE Silver.erp_LOC_A101;
CREATE TABLE Silver.erp_LOC_A101(
cid NVARCHAR(50),
cntry NVARCHAR(50),
dwh_create_date DATETIME2 DEFAULT GETDATE()
);

--create new table CUST_AZ12 from source_erp folder in Silver layer

IF OBJECT_ID('Silver.erp_PX_CAT_G1V2','U') IS NOT NULL 
DROP TABLE Silver.erp_PX_CAT_G1V2;
CREATE TABLE Silver.erp_PX_CAT_G1V2 (
id VARCHAR (50),
cat VARCHAR (50),
subcat VARCHAR(50),
maintenance VARCHAR(50),	
dwh_create_date DATETIME2 DEFAULT GETDATE()
);

SELECT * FROM Silver.crm_cust_info;