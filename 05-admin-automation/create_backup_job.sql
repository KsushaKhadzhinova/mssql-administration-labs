USE [msdb];
GO

EXEC dbo.sp_add_job 
    @job_name = N'Daily_ProjectDB_Backup';

EXEC sp_add_jobstep 
    @job_name = N'Daily_ProjectDB_Backup', 
    @step_name = N'Backup_Step', 
    @subsystem = N'TSQL', 
    @command = N'BACKUP DATABASE [ProjectDB] TO DISK = N''/var/opt/mssql/backup/ProjectDB_Auto.bak'' WITH FORMAT, INIT;', 
    @retry_attempts = 5, 
    @retry_interval = 5;

EXEC dbo.sp_add_schedule 
    @schedule_name = N'DailySchedule', 
    @freq_type = 4, 
    @freq_interval = 1, 
    @active_start_time = 000000;

EXEC sp_attach_schedule 
   @job_name = N'Daily_ProjectDB_Backup', 
   @schedule_name = N'DailySchedule';

EXEC dbo.sp_add_jobserver 
    @job_name = N'Daily_ProjectDB_Backup';
GO

EXEC dbo.sp_add_job 
    @job_name = N'Hourly_Log_Backup';

EXEC sp_add_jobstep 
    @job_name = N'Hourly_Log_Backup', 
    @step_name = N'Log_Step', 
    @subsystem = N'TSQL', 
    @command = N'BACKUP LOG [ProjectDB] TO DISK = N''/var/opt/mssql/backup/ProjectDB_Auto_Log.trn'';', 
    @retry_attempts = 3, 
    @retry_interval = 5;

EXEC dbo.sp_add_schedule 
    @schedule_name = N'HourlySchedule', 
    @freq_type = 4, 
    @freq_interval = 1, 
    @freq_subday_type = 8, 
    @freq_subday_interval = 1;

EXEC sp_attach_schedule 
   @job_name = N'Hourly_Log_Backup', 
   @schedule_name = N'HourlySchedule';

EXEC dbo.sp_add_jobserver 
    @job_name = N'Hourly_Log_Backup';
GO
