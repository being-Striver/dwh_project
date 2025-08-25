USE MASTER; 

GO 

-- drop and recreate `dwh` database
IF EXISTS (SELECT 1 from sys.DATABASES where name = 'pancard')
BEGIN 
  ALTER DATABASE pancard set SINGLE_USER WITH ROLLBACK IMMEDIATE;
  DROP DATABASE pancard;
END;

GO 
-- create dwh database

CREATE DATABASE pancard;

GO 
CREATE SCHEMA pancard_schema;

GO 
CREATE TABLE pancard_schema.govt_id(
pan_number NVARCHAR(50) 
);

BULK INSERT pancard_schema.govt_id 
FROM 
'C:\Users\shudh\OneDrive\Desktop\dwh_project\PAN_NO_Validation_Project\PAN Number Validation Dataset.csv'

WITH 
(
FIRSTROW = 2,
FIELDTERMINATOR = '\n',
TABLOCK
);
