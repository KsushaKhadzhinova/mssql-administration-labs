USE master;
GO
IF NOT EXISTS (SELECT * FROM sys.servers WHERE is_distributor = 1)
BEGIN
    EXEC sp_adddistributor @distributor = N'sql1', @password = N'YourStrongPassword123!';
END
GO
IF NOT EXISTS (SELECT * FROM sys.databases WHERE name = N'distribution')
BEGIN
    EXEC sp_adddistributiondb 
        @database = N'distribution', 
        @data_folder = N'/var/opt/mssql/data', 
        @log_folder = N'/var/opt/mssql/data';
END
GO
IF NOT EXISTS (SELECT * FROM msdb.dbo.MSdistpublishers WHERE name = N'sql1')
BEGIN
    EXEC sp_adddistpublisher 
        @publisher = N'sql1', 
        @distribution_db = N'distribution', 
        @working_directory = N'/var/opt/mssql/backup';
END
GO
