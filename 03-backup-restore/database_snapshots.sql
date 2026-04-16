-- 1. Create Snapshot
CREATE DATABASE Test_Snapshot ON 
( NAME = testdata_a, FILENAME = '/var/opt/mssql/data/test_snap.ss' )
AS SNAPSHOT OF [Test];
GO

-- 2. Simulate accidental data deletion
USE [Test];
GO
DELETE FROM [CustomSchema].[Table_1];
GO

-- 3. Revert from Snapshot
USE [master];
GO
RESTORE DATABASE [Test] FROM DATABASE_SNAPSHOT = 'Test_Snapshot';
GO

-- 4. Cleanup
DROP DATABASE Test_Snapshot;
GO
