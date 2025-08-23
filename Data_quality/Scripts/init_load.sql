TRUNCATE TABLE BRONZE.CUSTOMERS;

BULK INSERT BRONZE.CUSTOMERS
FROM 
'C:\Users\shudh\OneDrive\Desktop\dwh_project\Data_quality\data\Customers.csv'

WITH 
(
  FIRSTROW = 2, 
  FIELDTERMINATOR = ';',
  TABLOCK
);


TRUNCATE TABLE BRONZE.ORDERS;

BULK INSERT BRONZE.ORDERS
FROM 
'C:\Users\shudh\OneDrive\Desktop\dwh_project\Data_quality\data\Orders.csv'

WITH 
(
  FIRSTROW = 2, 
  FIELDTERMINATOR = ';',
  TABLOCK
);

TRUNCATE TABLE BRONZE.PRODUCTS;

BULK INSERT BRONZE.PRODUCTS
FROM 
'C:\Users\shudh\OneDrive\Desktop\dwh_project\Data_quality\data\Products.csv'

WITH 
(
  FIRSTROW = 2, 
  FIELDTERMINATOR = ';',
  TABLOCK
);

TRUNCATE TABLE BRONZE.REGION_MANAGERS;

BULK INSERT BRONZE.REGION_MANAGERS
FROM 
'C:\Users\shudh\OneDrive\Desktop\dwh_project\Data_quality\data\RegionManagers.csv'

WITH 
(
  FIRSTROW = 2, 
  FIELDTERMINATOR = ';',
  TABLOCK
);

TRUNCATE TABLE BRONZE.RETURNS;

BULK INSERT BRONZE.RETURNS
FROM 
'C:\Users\shudh\OneDrive\Desktop\dwh_project\Data_quality\data\Returns.csv'

WITH 
(
  FIRSTROW = 2, 
  FIELDTERMINATOR = ';',
  TABLOCK
);