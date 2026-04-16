USE [ProjectDB];
GO

-- Test Access for TestUser2 (Employee)
EXECUTE AS USER = 'TestUser2';
GO
PRINT 'Testing access for TestUser2...';

-- Should succeed (General access to dbo)
SELECT TOP 1 * FROM dbo.Products;

-- Should fail (DENY was applied)
BEGIN TRY
    SELECT * FROM SecureSchema.SalaryData;
END TRY
BEGIN CATCH
    PRINT 'Access to SalaryData denied as expected.';
END CATCH

REVERT;
GO
