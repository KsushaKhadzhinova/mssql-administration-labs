# Lab 2.2: Replication and High Availability (HA)

This laboratory work ensures data availability and synchronization across multiple SQL Server instances through Transactional Replication (sql1 → sql2) and manual Log Shipping (sql3 as DR node).

---

## [1] How to Use This Folder

### Connect to the Repository

```bash
cd ~/mssql-administration-labs/06-replication-ha
```

### Prerequisites

- Containers: `sql1`, `sql2`, `sql3` must be running (`docker ps`)
- Database: `ProjectDB` must be initialized on `sql1`
- SQL Agent: Must be running on all nodes
- Network: Containers must resolve each other by name (Docker network)

---

## [2] Automated Execution

Deploy complete replication topology with master script:

```bash
# Grant execution permissions
chmod +x verify_lab_06.sh

# Run the complete HA/Replication setup
./verify_lab_06.sh
```

---

## [3] Manual Step-by-Step Execution

### Step 1: Initialize the Distributor (SQL1)

Promote `sql1` to Distributor role:

```bash
sqlcmd -S localhost,14331 -U sa -P 'YourStrongPassword123!' -C -i setup_replication_distributor.sql
```

### Step 2: Create Transactional Publication (SQL1)

Publish `Products` and `Categories` tables:

```bash
sqlcmd -S localhost,14331 -U sa -P 'YourStrongPassword123!' -C -i create_transactional_publication.sql
```

### Step 3: Configure Push Subscription (SQL1 → SQL2)

Push changes to `ProjectDB_Replica` on `sql2`:

```bash
sqlcmd -S localhost,14331 -U sa -P 'YourStrongPassword123!' -C -i setup_push_subscription.sql
```

### Step 4: Setup Log Shipping Standby (SQL3)

Initialize `sql3` as warm standby with `NORECOVERY`:

```bash
sqlcmd -S localhost,14333 -U sa -P 'YourStrongPassword123!' -C -i configure_log_shipping.sql
```

---

## [4] Verification & Testing

### Verify Replication

**Insert test data on sql1:**
```bash
sqlcmd -S localhost,14331 -U sa -P 'YourStrongPassword123!' -C -Q "INSERT INTO ProjectDB.dbo.Categories (CategoryName) VALUES ('ReplicationTest');"
```

**Check sql2 (should appear within seconds):**
```bash
sqlcmd -S localhost,14332 -U sa -P 'YourStrongPassword123!' -C -Q "SELECT * FROM ProjectDB_Replica.dbo.Categories WHERE CategoryName = 'ReplicationTest';"
```

### Verify HA Standby

**Check sql3 database state:**
```bash
sqlcmd -S localhost,14333 -U sa -P 'YourStrongPassword123!' -C -Q "SELECT name, state_desc FROM sys.databases WHERE name = 'ProjectDB_LS';"
```

**Expected Result:** `RESTORING` state (ready for log updates)

---

## [5] Technical Notes

### 5.1 Shared Snapshot Folder

**Docker Solution:** Shared `/var/opt/mssql/backup` volume across all containers replaces Windows network shares.

### 5.2 Transactional vs. Log Shipping

| Feature | Transactional Replication | Log Shipping |
|---------|---------------------------|--------------|
| Scope | Specific tables | Entire database |
| Latency | Near real-time | Backup frequency |
| Subscriber | Readable | Typically `NORECOVERY` |

### 5.3 Common Docker Issues

**Agent Permissions:** SQL Agent needs read/write access to `/var/opt/mssql/backup`  
**Container DNS:** Verify `sql1` can resolve `sql2`  
**Distribution History:**
```sql
SELECT * FROM distribution.dbo.MSrepl_errors ORDER BY time DESC;
```

### 5.4 Security Context

All agents run as `sa` for lab simplicity. Production requires dedicated low-privilege accounts.

---

**Lab 2.2 verification complete**
