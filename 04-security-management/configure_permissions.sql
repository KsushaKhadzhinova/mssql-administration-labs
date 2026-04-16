USE [ProjectDB];
GO

-- 1. Restrict guest user (Lab requirement)
DENY ALTER ON USER::guest TO [Employee];
GO

-- 2. Create a secure schema and transfer ownership
CREATE SCHEMA [SecureSchema] AUTHORIZATION [TestUser1];
GO

-- 3. Create a sensitive table in the secure schema
CREATE TABLE [SecureSchema].[SalaryData] (
    EmployeeID INT,
    Salary DECIMAL(18,2)
);
GO

-- 4. Apply DENY on specific objects
-- Ensure TestUser2 (Employee) cannot read sensitive data even if they have general access
DENY SELECT ON OBJECT::[SecureSchema].[SalaryData] TO [Employee];
GO

-- 5. Grant general permissions
GRANT SELECT ON SCHEMA::[dbo] TO [Employee];
GO
