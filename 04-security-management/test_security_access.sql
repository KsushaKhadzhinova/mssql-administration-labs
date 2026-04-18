USE [Test];
GO

EXECUTE AS USER = 'TestUser2';
GO
PRINT 'Testing access for TestUser2...';

SELECT TOP 1 * FROM CustomSchema.Table_1;

BEGIN TRY
    SELECT * FROM SecureSchema.SalaryData;
END TRY
BEGIN CATCH
    PRINT 'Access to SalaryData denied as expected.';
END CATCH

REVERT;
GO
