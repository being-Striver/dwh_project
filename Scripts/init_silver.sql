/*
============================================ table creation in silver layer==========================================

Metadata columns:
Extra columns added  by data engineers that do not originate from the source data

create_date: The record's load timestamp
update_date: the record's last update timestamp
source_system: the origin system of the record
file_location: the file source of the record


*/

use dwh;

IF OBJECT_ID ('silver.crm_cust_info', 'U') IS NOT NULL 
    DROP TABLE silver.crm_cust_info;

CREATE TABLE SILVER.CRM_CUST_INFO
(
cst_id INT,
cst_key NVARCHAR(50),
cst_firstname NVARCHAR(50),
cst_lastname NVARCHAR(50),
cst_marital_status NVARCHAR(50),
cst_gndr NVARCHAR(50),
cst_create_date DATE,
dwh_create_date DATETIME2 DEFAULT GETDATE()
);


IF OBJECT_ID ('silver.crm_prd_info', 'U') IS NOT NULL 
    DROP TABLE silver.crm_prd_info;

CREATE TABLE SILVER.CRM_PRD_INFO(
prd_id INT,
prd_key NVARCHAR(50),
prd_nm NVARCHAR(50),
prd_cost INT,
prd_line NVARCHAR(50),
prd_start_dt DATETIME,
prd_end_dt DATETIME,
dwh_create_date DATETIME2 DEFAULT GETDATE()
);

IF OBJECT_ID ('silver.crm_sales_details', 'U') IS NOT NULL 
    DROP TABLE silver.crm_sales_details;

CREATE TABLE SILVER.CRM_SALES_DETAILS
(
sls_ord_num NVARCHAR(50),
sls_prd_key NVARCHAR(50),
sls_cust_id INT,
sls_order_dt INT,
sls_ship_dt INT,
sls_due_dt INT,
sls_sales INT,
sls_quantity INT,
sls_price INT,
dwh_create_date DATETIME2 DEFAULT GETDATE()
);

IF OBJECT_ID ('silver.erp_cust_az12', 'U') IS NOT NULL 
   DROP TABLE silver.ERP_CUST_AZ12;
CREATE TABLE SILVER.ERP_CUST_AZ12 (
CID NVARCHAR(50),
BDATE DATE,
GEN NVARCHAR(50),
dwh_create_date DATETIME2 DEFAULT GETDATE()
);


IF OBJECT_ID ('silver.erp_loc_a101', 'U') IS NOT NULL 
   DROP TABLE silver.ERP_LOC_A101;
CREATE TABLE SILVER.ERP_LOC_A101(
CID NVARCHAR(50),
CNTRY NVARCHAR(50),
dwh_create_date DATETIME2 DEFAULT GETDATE()
);


IF OBJECT_ID ('silver.erp_px_cat_g1v2', 'U') IS NOT NULL 
   DROP TABLE silver.ERP_px_cat_g1v2;
CREATE TABLE SILVER.ERP_PX_CAT_G1V2
(
ID NVARCHAR(50),
CAT NVARCHAR(50),
SUBCAT NVARCHAR(50),
MAINTENANCE NVARCHAR(50),
dwh_create_date DATETIME2 DEFAULT GETDATE()
);