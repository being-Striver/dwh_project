/*
============================================ table creation in silver layer==========================================

Metadata columns:
Extra columns added by data engineers that do not originate from the source data

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
cat_id NVARCHAR(50),
prd_nm NVARCHAR(50),
prd_cost INT,
prd_line NVARCHAR(50),
prd_start_dt DATE,
prd_end_dt DATE,
dwh_create_date DATETIME2 DEFAULT GETDATE()
);

IF OBJECT_ID ('silver.crm_sales_details', 'U') IS NOT NULL 
    DROP TABLE silver.crm_sales_details;

CREATE TABLE SILVER.CRM_SALES_DETAILS
(
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


-- crm_cust_info table load
insert into silver.crm_cust_info(cst_id,cst_key, cst_firstname, cst_lastname, cst_marital_status, cst_gndr, cst_create_date)
select DISTINCT cst_id, 
       cst_key, 
       trim(cst_firstname) as cst_firstname, 
       trim(cst_lastname) as cst_lastname,
       case when upper(trim(cst_marital_status)) = 'M' then 'Married'
            when upper(trim(cst_marital_status)) = 'S' then 'Single'
            ELSE 'N/A'
            End as cst_marital_status,
        case when upper(trim(cst_gndr)) = 'M' then 'Male'
            when upper(trim(cst_gndr)) = 'F' then 'female'
            ELSE 'N/A'
            End as cst_gndr,
        cst_create_date
 from (
select *,ROW_NUMBER() over( partition by cst_id order by cst_create_date desc) as flag_last
from bronze.CRM_CUST_INFO
where cst_id is not null
) t
where flag_last = 1;


-- crm_prd_info load
INSERT INTO SILVER.CRM_PRD_INFO(prd_id, prd_key, cat_id, prd_nm, prd_cost, prd_line, prd_start_dt, prd_end_dt)
select prd_id,
SUBSTRING(prd_key,7, LEN(prd_key)) as prd_key, 
REPLACE(SUBSTRING(prd_key, 1, 5), '-','_') as cat_id,
prd_nm,
isnull(prd_cost,0) as  prd_cost,
CASE WHEN UPPER(TRIM(prd_line)) = 'R' THEN 'ROAD'
     WHEN UPPER(TRIM(prd_line)) = 'S' THEN 'OTHER SALES'
     WHEN UPPER(TRIM(prd_line)) = 'M' THEN 'MOUNTAINS'
     WHEN UPPER(TRIM(prd_line)) = 'T' THEN 'TOURING'
     ELSE 'N/A'
     END AS prd_line
     , 
CAST(prd_start_dt AS DATE) prd_start_dt, 
CAST(LEAD(prd_start_dt) over(partition by prd_key order by prd_start_dt)-1  as DATE) prd_end_dt

from bronze.CRM_PRD_INFO
;

-- crm_sales_details
INSERT INTO silver.CRM_SALES_DETAILS(
sls_ord_num,
sls_prd_key,
sls_cust_id,
sls_order_dt,
sls_ship_dt,
sls_due_dt,
sls_sales ,
sls_quantity,
sls_price
)

select 
 sls_ord_num,
 sls_prd_key,
 sls_cust_id,
 case when len(sls_order_dt) != 8 or sls_order_dt > 20250830 or sls_order_dt < 19000101 then NULL
 else cast(cast(sls_order_dt as varchar) as date)
 end as sls_order_dt,
 case when len( sls_ship_dt) != 8 or  sls_ship_dt > 20250830 or  sls_ship_dt < 19000101 then NULL
 else cast(cast(sls_ship_dt as varchar) as date)
 end as sls_ship_dt
,
case when len( sls_due_dt) != 8 or  sls_due_dt > 20250830 or  sls_due_dt < 19000101 then NULL
 else  cast(cast(sls_due_dt as varchar) as date)
 end as  sls_due_dt,
 case when sls_sales is null or sls_sales <=0 or sls_sales != sls_quantity * ABS(sls_price) then 
       sls_quantity * ABS(sls_price)
else sls_sales
end as sls_sales,
 sls_quantity,
 case when sls_price is null or sls_price <= 0 then 
 sls_sales /nullif(sls_quantity,0)
else sls_price 
end as sls_price
 
from bronze.CRM_SALES_DETAILS;


-- LOAD INTO SILVER TABLE - SILVER.ERP_CUST_AZ12
INSERT INTO SILVER.ERP_CUST_AZ12(CID, BDATE, GEN)
select 
case when cid like 'NAS%' then SUBSTRING(CID, 4, LEN(CID))   -- remove NAS from cid
     ELSE CID END as CID,
CASE WHEN bdate > getdate() then NULL  -- set future bdate to null
     else bdate 
     end as bdate,
case when UPPER(TRIM(gen)) IN ('F', 'FEMALE') then 'Female'
     when UPPER(TRIM(gen)) IN ('M', 'MALE') then 'Male'
     else 'n/a'
     end as Gen                             -- set 'Male' or 'Female' as normalize values across gen column
            from bronze.ERP_CUST_AZ12;

-- load the silver table - SILVER.ERP_LOC_A101

INSERT INTO SILVER.ERP_LOC_A101(cid, cntry)
select  REPLACE(CID, '-', '') as cid  -- remove hyphen in cid
,case when UPPER(TRIM(CNTRY)) = 'DE' then 'Germany'
when UPPER(TRIM(CNTRY)) in ('USA', 'US', 'UNITED STATES') then 'United States'
       when UPPER(TRIM(CNTRY)) = '' or UPPER(TRIM(CNTRY)) is NULL then 'n/a'
       ELSE TRIM(CNTRY)
       end as CNTRY  -- normalize the data 
       FROM bronze.ERP_LOC_A101;

-- load the silver table-SILVER.ERP_PX_CAT_G1V2
INSERT INTO SILVER.ERP_PX_CAT_G1V2(ID, CAT, SUBCAT, MAINTENANCE)
select * from bronze.ERP_PX_CAT_G1V2;





