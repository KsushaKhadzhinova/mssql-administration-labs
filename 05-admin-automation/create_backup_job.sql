USE [msdb];
GO

-- 1. Add the Job
EXEC dbo.sp_add_job
    @job_name = N'Daily_ProjectDB_Backup';

-- 2. Add a Job Step (The actual Backup command)
EXEC sp_add_jobstep
    @job_name = N'Daily_ProjectDB_Backup',
    @step_name = N'Backup_Step',
    @subsystem = N'TSQL',
    @command = N'BACKUP DATABASE [ProjectDB] TO DISK = N''/var/opt/mssql/backup/ProjectDB_Auto.bak'' WITH FORMAT, INIT;',
    @retry_attempts = 5,
    @retry_interval = 5;

-- 3. Add a Schedule (Daily at 00:00)
EXEC dbo.sp_add_schedule
    @schedule_name = N'DailySchedule',
    @freq_type = 4, -- Daily
    @freq_interval = 1,
    @active_start_time = 000000;

-- 4. Attach Schedule to Job
EXEC sp_attach_schedule
   @job_name = N'Daily_ProjectDB_Backup',
   @schedule_name = N'DailySchedule';

-- 5. Assign Job to Server
EXEC dbo.sp_add_jobserver
    @job_name = N'Daily_ProjectDB_Backup';
GO
