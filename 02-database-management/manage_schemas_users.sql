USE [Test];
GO

-- Create a custom schema
CREATE SCHEMA [CustomSchema];
GO

-- Create a table within the new schema
CREATE TABLE [CustomSchema].[Table_1] (
    ID INT PRIMARY KEY IDENTITY(1,1),
    Info NVARCHAR(100)
);
GO

-- Create a user without a login for authorization demo
CREATE USER [OtherUser] WITHOUT LOGIN;
GO

-- Create a schema authorized by the new user
CREATE SCHEMA [OtherOwnerSchema] AUTHORIZATION [OtherUser];
GO

-- Verify schema owners
SELECT s.name AS SchemaName, u.name AS OwnerName
FROM sys.schemas s
JOIN sys.database_principals u ON s.principal_id = u.principal_id;
GO
