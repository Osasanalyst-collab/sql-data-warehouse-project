---==============================================
--- CREATE DATABASE AND SCHEMAS
--- AUTHOR: OSARINMWIAN NELSON OGHOMWENRHIERE
--- DATE: 20th June 2026
---==============================================
/*
Scipt Purpose: 
This script  creates a new database named 'DataWarehouse' after checking if it already exists.
If the database exists, it is dropped and recreated. Additionally, the scripts sets up three schemas
within the database: 'bronze', 'silver', and 'gold'.

WARNING: Running this script will drop the entire 'DataWarehouse' database if it exists.
All data in the database will be permanently deleted. Proceed with caution and ensure you have proper backups before running this 
script.
*/

USE master;
GO
---======================================================
--- Drop and Recreate the 'DataWarehouse' Database---
---======================================================
IF EXISTS (SELECT 1 FROM sys.databases WHERE name ='DataWarehouse')
BEGIN
ALTER DATABASE DataWarehouse SET SINGLE_USER WITH ROLLBACK IMMEDIATE;
DROP DATABASE DataWarehouse;
END;
----==========================================================
---- Create the 'DataWarehouse' Database
----==========================================================
CREATE DATABASE DataWarehouse;
GO
USE DataWarehouse;
GO
---===========================================================
--- CREATE SCHEMAS
---===========================================================

CREATE SCHEMA bronze;
GO
CREATE SCHEMA silver;
GO
CREATE SCHEMA gold;
