USE [master];
GO

-- 1. Удаление сессии, если она уже существует
IF EXISTS (SELECT * FROM sys.server_event_sessions WHERE name = 'TrackLongQueries')
    DROP EVENT SESSION [TrackLongQueries] ON SERVER;
GO

-- 2. Создание сессии для отслеживания запросов дольше 1 секунды (1000000 микросекунд)
CREATE EVENT SESSION [TrackLongQueries] ON SERVER 
ADD EVENT sqlserver.sql_batch_completed(
    ACTION(sqlserver.sql_text, sqlserver.database_name)
    WHERE ([duration] >= 1000000))
ADD TARGET package0.event_file(SET filename=N'/var/opt/mssql/log/long_queries.xel');
GO

-- 3. Запуск сессии
ALTER EVENT SESSION [TrackLongQueries] ON SERVER STATE = START;
GO

-- Проверка статуса сессий
SELECT name, is_running FROM sys.dm_xe_sessions;
GO
