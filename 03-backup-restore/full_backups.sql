BACKUP DATABASE [master] TO DISK = N'/var/opt/mssql/backup/master_full.bak' WITH FORMAT, NAME = N'Master-Full Backup';
GO

ALTER DATABASE [Test] SET RECOVERY FULL;
GO

BACKUP DATABASE [Test] TO DISK = N'/var/opt/mssql/backup/test_full.bak' WITH FORMAT, NAME = N'Test-Full Backup';
GO

BACKUP LOG [Test] TO DISK = N'/var/opt/mssql/backup/test_log1.bak' WITH FORMAT, NAME = N'Test-Log Backup 1';
GO
