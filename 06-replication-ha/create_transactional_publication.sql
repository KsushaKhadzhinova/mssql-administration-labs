USE [ProjectDB];
GO

-- 1. Включение репликации для базы данных
EXEC sp_replicationdboption 
    @dbname = N'ProjectDB', 
    @optname = N'publish', 
    @value = N'true';
GO

-- 2. Создание публикации транзакций
EXEC sp_addpublication 
    @publication = N'Pub_ProjectDB_Data', 
    @description = N'Transactional publication of ProjectDB tables', 
    @sync_method = N'concurrent', 
    @retention = 0, 
    @allow_push = N'true', 
    @repl_freq = N'continuous', 
    @status = N'active', 
    @independent_agent = N'true';
GO

-- 3. Добавление статей (таблиц) в публикацию
EXEC sp_addarticle 
    @publication = N'Pub_ProjectDB_Data', 
    @article = N'Products', 
    @source_owner = N'dbo', 
    @source_object = N'Products', 
    @type = N'logbased', 
    @destination_table = N'Products', 
    @destination_owner = N'dbo';

EXEC sp_addarticle 
    @publication = N'Pub_ProjectDB_Data', 
    @article = N'Categories', 
    @source_owner = N'dbo', 
    @source_object = N'Categories', 
    @type = N'logbased';
GO

-- 4. Создание снимка (Snapshot)
EXEC sp_addpublication_snapshot 
    @publication = N'Pub_ProjectDB_Data', 
    @frequency_type = 1;
GO
