USE [Test];
GO

CREATE SCHEMA [CustomSchema];
GO

CREATE TABLE [CustomSchema].[Table_1] (
    ID INT PRIMARY KEY IDENTITY(1,1),
    Info NVARCHAR(100)
);
GO

CREATE USER [OtherUser] WITHOUT LOGIN;
GO

CREATE SCHEMA [OtherOwnerSchema] AUTHORIZATION [OtherUser];
GO

SELECT s.name AS SchemaName, u.name AS OwnerName
FROM sys.schemas s
JOIN sys.database_principals u ON s.principal_id = u.principal_id;
GO
