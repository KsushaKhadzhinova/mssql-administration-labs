USE master;
GO

-- 1. Настройка дистрибьютора на sql1
EXEC sp_adddistributor @distributor = N'sql1', @password = N'YourStrongPassword123!';
GO

-- 2. Создание базы данных распределения (distribution)
EXEC sp_adddistributiondb 
    @database = N'distribution', 
    @data_folder = N'/var/opt/mssql/data', 
    @log_folder = N'/var/opt/mssql/data', 
    @min_distretention = 0, 
    @max_distretention = 72, 
    @history_retention = 48;
GO

-- 3. Настройка sql1 как издателя (Publisher)
EXEC sp_adddistpublisher 
    @publisher = N'sql1', 
    @distribution_db = N'distribution', 
    @working_directory = N'/var/opt/mssql/backup'; -- Используем общую папку для снимков
GO
