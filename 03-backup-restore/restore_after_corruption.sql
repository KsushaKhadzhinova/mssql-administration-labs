USE [master];
GO

-- Force restore from the full backup to overwrite corrupted files
RESTORE DATABASE [Test] 
FROM DISK = N'/var/opt/mssql/backup/test_full.bak' 
WITH REPLACE, RECOVERY;
GO

-- Verify database is online
SELECT name, state_desc FROM sys.databases WHERE name = 'Test';
GO
