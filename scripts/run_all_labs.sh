#!/bin/bash

# =================================================================
# MSSQL Administration Labs: Consolidated Execution Script
# Скрипт автоматизации для Лабораторных работ 1.1 - 2.3
# =================================================================

# Настройки подключения
S1="localhost,14331"
S2="localhost,14332"
S3="localhost,14333"
P="YourStrongPassword123!"
CMD="/opt/mssql-tools18/bin/sqlcmd -U sa -P $P -C"

echo "--------------------------------------------------------"
echo "Starting Consolidated Lab Execution..."
echo "--------------------------------------------------------"

# --- LAB 1.1 & 1.2: Installation, Connectivity & DB Management ---
echo "[1/7] Running Lab 1.1 & 1.2: System Check and DB Creation..."
$CMD -S $S1 -Q "SELECT @@SERVERNAME AS 'Instance1', @@VERSION AS 'Version';"
$CMD -S $S2 -Q "SELECT @@SERVERNAME AS 'Instance2';"

# Создание базы данных Test с файловыми группами и лимитами
$CMD -S $S1 -Q "
CREATE DATABASE [Test] ON PRIMARY 
(NAME = N'testdata_a', FILENAME = N'/var/opt/mssql/data/testdata_a.mdf', SIZE = 4MB, MAXSIZE = 10MB, FILEGROWTH = 2MB)
LOG ON (NAME = N'Test_log', FILENAME = N'/var/opt/mssql/data/Test_log.ldf', SIZE = 8MB, MAXSIZE = 2GB, FILEGROWTH = 64MB);
ALTER DATABASE [Test] ADD FILEGROUP [TestFileGroup];
ALTER DATABASE [Test] ADD FILE (NAME = N'testdata_b', FILENAME = N'/var/opt/mssql/data/testdata_b.ndf', SIZE = 5MB) TO FILEGROUP [TestFileGroup];
"

# --- LAB 1.3: Disaster Recovery, Backup and Restore ---
echo "[2/7] Running Lab 1.3: Backup and Corruption Simulation..."
# Бэкап
$CMD -S $S1 -Q "BACKUP DATABASE [master] TO DISK = '/var/opt/mssql/backup/master_full.bak' WITH FORMAT;"
$CMD -S $S1 -Q "BACKUP DATABASE [Test] TO DISK = '/var/opt/mssql/backup/test_full.bak' WITH FORMAT;"

# Имитация поломки
echo "Stopping sql1 and corrupting data file..."
docker stop sql1
sudo dd if=/dev/zero of=./volumes/sql1/data/testdata_a.mdf bs=1 count=4096 conv=notrunc
docker start sql1
echo "Waiting for sql1 to recover (15s)..."
sleep 15

# Восстановление
$CMD -S $S1 -Q "RESTORE DATABASE [Test] FROM DISK = '/var/opt/mssql/backup/test_full.bak' WITH REPLACE;"

# --- LAB 1.4: Security Management ---
echo "[3/7] Running Lab 1.4: Security, Roles and Deny Permissions..."
$CMD -S $S1 -Q "
CREATE LOGIN [TestLogin1] WITH PASSWORD = '$P', CHECK_POLICY = OFF;
CREATE LOGIN [TestLogin2] WITH PASSWORD = '$P', CHECK_POLICY = OFF;
ALTER SERVER ROLE [sysadmin] ADD MEMBER [TestLogin1];
USE [ProjectDB];
CREATE USER [TestUser1] FOR LOGIN [TestLogin1];
CREATE USER [TestUser2] FOR LOGIN [TestLogin2];
CREATE ROLE [Manager]; CREATE ROLE [Employee];
ALTER ROLE [Manager] ADD MEMBER [TestUser1];
ALTER ROLE [Employee] ADD MEMBER [TestUser2];
CREATE SCHEMA [SecureSchema] AUTHORIZATION [TestUser1];
CREATE TABLE [SecureSchema].[PrivateData] (ID INT);
DENY SELECT ON OBJECT::[SecureSchema].[PrivateData] TO [Employee];
"

# --- LAB 2.1: Administration Automation ---
echo "[4/7] Running Lab 2.1: SQL Agent, Mail and Jobs..."
$CMD -S $S1 -Q "
EXEC sp_configure 'show advanced options', 1; RECONFIGURE;
EXEC sp_configure 'Database Mail XPs', 1; RECONFIGURE;
EXEC msdb.dbo.sp_add_operator @name = 'DBA_Admin', @enabled = 1, @email_address = 'xju2005@gmail.com';
EXEC msdb.dbo.sp_add_job @job_name = 'AutoBackup_ProjectDB';
EXEC msdb.dbo.sp_add_jobstep @job_name = 'AutoBackup_ProjectDB', @step_name = 'Step1', 
    @command = 'BACKUP DATABASE [ProjectDB] TO DISK = ''/var/opt/mssql/backup/ProjectDB_Auto.bak'' WITH FORMAT';
EXEC msdb.dbo.sp_add_jobserver @job_name = 'AutoBackup_ProjectDB';
"

# --- LAB 2.2: Replication & High Availability ---
echo "[5/7] Running Lab 2.2: Replication Setup (sql1 -> sql2)..."
$CMD -S $S1 -Q "
EXEC sp_adddistributor @distributor = 'sql1', @password = '$P';
EXEC sp_adddistributiondb @database = 'distribution';
EXEC sp_adddistpublisher @publisher = 'sql1', @distribution_db = 'distribution', @working_directory = '/var/opt/mssql/backup';
USE [ProjectDB];
EXEC sp_replicationdboption @dbname = 'ProjectDB', @optname = 'publish', @value = 'true';
"
# Подготовка sql3 (Log Shipping Standby)
$CMD -S $S3 -Q "RESTORE DATABASE [ProjectDB_LS] FROM DISK = '/var/opt/mssql/backup/test_full.bak' WITH NORECOVERY, 
MOVE 'testdata_a' TO '/var/opt/mssql/data/ls.mdf', MOVE 'Test_log' TO '/var/opt/mssql/data/ls.ldf', REPLACE;"

# --- LAB 2.3: Monitoring & Troubleshooting ---
echo "[6/7] Running Lab 2.3: Performance Tuning & Columnstore..."
$CMD -S $S1 -d ProjectDB -Q "
SET NOCOUNT ON;
DECLARE @i INT = 1; WHILE @i <= 10000 BEGIN 
INSERT INTO OrderDetails (OrderID, ProductID, Quantity, PriceAtOrder) VALUES (1, 1, 5, 10.0); 
SET @i = @i + 1; END;
CREATE COLUMNSTORE INDEX [IX_CS_OrderDetails] ON [OrderDetails] (ProductID, Quantity);
"
# Проверка плана (текстовый режим)
echo "Execution Plan Verification:"
$CMD -S $S1 -d ProjectDB -Q "SET SHOWPLAN_TEXT ON; GO SELECT ProductID, SUM(Quantity) FROM OrderDetails GROUP BY ProductID; GO SET SHOWPLAN_TEXT OFF;"

echo "--------------------------------------------------------"
echo "All Lab Works (1.1 - 2.3) completed successfully!"
echo "--------------------------------------------------------"
