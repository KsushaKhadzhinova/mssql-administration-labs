USE [master];
GO

RESTORE DATABASE [Test_Restored] 
FROM DISK = N'/var/opt/mssql/backup/test_full.bak' 
WITH MOVE 'testdata_a' TO '/var/opt/mssql/data/test_node2.mdf',
     MOVE 'testdata_b' TO '/var/opt/mssql/data/test_node2.ndf',
     MOVE 'Test_log'   TO '/var/opt/mssql/data/test_node2.ldf',
     REPLACE, RECOVERY;
GO

SELECT name, state_desc FROM sys.databases WHERE name = 'Test_Restored';
GO
