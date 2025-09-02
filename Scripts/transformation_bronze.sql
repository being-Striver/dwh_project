/*
========================================================================================================================
here we will validate the bronze layer data and do some checks before inserting into silver layer. 
*/

-- mandatory field should not be null ( primary key)

select cst_id 
from 
bronze.crm_cust_info 
where 
cst_id is null;

-- primary key should not be duplicate

select count(*) from bronze.crm_cust_info;
select count(distinct cst_id) from bronze.crm_cust_info;

select cst_id, count(cst_id) as total_count from bronze.CRM_CUST_INFO
group by cst_id
having count(cst_id)>1;  -- in this query, we are performing count(column) which will ignore null count. 

--to include null count in cst_id, here is the refined query
select cst_id, count(*) 
from bronze.crm_cust_info 
group by cst_id
having count(*)>1;

-- what if null count is only one. How would you include that into query?
select cst_id, count(*) 
from bronze.crm_cust_info 
group by cst_id
having count(*)>1 or cst_id is null;

-- now we will analyze the duplicate values of cst_id to see what should be included in the table or what should be rejected

select * from bronze.crm_cust_info
where cst_id = <cst_id> ; -- here provide duplicate cst_id to see which one should be included


--- this query will show the results of all duplicate values appearing in the table
select * from bronze.CRM_CUST_INFO
where cst_id in 
(select cst_id from 
(select cst_id, count(cst_id) as total_count from bronze.CRM_CUST_INFO
group by cst_id
having count(cst_id)>1) t
);

-- in the above query, we are using nested subquery. 
-- to optimize the above query, we will use join. 
SELECT a.*
FROM bronze.CRM_CUST_INFO a
JOIN (
    SELECT cst_id
    FROM bronze.CRM_CUST_INFO
    GROUP BY cst_id
    HAVING COUNT(*) > 1 or cst_id is null
) b
ON a.cst_id = b.cst_id;


-- taking correct records from duplicate values in table 
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

-- now we can copy data from bronze to silver
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


-- we will do same for bronze.crm_prd_info
select prd_id,
SUBSTRING(prd_key,7, LEN(prd_key)) as prd_key,
REPLACE(SUBSTRING(prd_key, 1, 5), '-','_') as cat_id,-- EXCTRACT category id
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
CAST(LEAD(prd_start_dt) over(partition by prd_key order by prd_start_dt)-1  as DATE) prd_edn_dt

from bronze.CRM_PRD_INFO
;

-- sales details table
select * from bronze.crm_sales_details;

-- check for spaces in sls_ord_num
select * from bronze.CRM_SALES_DETAILS
where sls_ord_num != trim(sls_ord_num);

select * from bronze.CRM_SALES_DETAILS
where sls_prd_key not in (select prd_key from silver.CRM_PRD_INFO);

select * from bronze.CRM_SALES_DETAILS
where sls_cust_id not in (select cst_id from silver.CRM_CUST_INFO);

-- three date columns are integer. 
-- we need to be careful while converting them into date 

-- check for invalid dates
select sls_order_dt from bronze.CRM_SALES_DETAILS
where sls_order_dt <=0;

-- replace 0 with null
select nullif(sls_order_dt,0) as sls_order_dt from bronze.CRM_SALES_DETAILS
where sls_order_dt <=0;

-- date length should of 8
select sls_order_dt from bronze.CRM_SALES_DETAILS
where len(sls_order_dt)!= 8 or
 sls_order_dt > 20250830 or 
 sls_order_dt < 19000101; --here below value you can give when your business started


-- transformed date column
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
 sls_sales,
 sls_quantity,
 sls_price
from bronze.CRM_SALES_DETAILS;

-- we need to perform one more check that whether order_date should be less than or equal to shipping date or due_date
select sls_order_dt from bronze.CRM_SALES_DETAILS
where sls_order_dt > sls_ship_dt or sls_order_dt > sls_due_dt or sls_ship_dt > sls_due_dt;

-- check for data consistency
--business rules:
/*
  between sales, quantity and price:
  sales = quantity * price
  values must not be null, zero or negative

*/

select  sls_sales,
sls_quantity, 
sls_price 
from 
bronze.CRM_SALES_DETAILS
where sls_sales != sls_quantity * sls_price or 
sls_quantity is null or sls_price is null or sls_sales is null
or sls_quantity <=0 or sls_price <=0 or sls_sales<=0;


-- usually data needs to cleaned at source team. but if you want to improve data quality by yourself, you can follow below business rules 
/*
 - if sales is negative, zero or null, then derive it using quantity and price
 - if price is zero or null, calculate it using sales or quantity
 - if price is negative, convert it to positive value
 - 
*/

select  sls_sales,
sls_quantity, 
sls_price ,
case when sls_sales is null or sls_sales <=0 or sls_sales != sls_quantity * ABS(sls_price) then 
       sls_quantity * ABS(sls_price)
else sls_sales
end as new_sls_sales, 
case when sls_price is null or sls_price <= 0 then 
 sls_sales /nullif(sls_quantity,0)
else sls_price 
end as new_sls_price
from 
bronze.CRM_SALES_DETAILS
where sls_sales != sls_quantity * sls_price or 
sls_quantity is null or sls_price is null or sls_sales is null
or sls_quantity <=0 or sls_price <=0 or sls_sales<=0;


-- here we got full transformation logic for crm_sales_details table
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

-- after loading into silver table - crm_sales_details
-- we will validate the results

-- check for invalid dates


-- transforming bronze.ERP_CUST_AZ12 

-- check for distinct values of gender column
select distinct gen from bronze.ERP_CUST_AZ12;

select case when gen = 'F'  or gen= 'Female' then 'Female'
            when gen = 'M' or gen = 'Male' then 'Male'
            else 'n/a'
            end as Gen
            from bronze.ERP_CUST_AZ12;



-- quality check for silver table



