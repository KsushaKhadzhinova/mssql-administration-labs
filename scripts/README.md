# Automation & Orchestration Control Center

This directory serves as the centralized management hub for the repository. It contains the primary orchestration scripts used to deploy, configure, and verify the entire MS SQL Server laboratory environment automatically.

---

## Orchestrator: run_all_labs.sh

The `run_all_labs.sh` script is a comprehensive Bash orchestrator that sequentially executes administrative tasks from Labs 1.1 through 2.3. It is designed to demonstrate a full deployment lifecycle without manual T-SQL intervention.

### Automated Workflow Logic

| Phase | Focus Area | Actions Performed |
|-------|------------|-------------------|
| **01** | Connectivity | Verifies SQL instances and initializes the `Test` database. |
| **02** | Recovery | Backs up data, executes physical corruption via `dd`, and performs restoration. |
| **03** | Security | Configures RBAC, Login/Role hierarchies, and `DENY` permissions. |
| **04** | Automation | Sets up Database Mail, Operators, and SQL Agent Maintenance Jobs. |
| **05** | Replication | Configures internal Distributor and Transactional Replication (`sql1` → `sql2`). |
| **06** | Performance | Injects data into `ProjectDB` and implements Columnstore optimization. |

---

## Execution Instructions

These scripts are optimized for a **Linux/WSL2** environment. Follow these steps for a successful deployment:

### 1. Grant Execution Permissions

Files created via GitHub Web UI lack execution bits. Run once after cloning:

```bash
chmod +x scripts/*.sh
chmod +x 03-backup-restore/*.sh
```

### 2. Execute the Laboratory Suite

Run the main orchestrator from repository root:

```bash
./scripts/run_all_labs.sh
```

---

## Technical Requirements & Notes

| Requirement | Details |
|-------------|---------|
| **Elevated Privileges** | `sudo` required for `dd` utility (modifies `.mdf` files in Docker volumes) |
| **Security Credentials** | Default: `YourStrongPassword123!`. Update `P` variable if changed |
| **Tooling** | `mssql-tools18` required (`sqlcmd` at `/opt/mssql-tools18/bin/sqlcmd`) |
| **Environment Reset** | `./scripts/cleanup.sh` wipes containers and persistent data |

---

## Output & Logging

The orchestrator provides real-time execution log. Uses `IF NOT EXISTS` logic for SQL objects, enabling safe re-runs without "Object already exists" errors. Failed stages are captured and script continues for maximum lab coverage.

**Automated MS SQL Server Administration Suite**
