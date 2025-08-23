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
having count(cst_id)>1;

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
    HAVING COUNT(*) > 1
) b
ON a.cst_id = b.cst_id;

