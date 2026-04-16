-- Выполняется на sql3 (localhost,14333)
USE [master];
GO

-- 1. Подготовка базы данных к приему логов (восстановление из полного бэкапа с NORECOVERY)
RESTORE DATABASE [ProjectDB_LS] 
FROM DISK = N'/var/opt/mssql/backup/ProjectDB_Auto.bak' 
WITH MOVE 'ProjectDB' TO '/var/opt/mssql/data/ProjectDB_LS.mdf', 
     MOVE 'ProjectDB_log' TO '/var/opt/mssql/data/ProjectDB_LS.ldf', 
     NORECOVERY, REPLACE;
GO

-- 2. Теперь база готова принимать бэкапы логов для поддержания актуальности.
-- В реальности далее настраиваются Jobs на sql1 и sql3.
