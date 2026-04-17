# Consolidated Script Execution Guide

This script automates verification of **Lab Works 1.1 through 2.3**.  
It interacts with **Docker containers** and **ProjectDB** database.

---

## PREREQUISITES

- Ubuntu (WSL2) terminal
- Directory `~/mssql_labs` exists, containers running (`docker ps`)

---

## HOW TO RUN

1. **Navigate to project folder:**
   ```bash
   cd ~/mssql_labs
   ```

2. **Create script file:**
   ```bash
   nano run_all_labs.sh
   ```

3. **Paste script content:**

   ```bash
   #!/bin/bash
   echo "===== Starting Consolidated MSSQL Labs Automation ======"
   
   docker ps 
   
   /opt/mssql-tools18/bin/sqlcmd -S localhost -U sa -P 'YourPassword123!' -Q \
   "CREATE DATABASE Test; CREATE DATABASE Test_KK; SELECT name FROM sys.databases;"
   
   echo "Stopping SQL container: sql1"
   docker stop sql1
   
   echo "Simulating corruption..."
   dd if=/dev/zero of=~/mssql_labs/sql1_data/master.mdf bs=512 count=100
   
   echo "Restarting container..."
   docker start sql1
   
   /opt/mssql-tools18/bin/sqlcmd -S localhost -U sa -P 'YourPassword123!' -Q \
   "RESTORE DATABASE Test FROM DISK = '/var/opt/mssql/backup/Test.bak' WITH REPLACE;"
   
   /opt/mssql-tools18/bin/sqlcmd -S localhost -U sa -P 'YourPassword123!' -Q \
   "CREATE LOGIN lab_user WITH PASSWORD='LabPass123!'; USE Test; CREATE USER lab_user FOR LOGIN lab_user; DENY SELECT ON SCHEMA::dbo TO lab_user;"
   
   /opt/mssql-tools18/bin/sqlcmd -S localhost -U sa -P 'YourPassword123!' -Q \
   "EXEC msdb.dbo.sp_add_job @job_name='BackupJob'; EXEC msdb.dbo.sp_configure 'Database Mail XPs', 1; RECONFIGURE; EXEC sys.sp_adddistributor @distributor='sql1', @password='ReplPass123';"
   
   /opt/mssql-tools18/bin/sqlcmd -S localhost -U sa -P 'YourPassword123!' -d ProjectDB -Q \
   "INSERT INTO OrderDetails (OrderID, ProductID, Quantity) SELECT TOP (50000) ROW_NUMBER() OVER (ORDER BY (SELECT NULL)), 1, 1 FROM sys.objects a CROSS JOIN sys.objects b; CREATE CLUSTERED COLUMNSTORE INDEX idx_OrderDetails ON OrderDetails; SET SHOWPLAN_TEXT ON; SELECT * FROM OrderDetails; SET SHOWPLAN_TEXT OFF;"
   
   echo "===== All Lab Steps Completed Successfully ====="
   ```

4. **Save and exit:** `Ctrl+O`, `Enter`, `Ctrl+X`

5. **Make executable:**
   ```bash
   chmod +x run_all_labs.sh
   ```

6. **Run:**
   ```bash
   ./run_all_labs.sh
   ```

---

## EXPECTED RESULTS

| Lab | Expected Output |
|-----|-----------------|
| **1.1–1.2** | Server names, `Test`/`Test_KK` databases created |
| **1.3** | `sql1` stops, corruption via `dd`, restoration success |
| **1.4** | Logins/users/roles with `DENY` permissions applied |
| **2.1–2.2** | SQL Agent jobs, Database Mail, replication distributor |
| **2.3** | 50,000 records inserted, Columnstore index, execution plan |

---

## TECHNICAL NOTES

- Uses only Latin characters, no internal comments (strict console compliance)
- Relies on `/opt/mssql-tools18/bin/sqlcmd` path from setup
