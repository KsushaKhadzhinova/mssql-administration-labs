USE [master];
GO

ALTER DATABASE [Test] SET RECOVERY FULL;
GO

BACKUP DATABASE [Test] TO DISK = N'/var/opt/mssql/backup/test_full_rec.bak' WITH FORMAT;
GO

USE [Test];
GO

CREATE TABLE RecoveryTest (
    ID INT IDENTITY(1,1),
    Payload NVARCHAR(100),
    Timestamp DATETIME DEFAULT GETDATE()
);
GO

INSERT INTO RecoveryTest (Payload) VALUES ('Checkpoint 1 - Saved in Log');
GO

BACKUP LOG [Test] TO DISK = N'/var/opt/mssql/backup/test_log_rec.trn' WITH FORMAT;
GO

DELETE FROM RecoveryTest;
GO

USE [master];
GO

RESTORE DATABASE [Test] 
FROM DISK = N'/var/opt/mssql/backup/test_full_rec.bak' 
WITH NORECOVERY, REPLACE;
GO

RESTORE LOG [Test] 
FROM DISK = N'/var/opt/mssql/backup/test_log_rec.trn' 
WITH RECOVERY;
GO

USE [Test];
GO

SELECT * FROM RecoveryTest;
GO
