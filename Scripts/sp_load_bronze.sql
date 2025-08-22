/*
====================================== Bulk INSERT from csv================================================

Before doing full load, make sure you truncate the table. 

*/

CREATE OR ALTER PROCEDURE SP_BRONZE_LOAD AS 
BEGIN 
    DECLARE @batch_start_time DATETIME, @batch_end_time DATETIME;
    SET @batch_start_time = GETDATE();
    BEGIN TRY 
       
        PRINT '==========================================================================' ;
        PRINT 'Loading bronze layer';
        PRINT '==========================================================================' ;

        PRINT '---------------------------------------------------------------------------' ;
        PRINT 'Loading CRM Tables';
        PRINT '---------------------------------------------------------------------------' ;

        PRINT '>> Truncating table : BRONZE.CRM_CUST_INFO';

        TRUNCATE TABLE BRONZE.CRM_CUST_INFO;

        PRINT 'Inserting data into table : BRONZE.CRM_CUST_INFO';

        BULK INSERT BRONZE.CRM_CUST_INFO 
        FROM 
        "C:\Users\shudh\OneDrive\Desktop\dwh_project\datasets\source_crm\cust_info.csv"

        WITH 
        (
        FIRSTROW = 2, 
        FIELDTERMINATOR = ',',
        TABLOCK
        );

        PRINT '>> Truncating table : BRONZE.CRM_PRD_INFO';
        TRUNCATE TABLE BRONZE.CRM_PRD_INFO;

        PRINT 'Inserting data into table : BRONZE.CRM_PRD_INFO';

        BULK INSERT BRONZE.CRM_PRD_INFO 
        FROM 
        "C:\Users\shudh\OneDrive\Desktop\dwh_project\datasets\source_crm\prd_info.csv"

        WITH 
        (
        FIRSTROW = 2, 
        FIELDTERMINATOR = ',',
        TABLOCK
        );

        PRINT '>> Truncating table : BRONZE.CRM_SALES_DETAILS';
        TRUNCATE TABLE BRONZE.CRM_SALES_DETAILS;

        PRINT 'Inserting data into table : BRONZE.CRM_SALES_DETAILS';

        BULK INSERT BRONZE.CRM_SALES_DETAILS 
        FROM 
        "C:\Users\shudh\OneDrive\Desktop\dwh_project\datasets\source_crm\sales_details.csv"

        WITH 
        (
        FIRSTROW = 2, 
        FIELDTERMINATOR = ',',
        TABLOCK
        );

        PRINT '---------------------------------------------------------------------------' ;
        PRINT 'Loading ERP Tables';
        PRINT '---------------------------------------------------------------------------' ;


        PRINT '>> Truncating table : BRONZE.ERP_CUST_AZ12';
        TRUNCATE TABLE BRONZE.ERP_CUST_AZ12;

        PRINT 'Inserting data into table : BRONZE.ERP_CUST_AZ12';
        BULK INSERT BRONZE.ERP_CUST_AZ12
        FROM 
        'C:\Users\shudh\OneDrive\Desktop\dwh_project\datasets\source_erp\CUST_AZ12.csv'

        WITH 
        (
        FIRSTROW = 2,
        FIELDTERMINATOR = ',',
        TABLOCK
        );
        

        PRINT '>> Truncating table : BRONZE.ERP_LOC_A101';
        TRUNCATE TABLE BRONZE.ERP_LOC_A101;

        PRINT 'Inserting data into table : BRONZE.ERP_LOC_A101';
        BULK INSERT BRONZE.ERP_LOC_A101
        FROM 
        'C:\Users\shudh\OneDrive\Desktop\dwh_project\datasets\source_erp\LOC_A101.csv'

        WITH 
        (
        FIRSTROW = 2,
        FIELDTERMINATOR = ',',
        TABLOCK
        );


        PRINT '>> Truncating table : BRONZE.ERP_PX_CAT_G1V2';
        TRUNCATE TABLE BRONZE.ERP_PX_CAT_G1V2;
        PRINT 'Inserting data into table : BRONZE.ERP_PX_CAT_G1V2';
        BULK INSERT BRONZE.ERP_PX_CAT_G1V2
        FROM 
        'C:\Users\shudh\OneDrive\Desktop\dwh_project\datasets\source_erp\PX_CAT_G1V2.csv'

        WITH 
        (
        FIRSTROW = 2,
        FIELDTERMINATOR = ',',
        TABLOCK
        );
    END TRY 
    BEGIN CATCH
        PRINT '===========================================================================';
        PRINT 'ERROR OCCURED DURING LOADING IN BRONZE LAYER';
        PRINT 'Error message ' + ERROR_MESSAGE();
        PRINT 'Error number ' + CAST(ERROR_NUMBER() AS VARCHAR);
        PRINT '===========================================================================';

    END CATCH
    SET @batch_end_time = GETDATE();

    PRINT 'Total batch process period: ' + CAST(DATEDIFF(second, @batch_start_time, @batch_end_time) as VARCHAR) + ' seconds';


END;

EXEC sp_load_bronze;



