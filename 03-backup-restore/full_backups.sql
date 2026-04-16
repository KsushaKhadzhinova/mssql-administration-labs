-- 1. Backup system database
BACKUP DATABASE [master] TO DISK = N'/var/opt/mssql/backup/master_full.bak' WITH FORMAT, NAME = N'Master-Full Backup';
GO

-- 2. Prepare Test database for log chain
ALTER DATABASE [Test] SET RECOVERY FULL;
GO

-- 3. Backup user database
BACKUP DATABASE [Test] TO DISK = N'/var/opt/mssql/backup/test_full.bak' WITH FORMAT, NAME = N'Test-Full Backup';
GO

-- 4. Initial Log backup
BACKUP LOG [Test] TO DISK = N'/var/opt/mssql/backup/test_log1.bak' WITH FORMAT, NAME = N'Test-Log Backup 1';
GO
