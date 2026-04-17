CREATE DATABASE Test_Snapshot ON 
( NAME = testdata_a, FILENAME = '/var/opt/mssql/data/test_snap.ss' )
AS SNAPSHOT OF [Test];
GO

USE [Test];
GO
DELETE FROM [CustomSchema].[Table_1];
GO

USE [master];
GO
RESTORE DATABASE [Test] FROM DATABASE_SNAPSHOT = 'Test_Snapshot';
GO

DROP DATABASE Test_Snapshot;
GO
