-- adjust the query as per silver layer. 

CREATE VIEW BRONZE.DQ_COMPLETENESS_VIEW AS 
select 
'STG_Orders' AS [table],
'RowID' AS [attribute],
sum(case WHEN "RowID" IS NULL THEN 1 ELSE 0 END) AS count_null_records
from public."STG_Orders"
union all 
select 
'STG_Orders',
'OrderID',
sum(case WHEN "OrderID" IS NULL THEN 1 ELSE 0 END)
from public."STG_Orders"
union all 
select 
'STG_Orders',
'OrderDate',
sum(case WHEN "OrderDate" IS NULL THEN 1 ELSE 0 END)
from public."STG_Orders"
union all 
select 
'STG_Orders',
'OrderPriority',
sum(case WHEN "OrderPriority" IS NULL THEN 1 ELSE 0 END)
from public."STG_Orders"
union all 
select 
'STG_Orders',
'OrderQuantity',
sum(case WHEN "OrderQuantity" IS NULL THEN 1 ELSE 0 END)
from public."STG_Orders"
union all 
select 
'STG_Orders',
'Sales',
sum(case WHEN "Sales" IS NULL THEN 1 ELSE 0 END)
from public."STG_Orders"
union all 
select 
'STG_Orders',
'Discount',
sum(case WHEN "Discount" IS NULL THEN 1 ELSE 0 END)
from public."STG_Orders"
union all 
select 
'STG_Orders',
'ShipMode',
sum(case WHEN "ShipMode" IS NULL THEN 1 ELSE 0 END)
from public."STG_Orders"
union all 
select 
'STG_Orders',
'Profit',
sum(case WHEN "Profit" IS NULL THEN 1 ELSE 0 END)
from public."STG_Orders"
union all 
select 
'STG_Orders',
'UnitPrice',
sum(case WHEN "UnitPrice" IS NULL THEN 1 ELSE 0 END)
from public."STG_Orders"
union all 
select 
'STG_Orders',
'ShippingCost',
sum(case WHEN "ShippingCost" IS NULL THEN 1 ELSE 0 END)
from public."STG_Orders"
union all 
select 
'STG_Orders',
'CustomerName',
sum(case WHEN "CustomerName" IS NULL THEN 1 ELSE 0 END)
from public."STG_Orders"
union all 
select 
'STG_Orders',
'ProductName',
sum(case WHEN "ProductName" IS NULL THEN 1 ELSE 0 END)
from public."STG_Orders"
union all 
select 
'STG_Orders',
'ShipDate',
sum(case WHEN "ShipDate" IS NULL THEN 1 ELSE 0 END)
from public."STG_Orders"