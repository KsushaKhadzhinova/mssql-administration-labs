USE [master];
GO

RESTORE DATABASE [ProjectDB_LS] 
FROM DISK = N'/var/opt/mssql/backup/ProjectDB_Auto.bak' 
WITH MOVE 'ProjectDB' TO '/var/opt/mssql/data/ProjectDB_LS.mdf', 
     MOVE 'ProjectDB_log' TO '/var/opt/mssql/data/ProjectDB_LS.ldf', 
     NORECOVERY, REPLACE;
GO
