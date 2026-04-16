USE master;
GO

-- =================================================================================
-- 1. Настройка Дистрибьютора (Distributor)
-- Проверяем, не настроен ли уже дистрибьютор, чтобы избежать ошибок при повторе
-- =================================================================================
IF NOT EXISTS (SELECT * FROM sys.servers WHERE is_distributor = 1)
BEGIN
    EXEC sp_adddistributor 
        @distributor = N'sql1', 
        @password = N'YourStrongPassword123!';
    PRINT 'Distributor [sql1] successfully configured.';
END
ELSE
BEGIN
    PRINT 'Distributor [sql1] is already configured.';
END
GO

-- =================================================================================
-- 2. Создание базы данных распределения (distribution)
-- Файлы размещаются в стандартных директориях Linux-контейнера
-- =================================================================================
IF NOT EXISTS (SELECT * FROM sys.databases WHERE name = N'distribution')
BEGIN
    EXEC sp_adddistributiondb 
        @database = N'distribution', 
        @data_folder = N'/var/opt/mssql/data', 
        @log_folder = N'/var/opt/mssql/data', 
        @min_distretention = 0,      -- минимальное время хранения транзакций (часы)
        @max_distretention = 72,     -- максимальное время хранения (часы)
        @history_retention = 48;     -- хранение истории репликации
    PRINT 'Distribution database created.';
END
ELSE
BEGIN
    PRINT 'Distribution database already exists.';
END
GO

-- =================================================================================
-- 3. Регистрация sql1 как Издателя (Publisher)
-- Используем общую папку /backup для хранения снимков (snapshots)
-- =================================================================================
-- Проверяем наличие издателя в системной таблице msdb
IF NOT EXISTS (SELECT * FROM msdb.dbo.MSdistpublishers WHERE name = N'sql1')
BEGIN
    EXEC sp_adddistpublisher 
        @publisher = N'sql1', 
        @distribution_db = N'distribution', 
        @working_directory = N'/var/opt/mssql/backup';
    PRINT 'Publisher [sql1] registered.';
END
ELSE
BEGIN
    PRINT 'Publisher [sql1] is already registered.';
END
GO

-- Финальная проверка статуса
EXEC sp_get_distributor;
GO
