EXEC sys.sp_configure N'show advanced options', N'1';
RECONFIGURE;
EXEC sys.sp_configure N'default backup checksum', N'1';
RECONFIGURE;

SELECT 
    SERVERPROPERTY('InstanceDefaultBackupPath') AS DefaultBackupPath;
GO

BACKUP DATABASE [master] 
TO DISK = N'/var/opt/mssql/backup/initial_test.bak' 
WITH NOFORMAT, NOINIT, NAME = N'Master-Full Check', SKIP, NOREWIND, NOUNLOAD, STATS = 10;
GO
