/*
====================================== Bulk INSERT from csv================================================

Before doing full load, make sure you truncate the table. 

*/

TRUNCATE TABLE BRONZE.CRM_CUST_INFO;

BULK INSERT BRONZE.CRM_CUST_INFO 
FROM 
"C:\Users\shudh\OneDrive\Desktop\dwh_project\datasets\source_crm\cust_info.csv"

WITH 
(
  FIRSTROW = 2, 
  FIELDTERMINATOR = ',',
  TABLOCK
);


TRUNCATE TABLE BRONZE.CRM_PRD_INFO;

BULK INSERT BRONZE.CRM_PRD_INFO 
FROM 
"C:\Users\shudh\OneDrive\Desktop\dwh_project\datasets\source_crm\prd_info.csv"

WITH 
(
  FIRSTROW = 2, 
  FIELDTERMINATOR = ',',
  TABLOCK
);


TRUNCATE TABLE BRONZE.CRM_SALES_DETAILS;

BULK INSERT BRONZE.CRM_SALES_DETAILS 
FROM 
"C:\Users\shudh\OneDrive\Desktop\dwh_project\datasets\source_crm\sales_details.csv"

WITH 
(
  FIRSTROW = 2, 
  FIELDTERMINATOR = ',',
  TABLOCK
);

TRUNCATE TABLE BRONZE.ERP_CUST_AZ12;
BULK INSERT BRONZE.ERP_CUST_AZ12
FROM 
'C:\Users\shudh\OneDrive\Desktop\dwh_project\datasets\source_erp\CUST_AZ12.csv'

WITH 
(
FIRSTROW = 2,
FIELDTERMINATOR = ',',
TABLOCK
);

TRUNCATE TABLE BRONZE.ERP_LOC_A101;
BULK INSERT BRONZE.ERP_LOC_A101
FROM 
'C:\Users\shudh\OneDrive\Desktop\dwh_project\datasets\source_erp\LOC_A101.csv'

WITH 
(
FIRSTROW = 2,
FIELDTERMINATOR = ',',
TABLOCK
);

TRUNCATE TABLE BRONZE.ERP_PX_CAT_G1V2;
BULK INSERT BRONZE.ERP_PX_CAT_G1V2
FROM 
'C:\Users\shudh\OneDrive\Desktop\dwh_project\datasets\source_erp\PX_CAT_G1V2.csv'

WITH 
(
FIRSTROW = 2,
FIELDTERMINATOR = ',',
TABLOCK
);




