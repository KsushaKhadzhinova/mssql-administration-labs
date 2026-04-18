#!/bin/bash

export SQL_PW="YourStrongPassword123!"
export DB_TEST="Test_KK"
export DB_PROD="ProjectDB"
PROJECT_ROOT="$(cd "$(dirname "$0")/.." && pwd)"

run_sql1() {
    docker exec -i sql1 /opt/mssql-tools18/bin/sqlcmd -S localhost -U sa -P "$SQL_PW" -C -Q "$1"
}

run_sql2() {
    docker exec -i sql2 /opt/mssql-tools18/bin/sqlcmd -S localhost -U sa -P "$SQL_PW" -C -Q "$1"
}

run_sql3() {
    docker exec -i sql3 /opt/mssql-tools18/bin/sqlcmd -S localhost -U sa -P "$SQL_PW" -C -Q "$1"
}

docker-compose up -d
sleep 30

run_sql1 "
CREATE DATABASE [$DB_TEST] ON PRIMARY (
    NAME = testdata_a, FILENAME = '/var/opt/mssql/data/testdata_a.mdf',
    SIZE = 4MB, MAXSIZE = 10MB, FILEGROWTH = 2MB
);
ALTER DATABASE [$DB_TEST] ADD FILEGROUP TestFileGroup;
ALTER DATABASE [$DB_TEST] ADD FILE (
    NAME = testdata_b, FILENAME = '/var/opt/mssql/data/testdata_b.ndf',
    SIZE = 5MB, MAXSIZE = UNLIMITED, FILEGROWTH = 2048KB
) TO FILEGROUP TestFileGroup;
GO
USE [$DB_TEST];
CREATE SCHEMA [CustomSchema];
CREATE TABLE [CustomSchema].[Table_1] (ID INT PRIMARY KEY IDENTITY(1,1), Info NVARCHAR(100));
CREATE USER [OtherUser] WITHOUT LOGIN;
CREATE SCHEMA [OtherOwnerSchema] AUTHORIZATION [OtherUser];
"

run_sql1 "
BACKUP DATABASE [master] TO DISK = N'/var/opt/mssql/backup/master_full.bak' WITH FORMAT;
ALTER DATABASE [$DB_TEST] SET RECOVERY FULL;
BACKUP DATABASE [$DB_TEST] TO DISK = N'/var/opt/mssql/backup/test_full.bak' WITH FORMAT;
"

TARGET_FILE="$PROJECT_ROOT/volumes/sql1/data/testdata_a.mdf"
docker stop sql1
sudo chmod 666 "$TARGET_FILE"
sudo dd if=/dev/zero of="$TARGET_FILE" bs=1 count=4096 conv=notrunc
docker start sql1
sleep 20

run_sql1 "USE [master]; RESTORE DATABASE [$DB_TEST] FROM DISK = N'/var/opt/mssql/backup/test_full.bak' WITH REPLACE, RECOVERY;"

run_sql2 "
USE [master];
RESTORE DATABASE [Test_Restored] FROM DISK = N'/var/opt/mssql/backup/test_full.bak' 
WITH MOVE 'testdata_a' TO '/var/opt/mssql/data/test_node2.mdf',
     MOVE 'testdata_b' TO '/var/opt/mssql/data/test_node2.ndf',
     MOVE 'Test_log'   TO '/var/opt/mssql/data/test_node2.ldf',
     REPLACE, RECOVERY;
"

run_sql1 "
CREATE DATABASE [$DB_PROD];
GO
USE [$DB_PROD];
CREATE TABLE Categories (CategoryID INT PRIMARY KEY IDENTITY(1,1), CategoryName NVARCHAR(100));
CREATE TABLE Suppliers (SupplierID INT PRIMARY KEY IDENTITY(1,1), SupplierName NVARCHAR(150));
CREATE TABLE Products (ProductID INT PRIMARY KEY IDENTITY(1,1), ProductName NVARCHAR(200), CategoryID INT, SupplierID INT, UnitPrice DECIMAL(18,2));
CREATE TABLE Stocks (StockID INT PRIMARY KEY IDENTITY(1,1), ProductID INT, Quantity INT);
CREATE TABLE Customers (CustomerID INT PRIMARY KEY IDENTITY(1,1), FullName NVARCHAR(200));
CREATE TABLE Orders (OrderID INT PRIMARY KEY IDENTITY(1,1), CustomerID INT, TotalAmount DECIMAL(18,2));
CREATE TABLE OrderDetails (DetailID INT PRIMARY KEY IDENTITY(1,1), OrderID INT, ProductID INT, Quantity INT, PriceAtOrder DECIMAL(18,2));
INSERT INTO Categories (CategoryName) VALUES ('Electronics'), ('Office');
GO
CREATE LOGIN [TestLogin1] WITH PASSWORD = N'$SQL_PW', CHECK_POLICY = OFF;
CREATE LOGIN [TestLogin2] WITH PASSWORD = N'$SQL_PW', CHECK_POLICY = OFF;
ALTER SERVER ROLE [sysadmin] ADD MEMBER [TestLogin1];
GO
USE [$DB_TEST];
CREATE USER [TestUser1] FOR LOGIN [TestLogin1];
CREATE USER [TestUser2] FOR LOGIN [TestLogin2];
CREATE ROLE [Manager];
CREATE ROLE [Employee];
ALTER ROLE [Manager] ADD MEMBER [TestUser1];
ALTER ROLE [Employee] ADD MEMBER [TestUser2];
DENY ALTER ON USER::guest TO [Employee];
CREATE SCHEMA [SecureSchema] AUTHORIZATION [TestUser1];
CREATE TABLE [SecureSchema].[SalaryData] (EmployeeID INT, Salary DECIMAL(18,2));
DENY SELECT ON OBJECT::[SecureSchema].[SalaryData] TO [Employee];
GRANT SELECT ON SCHEMA::[dbo] TO [Employee];
"

