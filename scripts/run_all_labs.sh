#!/bin/bash

export SQL_PW="YourStrongPassword123!"
export DB_NAME="Test_KK"

run_sql1() {
    docker exec -i sql1 /opt/mssql-tools18/bin/sqlcmd -S localhost -U sa -P "$SQL_PW" -C -Q "$1"
}

run_sql2() {
    docker exec -i sql2 /opt/mssql-tools18/bin/sqlcmd -S localhost -U sa -P "$SQL_PW" -C -Q "$1"
}

docker-compose up -d
sleep 30

run_sql1 "CREATE DATABASE [$DB_NAME];"

run_sql1 "
USE [$DB_NAME];
CREATE SCHEMA [CustomSchema];
CREATE TABLE [CustomSchema].[Table_1] (ID INT PRIMARY KEY IDENTITY(1,1), Info NVARCHAR(100));
CREATE USER [OtherUser] WITHOUT LOGIN;
CREATE SCHEMA [OtherOwnerSchema] AUTHORIZATION [OtherUser];
"

run_sql1 "
BACKUP DATABASE [master] TO DISK = N'/var/opt/mssql/backup/master_full.bak' WITH FORMAT;
ALTER DATABASE [$DB_NAME] SET RECOVERY FULL;
BACKUP DATABASE [$DB_NAME] TO DISK = N'/var/opt/mssql/backup/test_full.bak' WITH FORMAT;
BACKUP LOG [$DB_NAME] TO DISK = N'/var/opt/mssql/backup/test_log1.bak' WITH FORMAT;
"

PROJECT_ROOT="$(cd "$(dirname "$0")/.." && pwd)"
TARGET_FILE="$PROJECT_ROOT/volumes/sql1/data/testdata_a.mdf"
docker stop sql1
sudo chmod 666 "$TARGET_FILE"
sudo dd if=/dev/zero of="$TARGET_FILE" bs=1 count=4096 conv=notrunc
docker start sql1
sleep 20

run_sql1 "
USE [master];
RESTORE DATABASE [$DB_NAME] FROM DISK = N'/var/opt/mssql/backup/test_full.bak' WITH REPLACE, RECOVERY;
"

run_sql2 "
USE [master];
RESTORE DATABASE [Test_Restored] 
FROM DISK = N'/var/opt/mssql/backup/test_full.bak' 
WITH MOVE 'testdata_a' TO '/var/opt/mssql/data/test_node2.mdf',
     MOVE 'testdata_b' TO '/var/opt/mssql/data/test_node2.ndf',
     MOVE 'Test_log'   TO '/var/opt/mssql/data/test_node2.ldf',
     REPLACE, RECOVERY;
"

run_sql1 "
CREATE LOGIN [TestLogin1] WITH PASSWORD = N'$SQL_PW', CHECK_POLICY = OFF;
CREATE LOGIN [TestLogin2] WITH PASSWORD = N'$SQL_PW', CHECK_POLICY = OFF;
ALTER SERVER ROLE [sysadmin] ADD MEMBER [TestLogin1];
USE [$DB_NAME];
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
EXECUTE msdb.dbo.sysmail_add_profile_sp @profile_name = 'AdminProfile';
EXECUTE msdb.dbo.sysmail_add_account_sp @account_name = 'AdminAccount', @email_address = 'admin@example.com', @mailserver_name = 'mailhog', @port = 1025;
EXECUTE msdb.dbo.sysmail_add_profileaccount_sp @profile_name = 'AdminProfile', @account_name = 'AdminAccount', @sequence_number = 1;
EXEC msdb.dbo.sp_add_operator @name = N'DBA_Admin', @enabled = 1, @email_address = N'admin@example.com';
"

run_sql1 "
USE [msdb];
EXEC dbo.sp_add_job @job_name = N'Daily_Full_Backup';
EXEC sp_add_jobstep @job_name = N'Daily_Full_Backup', @step_name = N'Backup_Step', @subsystem = N'TSQL', @command = N'BACKUP DATABASE [$DB_NAME] TO DISK = N''/var/opt/mssql/backup/test_auto.bak'' WITH FORMAT;';
EXEC dbo.sp_add_schedule @schedule_name = N'DailySched', @freq_type = 4, @freq_interval = 1, @active_start_time = 000000;
EXEC sp_attach_schedule @job_name = N'Daily_Full_Backup', @schedule_name = N'DailySched';
EXEC dbo.sp_add_jobserver @job_name = N'Daily_Full_Backup';
"

run_sql1 "
USE [$DB_NAME];
DECLARE @i INT = 1;
WHILE @i <= 1000
BEGIN
    INSERT INTO CustomSchema.Table_1 (Info) VALUES ('Data Row ' + CAST(@i AS NVARCHAR(10)));
    SET @i = @i + 1;
END;
CREATE COLUMNSTORE INDEX IX_ColumnStore ON CustomSchema.Table_1 (Info);
SELECT TOP 10 * FROM sys.dm_exec_requests;
"

echo "Full automation completed successfully."
