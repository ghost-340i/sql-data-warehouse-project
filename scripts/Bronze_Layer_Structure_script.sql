-- create new table cust_info from source_crm folder in bronze layer

IF OBJECT_ID('Bronze.crm_cust_info','U') IS NOT NULL 
DROP TABLE Bronze.crm_cust_info;
CREATE TABLE Bronze.crm_cust_info(
	
	cst_id	INT,
	cst_key NVARCHAR(50),
	cst_firstname NVARCHAR(50),
	cst_lastname NVARCHAR(50),
	cst_marital_status NVARCHAR(50),
	cst_gndr NVARCHAR(50),
	cst_create_date DATE
); 

--create new table prd_info from source_crm folder in bronze layer

IF OBJECT_ID('Bronze.crm_prd_info','U') IS NOT NULL 
DROP TABLE Bronze.crm_prd_info;
CREATE TABLE Bronze.crm_prd_info(
	prd_id INT,
	prd_key VARCHAR(50),
	prd_nm VARCHAR(50),
	prd_cost INT,
	prd_line varchar(50),
	prd_start_date DATETIME,
	prd_end_date DATETIME
);

--create new table sales_details from source_crm folder in bronze layer

IF OBJECT_ID('Bronze.crm_sales_details','U') IS NOT NULL 
DROP TABLE Bronze.crm_sales_details;
CREATE TABLE Bronze.crm_sales_details(
sls_ord_num NVARCHAR(50),
sls_prd_key NVARCHAR(50),
sls_cust_id INT,
sls_order_dt INT,
sls_ship_dt INT,
sls_due_dt INT,
sls_sales INT,
sls_quantity INT,
sls_price INT
);

--create new table CUST_AZ12 from source_erp folder in bronze layer

IF OBJECT_ID('Bronze.erp_CUST_AZ12','U') IS NOT NULL 
DROP TABLE Bronze.erp_CUST_AZ12;
CREATE TABLE Bronze.erp_CUST_AZ12(
cid NVARCHAR(50),
bdate DATE,
gen	 NVARCHAR(50)
);

--create new table CUST_AZ12 from source_erp folder in bronze layer

IF OBJECT_ID('Bronze.erp_LOC_A101','U') IS NOT NULL 
DROP TABLE Bronze.erp_LOC_A101;
CREATE TABLE Bronze.erp_LOC_A101(
cid NVARCHAR(50),
cntry NVARCHAR(50)

);

--create new table CUST_AZ12 from source_erp folder in bronze layer

IF OBJECT_ID('Bronze.erp_PX_CAT_G1V2','U') IS NOT NULL 
DROP TABLE Bronze.erp_PX_CAT_G1V2;
CREATE TABLE Bronze.erp_PX_CAT_G1V2 (
id VARCHAR (50),
cat VARCHAR (50),
subcat VARCHAR(50),
maintenance VARCHAR(50)	
);