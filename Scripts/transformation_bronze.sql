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

-- check for unwanted spaces 