run_sql1 "
EXEC sp_configure 'show advanced options', 1; RECONFIGURE;
EXEC sp_configure 'Database Mail XPs', 1; RECONFIGURE;
GO
EXECUTE msdb.dbo.sysmail_add_profile_sp @profile_name = 'AdminProfile';
EXECUTE msdb.dbo.sysmail_add_account_sp @account_name = 'AdminAccount', @email_address = 'admin@example.com', @mailserver_name = 'mailhog', @port = 1025;
EXECUTE msdb.dbo.sysmail_add_profileaccount_sp @profile_name = 'AdminProfile', @account_name = 'AdminAccount', @sequence_number = 1;
EXEC msdb.dbo.sp_add_operator @name = N'DBA_Admin', @enabled = 1, @email_address = N'admin@example.com';
GO
USE [msdb];
EXEC dbo.sp_add_job @job_name = N'Daily_Full_Backup';
EXEC sp_add_jobstep @job_name = N'Daily_Full_Backup', @step_name = N'Backup_Step', @command = N'BACKUP DATABASE [$DB_PROD] TO DISK = N''/var/opt/mssql/backup/ProjectDB_Auto.bak'' WITH FORMAT;';
EXEC dbo.sp_add_schedule @schedule_name = N'DailySched', @freq_type = 4, @freq_interval = 1, @active_start_time = 000000;
EXEC sp_attach_schedule @job_name = N'Daily_Full_Backup', @schedule_name = N'DailySched';
EXEC dbo.sp_add_jobserver @job_name = N'Daily_Full_Backup';
GO
EXEC dbo.sp_add_job @job_name = N'Hourly_Log_Backup';
EXEC sp_add_jobstep @job_name = N'Hourly_Log_Backup', @step_name = N'Log_Step', @command = N'BACKUP LOG [$DB_PROD] TO DISK = N''/var/opt/mssql/backup/ProjectDB_Log_Auto.trn'' WITH FORMAT;';
EXEC dbo.sp_add_schedule @schedule_name = N'HourlySched', @freq_type = 4, @freq_interval = 1, @freq_subday_type = 8, @freq_subday_interval = 1;
EXEC sp_attach_schedule @job_name = N'Hourly_Log_Backup', @schedule_name = N'HourlySched';
EXEC dbo.sp_add_jobserver @job_name = N'Hourly_Log_Backup';
GO
EXEC msdb.dbo.sp_add_alert @name = N'Critical I/O Error 823', @message_id = 823, @severity = 0, @enabled = 1;
EXEC msdb.dbo.sp_add_notification @alert_name = N'Critical I/O Error 823', @operator_name = N'DBA_Admin', @notification_method = 1;
"

run_sql1 "
USE master;
EXEC sp_adddistributor @distributor = N'sql1', @password = N'$SQL_PW';
EXEC sp_adddistributiondb @database = N'distribution';
EXEC sp_adddistpublisher @publisher = N'sql1', @distribution_db = N'distribution', @working_directory = N'/var/opt/mssql/backup';
GO
USE [$DB_PROD];
EXEC sp_replicationdboption @dbname = N'$DB_PROD', @optname = N'publish', @value = N'true';
EXEC sp_addpublication @publication = N'Pub_Data', @repl_freq = N'continuous', @status = N'active';
EXEC sp_addpublication_snapshot @publication = N'Pub_Data', @frequency_type = 1;
EXEC sp_addarticle @publication = N'Pub_Data', @article = N'Categories', @source_object = N'Categories', @type = N'logbased';
"

run_sql2 "CREATE DATABASE [ProjectDB_Replica];"

run_sql1 "
USE [$DB_PROD];
EXEC sp_addsubscription @publication = N'Pub_Data', @subscriber = N'sql2', @destination_db = N'ProjectDB_Replica', @subscription_type = N'Push';
EXEC sp_addpushsubscription_agent @publication = N'Pub_Data', @subscriber = N'sql2', @subscriber_db = N'ProjectDB_Replica', @subscriber_security_mode = 1;
"

run_sql3 "
USE [master];
RESTORE DATABASE [ProjectDB_LS] FROM DISK = N'/var/opt/mssql/backup/ProjectDB_Auto.bak' 
WITH MOVE 'ProjectDB' TO '/var/opt/mssql/data/ProjectDB_LS.mdf', 
     MOVE 'ProjectDB_log' TO '/var/opt/mssql/data/ProjectDB_LS.ldf', 
     NORECOVERY, REPLACE;
"

run_sql1 "
USE [$DB_PROD];
SET NOCOUNT ON;
DECLARE @i INT = 1;
WHILE @i <= 60000 BEGIN
    INSERT INTO OrderDetails (OrderID, ProductID, Quantity, PriceAtOrder) VALUES (1, 1, @i % 10 + 1, 100.00);
    SET @i = @i + 1;
END;
CREATE COLUMNSTORE INDEX IX_OrderDetails_CS ON OrderDetails (ProductID, Quantity, PriceAtOrder);
GO
CREATE EVENT SESSION [TrackLongQueries] ON SERVER 
ADD EVENT sqlserver.sql_batch_completed(WHERE ([duration] >= 1000000))
ADD TARGET package0.event_file(SET filename=N'/var/opt/mssql/log/long_queries.xel');
ALTER EVENT SESSION [TrackLongQueries] ON SERVER STATE = START;
"
