# Lab 1.3: Disaster Recovery, Backup and Restore

This README.md provides a complete technical walkthrough for disaster recovery scenarios, from standard backups to physical file corruption and cross-server restoration.

---

## 1. Environment Setup

### Connect to the Repository

```bash
cd ~/mssql-administration-labs/03-backup-restore
```

### Prerequisites

- Infrastructure from `00-environment-setup` active (`docker ps` shows `sql1` and `sql2`)
- `Test` database from `02-database-management` created

---

## 2. Execution Steps

### Step 1: Create Initial Backups

Set `Test` database to FULL recovery model:

```bash
sqlcmd -S localhost,14331 -U sa -P 'YourStrongPassword123!' -C -i full_backups.sql
```

### Step 2: Simulate Physical Corruption

Overwrite data file headers:

```bash
chmod +x simulate_corruption.sh
./simulate_corruption.sh
```

**Note:** `Test` database on `sql1` enters `SUSPECT` or `RECOVERY_PENDING` state.

### Step 3: Recover the Primary Database

Restore from `test_full.bak`:

```bash
sqlcmd -S localhost,14331 -U sa -P 'YourStrongPassword123!' -C -i restore_after_corruption.sql
```

### Step 4: Cross-Instance Migration

Restore to `sql2` with new paths:

```bash
sqlcmd -S localhost,14332 -U sa -P 'YourStrongPassword123!' -C -i restore_on_node2.sql
```

### Step 5: Database Snapshots & Revert

Create snapshot and test revert:

```bash
sqlcmd -S localhost,14331 -U sa -P 'YourStrongPassword123!' -C -i database_snapshots.sql
```

### Step 6: Transaction Log Recovery

Full backup → log backup → data loss → point-in-time recovery:

```bash
sqlcmd -S localhost,14331 -U sa -P 'YourStrongPassword123!' -C -i transaction_log_recovery.sql
```

---

## 3. Verification & Results

| Task | Script | Expected Result |
|------|--------|-----------------|
| Backups | `full_backups.sql` | Files in `./shared/backup` on host |
| Corruption | `simulate_corruption.sh` | I/O corruption in error logs; DB offline |
| Recovery | `restore_after_corruption.sql` | `Test` returns to `ONLINE` |
| Relocation | `restore_on_node2.sql` | `Test_Restored` on `sql2` |
| Snapshot | `database_snapshots.sql` | Records restored via `RESTORE...FROM SNAPSHOT` |
| Log Recovery | `transaction_log_recovery.sql` | `RecoveryTest` table restored |

---

## TECHNICAL NOTES

- **Storage Mapping:** `/var/opt/mssql/backup` (container) → `./shared/backup` (host)
- **Linux Permissions:** `simulate_corruption.sh` requires `sudo` for volume access
- **Recovery Models:** FULL recovery required for transaction log chain
