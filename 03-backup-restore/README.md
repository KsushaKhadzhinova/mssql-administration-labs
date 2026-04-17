# Lab 1.3: Disaster Recovery, Backup and Restore

This README.md provides a complete technical walkthrough for disaster recovery scenarios, from standard backups to physical file corruption and cross-server restoration.

---

## 1. Environment Setup

### Connect to the Repository

```bash
cd ~/mssql-administration-labs/03-backup-restore
```

### Prerequisites

- Infrastructure from `00-environment-setup` active (`sql1` and `sql2` running)
- `Test` database from `02-database-management` created

---

## 2. Execution Steps

### Step 1: Create Initial Backups

```bash
sqlcmd -S localhost,14331 -U sa -P 'YourStrongPassword123!' -C -i full_backups.sql
```

### Step 2: Simulate Physical Corruption

```bash
chmod +x simulate_corruption.sh
./simulate_corruption.sh
```

### Step 3: Recover the Primary Database

```bash
sqlcmd -S localhost,14331 -U sa -P 'YourStrongPassword123!' -C -i restore_after_corruption.sql
```

### Step 4: Cross-Instance Migration

```bash
sqlcmd -S localhost,14332 -U sa -P 'YourStrongPassword123!' -C -i restore_on_node2.sql
```

### Step 5: Database Snapshots & Revert

```bash
sqlcmd -S localhost,14331 -U sa -P 'YourStrongPassword123!' -C -i database_snapshots.sql
```

### Step 6: Transaction Log Recovery

```bash
sqlcmd -S localhost,14331 -U sa -P 'YourStrongPassword123!' -C -i transaction_log_recovery.sql
```

---

## 3. Verification & Results

| Task | Script | Expected Result |
|------|--------|-----------------|
| Backups | `full_backups.sql` | Recovery model `FULL`; files in shared folder |
| Corruption | `simulate_corruption.sh` | Database `SUSPECT`/`RECOVERY_PENDING` |
| Recovery | `restore_after_corruption.sql` | `Test` database `ONLINE` |
| Relocation | `restore_on_node2.sql` | `Test_Restored` on `sql2` |
| Snapshot | `database_snapshots.sql` | Data reverted via snapshot |
| Log Recovery | `transaction_log_recovery.sql` | `RecoveryTest` table restored |

---

## TECHNICAL NOTES

- **Storage Mapping:** `/var/opt/mssql/backup` (container) → `./shared/backup` (host)
- **Permissions:** `simulate_corruption.sh` requires `sudo`
- **Recovery Models:** FULL recovery mandatory for transaction log backups

---

**Lab 1.3 complete**
