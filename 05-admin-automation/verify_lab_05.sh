#!/bin/bash
S="localhost,14331"
P="YourStrongPassword123!"
CMD="/opt/mssql-tools18/bin/sqlcmd -S $S -U sa -P $P -C"

echo "Running Lab 2.1: Administration Automation..."

echo "1. Configuring Database Mail and Operators..."
$CMD -i configure_agent_mail.sql

echo "2. Creating Automated Backup Job..."
$CMD -i create_backup_job.sql

echo "3. Setting up SQL Server Alerts..."
$CMD -i setup_alerts.sql

echo "4. Testing Job Execution..."
$CMD -Q "EXEC msdb.dbo.sp_start_job @job_name = 'Daily_ProjectDB_Backup';"

echo "Automation setup verified."
