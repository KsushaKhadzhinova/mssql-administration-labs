# Lab 2.1: Administration Automation

This laboratory work focuses on automating routine administrative tasks and configuring proactive monitoring through Database Mail, SQL Server Agent Jobs, and Alerts for critical system errors (such as I/O failures).

---

## [1] How to Use This Folder

### Navigate to the Directory

```bash
cd ~/mssql-administration-labs/05-admin-automation
```

### Prerequisites

- **SQL Server Agent** must be enabled (`MSSQL_AGENT_ENABLED=True` in `docker-compose.yml`)
- `ProjectDB` database must exist on `sql1` instance

---

## [2] Automated Execution

Deploy all automation components with the master script:

```bash
# Grant execution permissions
chmod +x verify_lab_05.sh

# Run the complete automation setup
./verify_lab_05.sh
```

---

## [3] Manual Step-by-Step Execution

### Step 1: Configure Database Mail and Operators

Enable Mail XPs, create `AdminProfile`, set up `DBA_Admin` operator:

```bash
sqlcmd -S localhost,14331 -U sa -P 'YourStrongPassword123!' -C -i configure_agent_mail.sql
```

### Step 2: Create the Automated Backup Job

Create `Daily_ProjectDB_Backup` job with daily schedule:

```bash
sqlcmd -S localhost,14331 -U sa -P 'YourStrongPassword123!' -C -i create_backup_job.sql
```

### Step 3: Set up Severity and Error Alerts

Configure alert for Error 823 (critical disk I/O error):

```bash
sqlcmd -S localhost,14331 -U sa -P 'YourStrongPassword123!' -C -i setup_alerts.sql
```

---

## [4] Verification & Testing

### Run the Backup Job Now

```bash
sqlcmd -S localhost,14331 -U sa -P 'YourStrongPassword123!' -C -Q "EXEC msdb.dbo.sp_start_job @job_name = 'Daily_ProjectDB_Backup';"
```

### Check Job History

```bash
sqlcmd -S localhost,14331 -U sa -P 'YourStrongPassword123!' -C -Q "SELECT job_id, run_date, run_time, run_status FROM msdb.dbo.sysjobhistory WHERE step_id = 0;"
```

---

## [5] Expected Results Summary

| Task | Component | Expected Outcome |
|------|-----------|------------------|
| Mail Setup | `msdb.dbo.sysmail_profile` | `AdminProfile` created and active |
| Operator | `msdb.dbo.sysoperators` | `DBA_Admin` created with email |
| Jobs | `msdb.dbo.sysjobs` | `Daily_ProjectDB_Backup` in Agent job list |
| Alerts | `msdb.dbo.sysalerts` | Alert for Error 823 enabled and linked to Operator |

---

## [TECHNICAL NOTES]

### 5.1 SQL Server Agent in Docker

Agent activation relies on `MSSQL_AGENT_ENABLED=True` in `docker-compose.yml`.  
**Check Agent status:**
```sql
EXEC xp_servicecontrol 'QueryState', 'SQLServerAgent';
```

### 5.2 Database Mail Architecture

Three-level system in `msdb`:
- **Account:** SMTP server data (localhost for MailHog)
- **Profile:** Groups accounts (referenced by jobs/alerts)
- **Database Mail XPs:** Must be enabled via `sp_configure`

### 5.3 SQL Agent Jobs & Paths

**Backup Path:** `/var/opt/mssql/backup/ProjectDB_Auto.bak` (container) → `./shared/backup` (host)  
**Job Ownership:** Defaults to `sa` account

### 5.4 Alerts & Severity Levels

- **Error 823:** Critical disk I/O error
- **Severity 19-25:** Process-stopping or database corruption errors

### 5.5 Troubleshooting

**Mail logs:**
```sql
SELECT * FROM msdb.dbo.sysmail_event_log ORDER BY log_date DESC;
```

**Mail queue:**
```sql
SELECT * FROM msdb.dbo.sysmail_mailitems;
```

**Failed jobs:**
```sql
SELECT j.name, h.run_date, h.message 
FROM msdb.dbo.sysjobhistory h 
JOIN msdb.dbo.sysjobs j ON h.job_id = j.job_id 
WHERE h.run_status = 0;
```

### 5.6 Permissions

Requires `sysadmin` role. `Manager`/`Employee` roles from Lab 1.4 cannot modify mail or job settings.

---

**Lab 2.1 verification complete**
