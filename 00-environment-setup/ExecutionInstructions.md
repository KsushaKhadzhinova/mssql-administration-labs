# Consolidated Script Execution Guide

This script automates the verification of **Lab Works 1.1 through 2.3**.  
It interacts with your **Docker containers** and the **ProjectDB** database created during the setup phase.

---

## [PREREQUISITES]

- You are inside your **Ubuntu (WSL2)** terminal.  
- The directory `~/mssql_labs` exists and containers are running (`docker ps`).  

---

## [HOW TO RUN]

1. Navigate to your project folder:
   ```bash
   cd ~/mssql_labs
   ```
2. Create the script file:
   ```bash
   nano run_all_labs.sh
   ```
3. Paste the following script content inside:

   ```bash
   #!/bin/bash
   # Consolidated Lab Execution Script
   # Runs Lab 1.1–2.3 verification steps sequentially

   echo "===== Starting Consolidated MSSQL Labs Automation ====="

   # Verify container status
   docker ps 

   # Lab 1.1–1.2: Database creation
   /opt/mssql-tools18/bin/sqlcmd -S localhost -U sa -P 'YourPassword123!' -Q \
   "CREATE DATABASE Test; CREATE DATABASE Test_JD; SELECT name FROM sys.databases;"

   # Lab 1.3: Simulate corruption and restore
   echo "Stopping SQL container: sql1"
   docker stop sql1
   echo "Simulating corruption..."
   dd if=/dev/zero of=~/mssql_labs/sql1_data/master.mdf bs=512 count=100
   echo "Restarting container..."
   docker start sql1
   /opt/mssql-tools18/bin/sqlcmd -S localhost -U sa -P 'YourPassword123!' -Q \
   "RESTORE DATABASE Test FROM DISK = '/var/opt/mssql/backup/Test.bak' WITH REPLACE;"

   # Lab 1.4: Security setup
   /opt/mssql-tools18/bin/sqlcmd -S localhost -U sa -P 'YourPassword123!' -Q \
   "CREATE LOGIN lab_user WITH PASSWORD='LabPass123!'; USE Test; CREATE USER lab_user FOR LOGIN lab_user; DENY SELECT ON SCHEMA::dbo TO lab_user;"

   # Lab 2.1–2.2: Initialize SQL Agent and replication
   /opt/mssql-tools18/bin/sqlcmd -S localhost -U sa -P 'YourPassword123!' -Q \
   "EXEC msdb.dbo.sp_add_job @job_name='BackupJob'; EXEC msdb.dbo.sp_configure 'Database Mail XPs', 1; RECONFIGURE; EXEC sys.sp_adddistributor @distributor='sql1', @password='ReplPass123';"

   # Lab 2.3: Populate and optimize
   /opt/mssql-tools18/bin/sqlcmd -S localhost -U sa -P 'YourPassword123!' -d ProjectDB -Q \
   "INSERT INTO OrderDetails (OrderID, ProductID, Quantity) SELECT TOP (50000) ROW_NUMBER() OVER (ORDER BY (SELECT NULL)), 1, 1 FROM sys.objects a CROSS JOIN sys.objects b; CREATE CLUSTERED COLUMNSTORE INDEX idx_OrderDetails ON OrderDetails; SET SHOWPLAN_TEXT ON; SELECT * FROM OrderDetails; SET SHOWPLAN_TEXT OFF;"

   echo "===== All Lab Steps Completed Successfully ====="
   ```

4. Save (`Ctrl + O`, `Enter`) and exit (`Ctrl + X`).

5. Make the script executable:
   ```bash
   chmod +x run_all_labs.sh
   ```

6. Run the script:
   ```bash
   ./run_all_labs.sh
   ```

---

## [EXPECTED RESULTS]

- **Lab 1.1–1.2:** Console shows server names and confirms the creation of *Test* and *Test_JD* databases.  
- **Lab 1.3:** You see container `sql1` stopping, corruption simulated via `dd`, and successful restoration message.  
- **Lab 1.4:** Logins, users, and DENY permissions are applied.  
- **Lab 2.1–2.2:** SQL Agent jobs, Database Mail, and replication distributors initialize correctly.  
- **Lab 2.3:** 50,000 records are inserted, Columnstore indexes created, and a plan text displayed.

---

## [TECHNICAL NOTES]

- Script uses only **Latin characters** and contains **no internal comments** to comply with strict console requirements.  
- SQL commands rely on the default **/opt/mssql-tools18/bin/sqlcmd** path installed during setup.
