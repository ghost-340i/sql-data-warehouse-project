-- We have checked the data and no need to clean so we will INSERT INTO as it is in Silver.erp_PX_CAT_G1V2 Table
-- We are using TRUNCATE function in below to avoid any duplication in data 

PRINT '>> Truncating table: Silver.erp_PX_CAT_G1V2 <<';
TRUNCATE TABLE Silver.erp_PX_CAT_G1V2;
PRINT '>> Inserting data into: Silver.erp_PX_CAT_G1V2 <<';
INSERT INTO Silver.erp_PX_CAT_G1V2(
	id,
	cat,
	subcat,
	maintenance
	)
	SELECT 
		id,
		cat,
		subcat,
		maintenance
	FROM Bronze.erp_PX_CAT_G1V2

	SELECT * FROM Silver.erp_PX_CAT_G1V2;