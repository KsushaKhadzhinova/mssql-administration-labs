SELECT 
    @@VERSION AS [Version Info],
    SERVERPROPERTY('Edition') AS [Edition],
    SERVERPROPERTY('ProductLevel') AS [Service Pack];
GO
