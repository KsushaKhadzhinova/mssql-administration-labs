USE [ProjectDB];
GO

EXECUTE AS USER = 'TestUser2';
GO
PRINT 'Testing access for TestUser2...';

SELECT TOP 1 * FROM dbo.Products;

BEGIN TRY
    SELECT * FROM SecureSchema.SalaryData;
END TRY
BEGIN CATCH
    PRINT 'Access to SalaryData denied as expected.';
END CATCH

REVERT;
GO
