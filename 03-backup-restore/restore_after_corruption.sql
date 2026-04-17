USE [master];
GO

RESTORE DATABASE [Test] 
FROM DISK = N'/var/opt/mssql/backup/test_full.bak' 
WITH REPLACE, RECOVERY;
GO

SELECT name, state_desc FROM sys.databases WHERE name = 'Test';
GO
