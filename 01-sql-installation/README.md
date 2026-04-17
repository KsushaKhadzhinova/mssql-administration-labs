# Lab 1.1: MS SQL Server Installation and Connectivity

This laboratory work serves as the foundation of the project. The goal is to deploy three SQL Server instances and confirm their operational readiness.

---

## Folder Contents

| File | Description |
|------|-------------|
| `check_version.sql` | Checks version, edition, and updates |
| `check_instances.sh` | Verifies container status via Docker API |
| `verify_connectivity.sh` | Verifies network availability on ports 14331-14333 |

---

## Step-by-Step Execution

### Step 1: Check container status

```bash
chmod +x check_instances.sh
./check_instances.sh
```

### Step 2: Edition Verification

Developer or Enterprise Edition is required for replication and automation tasks:

```bash
sqlcmd -S localhost,14331 -U sa -P 'YourStrongPassword123!' -C -i check_version.sql
```

### Step 3: Verify remote connection

```bash
chmod +x verify_connectivity.sh
./verify_connectivity.sh
```

---

## Expected Results

| Parameter | Expected Value |
|-----------|----------------|
| Containers | All 3 instances: `Up` or `Healthy` |
| Edition | `Developer Edition` |
| Connectivity | Each port responds with server name |

---

## Technical Notes

### Port Selection

Range `14331-14333` instead of default `1433`:
- Avoids conflicts with local SQL Server on Windows host
- Simulates named instances in corporate network

### Edition Requirements

**SQL Server Express** lacks:
- SQL Server Agent (Lab 2.1)
- Transactional Replication (Lab 2.2)

**Image:** `mcr.microsoft.com/mssql/server:2022-latest` = Developer Edition by default

### Security

`-C` flag (Trust Server Certificate) bypasses SSL verification for Docker's self-signed certificates.

---
