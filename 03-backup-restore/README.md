# Lab 1.3: Disaster Recovery, Backup and Restore

This README.md provides a complete technical walkthrough for disaster recovery scenarios, from standard backups to physical file corruption and cross-server restoration.

---

## [1] Environment Setup

### Connect to the Repository

Open your Ubuntu (WSL2) terminal and navigate to the lab folder:

```bash
cd ~/mssql-administration-labs/03-backup-restore
```

### Prerequisites

- Infrastructure from `00-environment-setup` must be active (`docker ps` shows `sql1` and `sql2`)
- `Test` database from `02-database-management` must be created

---

## [2] Execution Steps

### Step 1: Create Initial Backups

Set `Test` database to FULL recovery model and create backups:

```bash
sqlcmd -S localhost,14331 -U sa -P 'YourStrongPassword123!' -C -i full_backups.sql
```

### Step 2: Simulate Physical Corruption

Stop container and use Linux `dd` utility to overwrite data file headers:

```bash
# Grant execution permissions
chmod +x simulate_corruption.sh

# Run the simulation
./simulate_corruption.sh
```

**Note:** After execution, `Test` database on `sql1` will be in `SUSPECT` or `RECOVERY_PENDING` state.

### Step 3: Recover the Primary Database

Restore from `test_full.bak` to fix corruption on `sql1`:

```bash
sqlcmd -S localhost,14331 -U sa -P 'YourStrongPassword123!' -C -i restore_after_corruption.sql
```

### Step 4: Cross-Instance Migration

Restore `Test` database onto `sql2` with new name and file paths:

```bash
sqlcmd -S localhost,14332 -U sa -P 'YourStrongPassword123!' -C -i restore_on_node2.sql
```

### Step 5: Database Snapshots & Revert

Create read-only snapshot, simulate logical error, and revert:

```bash
sqlcmd -S localhost,14331 -U sa -P 'YourStrongPassword123!' -C -i database_snapshots.sql
```

---

## [3] Verification & Results

| Task | Script | Expected Result |
|------|--------|-----------------|
| Backups | `full_backups.sql` | Files created in `./shared/backup` on host |
| Corruption | `simulate_corruption.sh` | SQL Server error logs show I/O corruption; DB offline |
| Recovery | `restore_after_corruption.sql` | `Test` database returns to `ONLINE` status |
| Relocation | `restore_on_node2.sql` | `Test_Restored` appears on `sql2` instance |
| Snapshot | `database_snapshots.sql` | Deleted records reappear after `RESTORE...FROM SNAPSHOT` |

---

## [TECHNICAL NOTES]

- **Storage Mapping:** `/var/opt/mssql/backup` inside container maps to `./shared/backup` on host
- **Linux Permissions:** `simulate_corruption.sh` requires `sudo` for Docker volume access
- **Recovery Models:** FULL recovery is required for log backup demonstration

---

**Lab 1.3 verification complete**
