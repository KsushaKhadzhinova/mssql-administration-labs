#!/bin/bash
S1="localhost,14331"
S2="localhost,14332"
S3="localhost,14333"
P="YourStrongPassword123!"
MY_EMAIL="kseniyakhadzhynava@gmail.com"
CMD="/opt/mssql-tools18/bin/sqlcmd -U sa -P $P -C"

echo "Initialization started..."

$CMD -S $S1 -Q "IF NOT EXISTS (SELECT * FROM sys.databases WHERE name = 'Test') CREATE DATABASE [Test] ON PRIMARY (NAME = N'testdata_a', FILENAME = N'/var/opt/mssql/data/testdata_a.mdf', SIZE = 10MB);"
$CMD -S $S1 -Q "BACKUP DATABASE [Test] TO DISK = '/var/opt/mssql/backup/test.bak' WITH FORMAT;"

bash ../03-backup-restore/simulate_corruption.sh

$CMD -S $S1 -Q "RESTORE DATABASE [Test] FROM DISK = '/var/opt/mssql/backup/test.bak' WITH REPLACE;"

$CMD -S $S1 -Q "IF NOT EXISTS (SELECT * FROM sys.server_principals WHERE name = 'TestLogin1') BEGIN CREATE LOGIN [TestLogin1] WITH PASSWORD = '$P'; ALTER SERVER ROLE [sysadmin] ADD MEMBER [TestLogin1]; END"

$CMD -S $S1 -Q "EXEC sp_configure 'show advanced options', 1; RECONFIGURE; EXEC sp_configure 'Database Mail XPs', 1; RECONFIGURE;"
$CMD -S $S1 -Q "IF NOT EXISTS (SELECT * FROM msdb.dbo.sysoperators WHERE name = 'DBA_Admin') EXEC msdb.dbo.sp_add_operator @name = 'DBA_Admin', @enabled = 1, @email_address = '$MY_EMAIL';"

$CMD -S $S1 -i ../06-replication-ha/setup_replication_distributor.sql

$CMD -S $S1 -d ProjectDB -Q "IF NOT EXISTS (SELECT * FROM sys.tables WHERE name = 'OrderDetails') CREATE TABLE OrderDetails (ID INT IDENTITY PRIMARY KEY, ProductID INT, Quantity INT);"
$CMD -S $S1 -d ProjectDB -Q "INSERT INTO OrderDetails (ProductID, Quantity) SELECT TOP 100 1, 10 FROM sys.objects;"
$CMD -S $S1 -d ProjectDB -Q "IF NOT EXISTS (SELECT * FROM sys.indexes WHERE name = 'IX_CS_OrderDetails') CREATE COLUMNSTORE INDEX [IX_CS_OrderDetails] ON [OrderDetails] (ProductID, Quantity);"

echo "All labs executed successfully."
