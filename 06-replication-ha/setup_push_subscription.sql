USE [ProjectDB];
GO

-- 1. Добавление подписки на издателе (sql1)
EXEC sp_addsubscription 
    @publication = N'Pub_ProjectDB_Data', 
    @subscriber = N'sql2', 
    @destination_db = N'ProjectDB_Replica', 
    @subscription_type = N'Push', 
    @sync_type = N'automatic', 
    @article = N'all', 
    @update_mode = N'read only', 
    @subscriber_type = 0;
GO

-- 2. Добавление агента рассылки
EXEC sp_addpushsubscription_agent 
    @publication = N'Pub_ProjectDB_Data', 
    @subscriber = N'sql2', 
    @subscriber_db = N'ProjectDB_Replica', 
    @subscriber_security_mode = 1; -- Использовать учетную запись агента
GO
