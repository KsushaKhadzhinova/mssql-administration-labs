# Lab 2.1: Administration Automation

This lab configures SQL Server Agent, Database Mail, alerts, jobs, and remote job execution.

---

## [STEP 1] Verify SQL Server Agent

Check whether SQL Server Agent is running on both instances:

```bash
sqlcmd -S localhost,14331 -U sa -P 'YourStrongPassword123!' -C -Q "SELECT dss.status_desc FROM sys.dm_server_services dss WHERE dss.servicename LIKE 'SQL Server Agent%';"
sqlcmd -S localhost,14332 -U sa -P 'YourStrongPassword123!' -C -Q "SELECT dss.status_desc FROM sys.dm_server_services dss WHERE dss.servicename LIKE 'SQL Server Agent%';"
```

**Expected Result:**  
Both instances return the Agent service status.

---

## [STEP 2] Enable Database Mail and Configure Account

Set up Database Mail for alerts using the MailHog container on port `1025`:

```bash
sqlcmd -S localhost,14331 -U sa -P 'YourStrongPassword123!' -C -Q "
EXEC sp_configure 'show advanced options', 1;
RECONFIGURE;
EXEC sp_configure 'Database Mail XPs', 1;
RECONFIGURE;
GO
EXEC msdb.dbo.sysmail_add_account_sp
    @account_name = 'LabAccount',
    @email_address = 'sqladmin@example.com',
    @display_name = 'SQL Automation',
    @mailserver_name = 'mailhog',
    @port = 1025;
EXEC msdb.dbo.sysmail_add_profile_sp
    @profile_name = 'LabProfile';
EXEC msdb.dbo.sysmail_add_profileaccount_sp
    @profile_name = 'LabProfile',
    @account_name = 'LabAccount',
    @sequence_number = 1;
"
```

**Expected Result:**  
Database Mail account and profile are created successfully.

---

## [STEP 3] Create Operator for Alerts

Create an administrator contact for notifications:

```bash
sqlcmd -S localhost,14331 -U sa -P 'YourStrongPassword123!' -C -Q "
EXEC msdb.dbo.sp_add_operator 
    @name = 'DBA_Admin', 
    @enabled = 1, 
    @email_address = 'admin@example.com';
"
```

**Expected Result:**  
Operator `DBA_Admin` is created and enabled.

---

## [STEP 4] Create Backup Jobs and Schedules

Create two jobs: one for full backup and one for transaction log backup:

```bash
sqlcmd -S localhost,14331 -U sa -P 'YourStrongPassword123!' -C -Q "
EXEC msdb.dbo.sp_add_job @job_name = 'Daily_Full_Backup';
EXEC msdb.dbo.sp_add_jobstep @job_name = 'Daily_Full_Backup', @step_name = 'Backup_Step', 
    @command = 'BACKUP DATABASE Test TO DISK = ''/var/opt/mssql/backup/Test_Auto_Full.bak'' WITH FORMAT';
EXEC msdb.dbo.sp_add_schedule @schedule_name = 'Daily_Schedule', @freq_type = 4, @freq_interval = 1, @active_start_time = 000000;
EXEC msdb.dbo.sp_attach_schedule @job_name = 'Daily_Full_Backup', @schedule_name = 'Daily_Schedule';
EXEC msdb.dbo.sp_add_jobserver @job_name = 'Daily_Full_Backup';

EXEC msdb.dbo.sp_add_job @job_name = 'Hourly_Log_Backup';
EXEC msdb.dbo.sp_add_jobstep @job_name = 'Hourly_Log_Backup', @step_name = 'Log_Step', 
    @command = 'BACKUP LOG Test TO DISK = ''/var/opt/mssql/backup/Test_Auto_Log.trn''';
EXEC msdb.dbo.sp_add_schedule @schedule_name = 'Hourly_Schedule', @freq_type = 4, @freq_interval = 1, @freq_subday_type = 8, @freq_subday_interval = 1;
EXEC msdb.dbo.sp_attach_schedule @job_name = 'Hourly_Log_Backup', @schedule_name = 'Hourly_Schedule';
EXEC msdb.dbo.sp_add_jobserver @job_name = 'Hourly_Log_Backup';
"
```

**Expected Result:**  
Both jobs and schedules are created and attached to the SQL Server Agent.

---

## [STEP 5] Create Alert with Job Execution

Set up an alert for Error 823 that triggers the full backup job and sends email:

```bash
sqlcmd -S localhost,14331 -U sa -P 'YourStrongPassword123!' -C -Q "
EXEC msdb.dbo.sp_add_alert @name = 'Critical_IO_Error', @message_id = 823, @severity = 0, 
    @notification_message = 'IO Error Detected!', @job_name = 'Daily_Full_Backup';
EXEC msdb.dbo.sp_add_notification @alert_name = 'Critical_IO_Error', @operator_name = 'DBA_Admin', @notification_method = 1;
"
```

**Expected Result:**  
Alert `Critical_IO_Error` is created and linked to the `Daily_Full_Backup` job.

---

## [STEP 6] Multi-Instance Job Execution Example

Run a command on `sql2` to simulate remote task management:

```bash
sqlcmd -S localhost,14332 -U sa -P 'YourStrongPassword123!' -C -Q "
EXEC msdb.dbo.sp_add_job @job_name = 'Remote_Check';
EXEC msdb.dbo.sp_add_jobstep @job_name = 'Remote_Check', @step_name = 'Check_Step', @command = 'DBCC CHECKDB(Test_JD)';
EXEC msdb.dbo.sp_add_jobserver @job_name = 'Remote_Check';
EXEC msdb.dbo.sp_start_job @job_name = 'Remote_Check';
"
```

**Expected Result:**  
Job `Remote_Check` is created, started, and runs successfully on `sql2`.

---

## [STEP 7] Verify Job History

Check the execution status of the jobs:

```bash
sqlcmd -S localhost,14331 -U sa -P 'YourStrongPassword123!' -C -Q "
SELECT j.name, h.run_date, h.run_time, h.run_status 
FROM msdb.dbo.sysjobhistory h 
JOIN msdb.dbo.sysjobs j ON h.job_id = j.job_id 
ORDER BY h.run_date DESC, h.run_time DESC;
"
```

**Expected Result:**  
A table showing `Daily_Full_Backup` or `Remote_Check` with `run_status = 1` for success.

---

**End of Lab 2.1**
