/*
========================================== CREATE DATEBASE AND SCHEMAS==========================================================

Script purpose:
 This script purpose is to create new database 'dwh' after checking if it's already exists. If database exists, it is dropped and recreated.
 Additionally scripts sets up three schemas within the database.


WARNING:
 Running all script will drop the database if it exists. All data in the database will be permanently deleted. proceed with caution. 
 Ensure you have proper backups before running this scripts

*/



USE master;
GO 

-- drop and recreate `dwh` database
IF EXISTS (SELECT 1 from sys.DATABASES where name = 'dwh')
BEGIN 
  ALTER DATABASE dwh set SINGLE_USER WITH ROLLBACK IMMEDIATE;
  DROP DATABASE dwh;
END;

GO 
-- create dwh database

CREATE DATABASE dwh;

GO

use dwh; 

GO 

create schema bronze;

GO 

create schema silver; 

GO 

create schema gold;

GO 

