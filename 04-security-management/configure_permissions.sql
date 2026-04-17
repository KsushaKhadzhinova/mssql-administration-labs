USE [ProjectDB];
GO

DENY ALTER ON USER::guest TO [Employee];
GO

CREATE SCHEMA [SecureSchema] AUTHORIZATION [TestUser1];
GO

CREATE TABLE [SecureSchema].[SalaryData] (
    EmployeeID INT,
    Salary DECIMAL(18,2)
);
GO

DENY SELECT ON OBJECT::[SecureSchema].[SalaryData] TO [Employee];
GO

GRANT SELECT ON SCHEMA::[dbo] TO [Employee];
GO
