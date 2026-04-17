SELECT 
    @@VERSION AS [VersionInfo],
    SERVERPROPERTY('Edition') AS [Edition],
    SERVERPROPERTY('ProductLevel') AS [ServicePack];
GO
