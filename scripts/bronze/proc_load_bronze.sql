/*
=========================================================================
Bronze Layer Data Loading Stored Procedure Explanation
=========================================================================
This stored procedure, `bronze.load_bronze`, is designed to automate the ingestion of raw source data into the **Bronze Layer** of a Data Warehouse. In a modern data engineering architecture, the Bronze Layer represents the raw landing zone where data is loaded from operational source systems before cleaning, transformation, validation, and modelling are applied in later layers such as Silver and Gold.

The procedure loads data from two main source systems: **CRM** and **ERP**. The CRM source contains customer, product, and sales transaction data, while the ERP source contains customer demographic, location, and product category reference data. Each dataset is stored as a CSV file and loaded into its corresponding table inside the `bronze` schema.

The process begins by declaring timing variables such as `@start_time`, `@end_time`, `@batch_start_time`, and `@batch_end_time`. These variables are used to measure the duration of each table load as well as the total execution time of the full batch. This is important in production data pipelines because it helps monitor performance, identify bottlenecks, and support operational troubleshooting.

Before loading each table, the procedure uses `TRUNCATE TABLE` to remove any existing data from the Bronze tables. This ensures that every execution performs a fresh full reload of the source files, preventing duplicate records and keeping the Bronze Layer aligned with the latest source data extract.

The actual data ingestion is performed using the SQL Server `BULK INSERT` command. This allows large CSV files to be loaded efficiently into SQL Server tables. The option `FIRSTROW = 2` tells SQL Server to skip the header row in each CSV file, while `FIELDTERMINATOR = ','` defines the comma as the delimiter between columns. The `TABLOCK` option improves loading performance by applying a table-level lock during the bulk insert operation.

The stored procedure loads the following Bronze tables:

* 'bronze.crm_cust_info'
* 'bronze.crm_prd_info.'
* 'bronze.crm_sales_details'
* 'bronze.erp_loc_a101.'
* 'bronze.erp_cust_az12'
* 'bronze.erp_px_cat_g1v2.'

Each table load follows the same structured process: capture the start time, truncate the target table, bulk insert the CSV data, capture the end time, and print the load duration. This makes the procedure consistent, readable, and easier to maintain.

The procedure is wrapped inside a `TRY...CATCH` block to provide error handling. If any failure occurs during the loading process, such as a missing file, incorrect file path, permission issue, schema mismatch, or invalid data format, the `CATCH` block captures and prints the error message, error number, and error state. This improves pipeline reliability and makes debugging easier.

At the end of the successful execution, the procedure prints the total batch duration. This provides visibility into the overall Bronze Layer loading performance and confirms that the ingestion process has completed.

Overall, this stored procedure demonstrates a structured ETL/ELT ingestion pattern where raw CRM and ERP data is systematically loaded into a SQL Server Data Warehouse. It includes key production-style data engineering practices such as batch processing, table refresh logic, bulk loading, execution logging, performance tracking, and error handling.
Parameters: 
None.
This stored procedure does not accept any parameters or return any values.
Usage Example:
EXEC bronze.load_bronze;
*/

