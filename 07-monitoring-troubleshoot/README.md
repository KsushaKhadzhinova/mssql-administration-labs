# Lab 2.3: Monitoring and Troubleshooting

This laboratory work completes the lab cycle, focusing on deep diagnostics, system resource monitoring, and modern optimization techniques for large datasets using DMVs, Extended Events, and Columnstore indexes.

---

## [1] Connection and Preparation

### Navigate to Repository Folder

```bash
cd ~/mssql-administration-labs/07-monitoring-troubleshoot
```

### Prerequisites

- Container `sql1` (port `14331`) must be running
- `ProjectDB` database must be created and writable

---

## [2] Automated Execution

Run the master script for complete diagnostics, monitoring session creation, and performance testing:

```bash
# Grant execution permissions
chmod +x verify_lab_07.sh

# Run orchestrator
./verify_lab_07.sh
```

---

## [3] Step-by-Step Manual Execution

### Step 1: Collect Statistics via DMV

View active queries, wait stats, and index fragmentation:

```bash
sqlcmd -S localhost,14331 -U sa -P 'YourStrongPassword123!' -C -i dmv_monitoring.sql
```

### Step 2: Setup Extended Events (XE)

Create `TrackLongQueries` session for queries >1 second:

```bash
sqlcmd -S localhost,14331 -U sa -P 'YourStrongPassword123!' -C -i extended_events_setup.sql
```

### Step 3: Optimization and Columnstore

Populate `OrderDetails` with 50,000 rows, compare execution plans before/after Columnstore:

```bash
sqlcmd -S localhost,14331 -U sa -P 'YourStrongPassword123!' -C -i query_optimization.sql
```

---

## [4] Expected Results

| Method | Console Result | What to Check |
|--------|----------------|---------------|
| DMV | `QueryText`, `WaitSec` tables | Highest `wait_type` values (e.g., `PAGEIOLATCH`) |
| XE | Session list | `is_running = 1` for `TrackLongQueries` |
| Optimization | Text showplans | `Columnstore Index Scan` vs `Index Scan` |

---

## [5] Technical Notes

### 5.1 Dynamic Management Views (DMV)

All DMVs start with `sys.dm_`. Data resets on container/service restart. Use Query Store for long-term analysis.

### 5.2 Extended Events in Docker

**.xel files** stored at `/var/opt/mssql/log/`. Copy to host for SSMS analysis:
```bash
docker cp sql1:/var/opt/mssql/log/long_queries.xel ./logs/
```

### 5.3 Why Columnstore?

For tables >100k rows: 10x compression, 100x faster analytics (`SUM`, `AVG`, `GROUP BY`) via column-based storage.

### 5.4 Execution Plans (Showplan)

`SET SHOWPLAN_TEXT ON` shows execution hierarchy. Look for `Parallelism` and `Batch Storage` operators.

---

**Lab 2.3 verification complete**
