USE master;
GO 

-- drop and recreate `dwh` database
IF EXISTS (SELECT 1 from sys.DATABASES where name = 'data_quality')
BEGIN 
  ALTER DATABASE dwh set SINGLE_USER WITH ROLLBACK IMMEDIATE;
  DROP DATABASE dwh;
END;

GO 
-- create dwh database

CREATE DATABASE data_quality;

GO

use data_quality; 

GO 

create schema bronze;

GO 

create schema silver; 

GO 

create schema gold;

GO 

IF OBJECT_ID ('bronze.bronze_customers', 'U') IS NOT NULL 
    DROP TABLE bronze.bronze_customers;

CREATE TABLE BRONZE.BRONZE_CUSTOMERS
(
customer_name NVARCHAR(100),
province NVARCHAR(50),
region NVARCHAR(50),
customer_segment NVARCHAR(100)
);

IF OBJECT_ID ('bronze.bronze_orders', 'U') IS NOT NULL 
    DROP TABLE bronze.bronze_orders;

CREATE TABLE BRONZE.BRONZE_ORDERS
(
row_id INT, 
order_id INT NOT NULL PRIMARY KEY,
order_date DATE, 
order_priority NVARCHAR(50),
order_quantity INT, 
sales FLOAT,
discount FLOAT,
ship_mode NVARCHAR(100),
profit FLOAT,
unit_price FLOAT,
shipping_cost FLOAT,
customer_name NVARCHAR(100),
product_name NVARCHAR(200),
ship_date DATE
);

IF OBJECT_ID ('bronze.bronze_products', 'U') IS NOT NULL 
    DROP TABLE bronze.bronze_products;

CREATE TABLE BRONZE.BRONZE_PRODUCTS(
product_name NVARCHAR(100),
product_category NVARCHAR(100),
product_subcategory NVARCHAR(100),
product_container NVARCHAR(100),
product_base_margin FLOAT
);

IF OBJECT_ID ('bronze.bronze_region_managers', 'U') IS NOT NULL 
    DROP TABLE bronze.bronze_region_managers;

CREATE TABLE BRONZE.BRONZE_REGION_MANAGERS(
region NVARCHAR(50),
manager NVARCHAR(50)
);

IF OBJECT_ID ('bronze.bronze_returns', 'U') IS NOT NULL 
    DROP TABLE bronze.bronze_returns;


CREATE TABLE BRONZE.BRONZE_RETURNS(
order_id INT, 
status NVARCHAR(50)
);