CREATE OR ALTER PROCEDURE bronze.load_bronze AS 
BEGIN
   DECLARE @start_time DATETIME, @end_time DATETIME, @batch_start_time DATETIME, @batch_end_time DATETIME;
    BEGIN TRY
	SET @batch_start_time = GETDATE();
		PRINT '=======================================================';
		PRINT 'Loading Bronzer Layer';
		PRINT '=======================================================';

		PRINT '>> -------------------------------------------------';
		PRINT 'Loading CRM TABLE';
		PRINT '>> -------------------------------------------------';
		----=================================================
		--- INSERT INTO OUR TABLE BY USING BULK INSERT CRM
		----=================================================
		SET @start_time = GETDATE();
		PRINT '>>> Truncating Table:bronze.crm_cust_info';
		TRUNCATE TABLE bronze.crm_cust_info
		PRINT '>>> Inserting Table: bronze.crm_cust_info';
		BULK INSERT bronze.crm_cust_info
		FROM 'C:\Users\newuser123\Downloads\data_warehouse\source_crm\cust_info.csv'
		WITH (
		FIRSTROW = 2,
		FIELDTERMINATOR = ',',
		TABLOCK
		);
		SET @end_time = GETDATE();
		PRINT'>> Load Duration:' + CAST(DATEDIFF(second, @start_time, @end_time) AS NVARCHAR) + ' seconds';
		PRINT'>> ---------------------';
	
		----=====================================================
		--- INSERT INTO USING BULK INSERT INTO CRM_PRD_INFO
		----====================================================
		SET @start_time = GETDATE();
		PRINT '>>> Truncating Table:bronze.crm_prd_info';
		TRUNCATE TABLE bronze.crm_prd_info
		PRINT '>>> Inserting Table: bronze.crm_prd_info';
		BULK INSERT bronze.crm_prd_info
		FROM 'C:\Users\newuser123\Downloads\data_warehouse\source_crm\prd_info.csv'
		WITH (
		FIRSTROW = 2,
		FIELDTERMINATOR = ',',
		TABLOCK
		);
		SET @end_time = GETDATE();
		PRINT'>> Load Duration:' + CAST(DATEDIFF(second, @start_time, @end_time) AS NVARCHAR) + ' seconds';
		PRINT'>> ---------------------';
		
		----=====================================================
		--- INSERT INTO USING BULK INSERT INTO CRM_SALES_DETAILS
		----=====================================================
		SET @start_time = GETDATE();
		PRINT '>>> Truncating Table: bronze.crm_sales_details';
		TRUNCATE TABLE bronze.crm_sales_details
		PRINT '>>> Inserting Table: bronze.crm_sales_details';
		BULK INSERT bronze.crm_sales_details
		FROM 'C:\Users\newuser123\Downloads\data_warehouse\source_crm\sales_details.csv'
		WITH(
		FIRSTROW = 2,
		FIELDTERMINATOR = ',',
		TABLOCK
		);
		SET @end_time = GETDATE();
		PRINT'>> Load Duration:' + CAST(DATEDIFF(second, @start_time, @end_time) AS NVARCHAR) + ' seconds';
		PRINT'>> ---------------------';

		PRINT '-------------------------------------------------';
		PRINT 'Loading ERP TABLE';
		PRINT '-------------------------------------------------';

		----=========================================================
		--- INSERT INTO USING BULK INSERT bronze.erp_loc_a101
		----=========================================================
		SET @start_time = GETDATE();
		PRINT '>>> Truncating Table: bronze.erp_loc_a101';
		TRUNCATE TABLE bronze.erp_loc_a101
		PRINT '>>> Inserting into Table: bronze.erp_loc_a101';
		BULK INSERT bronze.erp_loc_a101
		FROM 'C:\Users\newuser123\Downloads\data_warehouse\source_erp\loc_a101.csv'
		WITH (
		FIRSTROW = 2,
		FIELDTERMINATOR = ',',
		TABLOCK
		);
		SET @end_time = GETDATE();
		PRINT'>> Load Duration:' + CAST(DATEDIFF(second, @start_time, @end_time) AS NVARCHAR) + ' seconds';
		PRINT'>> ---------------------';
	
		----=======================================================
		--- INSERT INTO USING BULK INSERT bronze.erp_cust_az12
		----=======================================================
		SET @start_time = GETDATE();
		PRINT '>>> Truncating Table: bronze.erp_cust_az12';
		TRUNCATE TABLE bronze.erp_cust_az12
		PRINT '>>> Inserting into Table: bronze.erp_cust_az12';
		BULK INSERT bronze.erp_cust_az12
		FROM 'C:\Users\newuser123\Downloads\data_warehouse\source_erp\cust_az12.csv'
		WITH(
		FIRSTROW = 2,
		FIELDTERMINATOR = ',',
		TABLOCK
		);
		SET @end_time= GETDATE();
		PRINT'>> Load Duration:' + CAST(DATEDIFF(second, @start_time, @end_time) AS NVARCHAR) + ' seconds';
		PRINT'>> ---------------------';
	
		----==========================================================
		--- INSERT INTO USING BULK INSERT INTO bronze.erp_px_cat_g1v2
		----==========================================================
		SET @start_time = GETDATE();
		PRINT '>>> Truncating Table: bronze.erp_px_cat_g1v2';
		TRUNCATE TABLE bronze.erp_px_cat_g1v2
		PRINT '>>> Inserting into Table: bronze.erp_px_cat_g1v2';
		BULK INSERT bronze.erp_px_cat_g1v2
		FROM 'C:\Users\newuser123\Downloads\data_warehouse\source_erp\px_cat_g1v2.csv'
		WITH(
		FIRSTROW = 2,
		FIELDTERMINATOR = ',',
		TABLOCK 
	);
	SET @end_time= GETDATE();
	PRINT'>> Load Duration:' + CAST(DATEDIFF(second, @start_time, @end_time) AS NVARCHAR) + ' seconds';
		PRINT'>> ---------------------';
	SET @batch_end_time = GETDATE();
	PRINT'=========================================================='
	PRINT'Loading Bronzer Layer is Completed';
	PRINT' - Total Load Duration: '+ CAST(DATEDIFF(SECOND, @batch_start_time, @batch_end_time) AS NVARCHAR) + ' seconds';
	PRINT'==========================================================='
  END TRY
  BEGIN CATCH
     PRINT '========================================================'
	 PRINT 'ERROR OCCURED DURING LOADING BRONZE LAYER';
	 PRINT 'Error Message' + ERROR_MESSAGE();
	 PRINT 'Error Message' + CAST(ERROR_NUMBER() AS NVARCHAR);
	 PRINT 'Error Message' + CAST(ERROR_STATE() AS NVARCHAR);
	 PRINT '========================================================'
  END CATCH 
END
