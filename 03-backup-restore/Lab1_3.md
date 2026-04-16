# Lab 1.3: Disaster Recovery, Backup and Restore

This lab demonstrates backup creation, corruption simulation, restore operations, snapshots, and transaction log recovery.

---

## [STEP 1] Backup Master Database

Create a backup of the system `master` database in the shared backup directory:

```bash
sqlcmd -S localhost,14331 -U sa -P 'YourStrongPassword123!' -C -Q "BACKUP DATABASE master TO DISK = '/var/opt/mssql/backup/master.bak'"
```

**Expected Result:**  
Backup file `master.bak` is created successfully.

---

## [STEP 2] Backup Test Database

Create a full backup of the `Test` database from Lab 1.2:

```bash
sqlcmd -S localhost,14331 -U sa -P 'YourStrongPassword123!' -C -Q "BACKUP DATABASE Test TO DISK = '/var/opt/mssql/backup/Test.bak'"
```

**Expected Result:**  
Backup file `Test.bak` is created successfully.

---

## [STEP 3] Corrupt Database File

Stop the container, corrupt the physical database file using Linux tools, and attempt to reconnect:

```bash
sudo docker stop sql1
sudo dd if=/dev/zero of=./volumes/sql1/data/testdata_a.mdf bs=1 count=1024 conv=notrunc
sudo docker start sql1
sleep 10
sqlcmd -S localhost,14331 -U sa -P 'YourStrongPassword123!' -C -Q "SELECT * FROM Test.sys.tables"
```

**Expected Result:**  
Connection or query fails because the file header is corrupted.

---

## [STEP 4] Restore Test Database

Restore the `Test` database from the backup created earlier:

```bash
sqlcmd -S localhost,14331 -U sa -P 'YourStrongPassword123!' -C -Q "
USE master;
RESTORE DATABASE Test FROM DISK = '/var/opt/mssql/backup/Test.bak' WITH REPLACE;
"
```

**Expected Result:**  
Database `Test` is restored successfully.

---

## [STEP 5] Cross-Instance Restore

Restore the backup from `sql1` onto the `sql2` instance:

```bash
sqlcmd -S localhost,14332 -U sa -P 'YourStrongPassword123!' -C -Q "
RESTORE DATABASE Test_From_SQL1 
FROM DISK = '/var/opt/mssql/backup/Test.bak' 
WITH MOVE 'testdata_a' TO '/var/opt/mssql/data/test_from_sql1.mdf',
MOVE 'testdata_b' TO '/var/opt/mssql/data/test_from_sql1_b.ndf',
MOVE 'Test_log' TO '/var/opt/mssql/data/test_from_sql1.ldf',
REPLACE;
"
```

**Expected Result:**  
Backup is restored on `sql2` under the new database name `Test_From_SQL1`.

---

## [STEP 6] Mirroring Example

Mirroring is deprecated and not supported on Linux. The following is a syntax example only:

```sql
-- Run on Principal
CREATE ENDPOINT [Mirroring] STATE=STARTED AS TCP (LISTENER_PORT = 5022) FOR DATABASE_MIRRORING (ROLE = PARTNER);
ALTER DATABASE Test SET PARTNER = 'TCP://mirror_server_address:5022';
```

**Expected Result:**  
Syntax example only; not intended for execution in this Linux setup.

---

## [STEP 7] Create Database Snapshot

Create a read-only snapshot of the `Test` database:

```bash
sqlcmd -S localhost,14331 -U sa -P 'YourStrongPassword123!' -C -Q "
CREATE DATABASE Test_Snapshot ON 
(NAME = testdata_a, FILENAME = '/var/opt/mssql/data/Test_snap.ss')
AS SNAPSHOT OF Test;
"
```

**Expected Result:**  
Snapshot `Test_Snapshot` is created successfully.

---

## [STEP 8] Transaction Log Recovery Scenario

Perform a full backup, log backup, simulate data loss, and restore with recovery:

```bash
sqlcmd -S localhost,14331 -U sa -P 'YourStrongPassword123!' -C -Q "
ALTER DATABASE Test SET RECOVERY FULL;
BACKUP DATABASE Test TO DISK = '/var/opt/mssql/backup/Test_Full.bak';
USE Test;
CREATE TABLE RecoveryTable (ID INT);
INSERT INTO RecoveryTable VALUES (1);
BACKUP LOG Test TO DISK = '/var/opt/mssql/backup/Test_Log1.bak';
DROP TABLE RecoveryTable;
"
```

Restore the database and apply the transaction log:

```bash
sqlcmd -S localhost,14331 -U sa -P 'YourStrongPassword123!' -C -Q "
USE master;
RESTORE DATABASE Test FROM DISK = '/var/opt/mssql/backup/Test_Full.bak' WITH NORECOVERY, REPLACE;
RESTORE LOG Test FROM DISK = '/var/opt/mssql/backup/Test_Log1.bak' WITH RECOVERY;
USE Test;
SELECT * FROM RecoveryTable;
"
```

**Expected Result:**  
`RecoveryTable` is restored and query returns the inserted row.

---

## [STEP 9] Real Estate Backup Strategy

Recommended strategy for a real estate database system:

- Full backup: every Sunday at 00:00.
- Differential backup: every night from Monday to Friday at 23:00.
- Transaction log backup: every 30 minutes during working hours from 09:00 to 18:00.

**Why this is optimal:**  
Differential backups reduce restore time compared to relying only on logs.  
30-minute log backups minimize data loss and improve recovery point objective.  
For a Wednesday morning failure, restore the Sunday full backup with `NORECOVERY`, then the Tuesday differential backup with `NORECOVERY`, and finally all transaction log backups created after Tuesday 23:00 up to the failure time with `RECOVERY`.

---

**End of Lab 1.3**
