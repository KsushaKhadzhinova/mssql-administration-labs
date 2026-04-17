# Lab 1.3: Disaster Recovery, Backup and Restore

This lab demonstrates backup creation, corruption simulation, restore operations, snapshots, and transaction log recovery.

---

## STEP 1: Backup Master Database

Create backup of system `master` database:

```bash
sqlcmd -S localhost,14331 -U sa -P 'YourStrongPassword123!' -C -Q "BACKUP DATABASE master TO DISK = '/var/opt/mssql/backup/master.bak'"
```

**Expected Result:** `master.bak` created successfully.

---

## STEP 2: Backup Test Database

Create full backup of `Test` database:

```bash
sqlcmd -S localhost,14331 -U sa -P 'YourStrongPassword123!' -C -Q "BACKUP DATABASE Test TO DISK = '/var/opt/mssql/backup/Test.bak'"
```

**Expected Result:** `Test.bak` created successfully.

---

## STEP 3: Corrupt Database File

Simulate hardware failure:

```bash
sudo docker stop sql1
sudo dd if=/dev/zero of=./volumes/sql1/data/testdata_a.mdf bs=1 count=1024 conv=notrunc
sudo docker start sql1
sleep 10
sqlcmd -S localhost,14331 -U sa -P 'YourStrongPassword123!' -C -Q "SELECT * FROM Test.sys.tables"
```

**Expected Result:** Connection/query fails (corrupted file header).

---

## STEP 4: Restore Test Database

Recover from backup:

```bash
sqlcmd -S localhost,14331 -U sa -P 'YourStrongPassword123!' -C -Q "
USE master;
RESTORE DATABASE Test FROM DISK = '/var/opt/mssql/backup/Test.bak' WITH REPLACE;
"
```

**Expected Result:** `Test` restored successfully.

---

## STEP 5: Cross-Instance Restore

Restore backup from `sql1` to `sql2`:

```bash
sqlcmd -S localhost,14332 -U sa -P 'YourStrongPassword123!' -C -Q "
RESTORE DATABASE Test_Restored 
FROM DISK = '/var/opt/mssql/backup/Test.bak' 
WITH MOVE 'testdata_a' TO '/var/opt/mssql/data/test_node2.mdf',
MOVE 'testdata_b' TO '/var/opt/mssql/data/test_node2.ndf',
MOVE 'Test_log' TO '/var/opt/mssql/data/test_node2.ldf',
REPLACE;
"
```

**Expected Result:** `Test_Restored` created on `sql2`.

---

## STEP 6: Mirroring Example

**Deprecated/not supported on Linux.** Syntax example only:

```sql
CREATE ENDPOINT [Mirroring] STATE=STARTED AS TCP (LISTENER_PORT = 5022) 
FOR DATABASE_MIRRORING (ROLE = PARTNER);
ALTER DATABASE Test SET PARTNER = 'TCP://mirror_server_address:5022';
```

---

## STEP 7: Create Database Snapshot

Create read-only snapshot:

```bash
sqlcmd -S localhost,14331 -U sa -P 'YourStrongPassword123!' -C -Q "
CREATE DATABASE Test_Snapshot ON 
(NAME = testdata_a, FILENAME = '/var/opt/mssql/data/Test_snap.ss')
AS SNAPSHOT OF Test;
"
```

**Expected Result:** `Test_Snapshot` created.

---

## STEP 8: Transaction Log Recovery

Execute full scenario via script:

```bash
sqlcmd -S localhost,14331 -U sa -P 'YourStrongPassword123!' -C -i transaction_log_recovery.sql
```

**Expected Result:** Table restored with transaction log recovery.

---

## STEP 9: Real Estate Backup Strategy

**Recommended schedule:**
- Full: Sunday 00:00
- Differential: Mon-Fri 23:00  
- Transaction Log: 09:00-18:00 every 30 minutes

**Wednesday failure recovery:**
1. Sunday Full (`NORECOVERY`)
2. Tuesday Differential (`NORECOVERY`)  
3. Transaction logs after Tue 23:00 (`RECOVERY`)
