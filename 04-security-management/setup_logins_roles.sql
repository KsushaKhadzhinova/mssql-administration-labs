CREATE LOGIN [TestLogin1] WITH PASSWORD = N'YourStrongPassword123!', CHECK_POLICY = OFF;
CREATE LOGIN [TestLogin2] WITH PASSWORD = N'YourStrongPassword123!', CHECK_POLICY = OFF;
GO

ALTER SERVER ROLE [sysadmin] ADD MEMBER [TestLogin1];
GO

USE [Test];
GO
CREATE USER [TestUser1] FOR LOGIN [TestLogin1];
CREATE USER [TestUser2] FOR LOGIN [TestLogin2];
GO

CREATE ROLE [Manager];
CREATE ROLE [Employee];
GO

ALTER ROLE [Manager] ADD MEMBER [TestUser1];
ALTER ROLE [Employee] ADD MEMBER [TestUser2];
GO

SELECT dp.name AS RoleName, mp.name AS MemberName
FROM sys.database_role_members drm
JOIN sys.database_principals dp ON drm.role_principal_id = dp.principal_id
JOIN sys.database_principals mp ON drm.member_principal_id = mp.principal_id;
GO
