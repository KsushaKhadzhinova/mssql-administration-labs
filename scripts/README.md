# Automation & Orchestration Control Center

This directory acts as the centralized management hub for the repository. It contains the primary orchestration scripts used to deploy, configure, and verify the entire MS SQL Server laboratory environment.

---

## Orchestrator: run_all_labs.sh

The `run_all_labs.sh` script is a comprehensive Bash orchestrator that sequentially executes all administrative tasks from Labs 1.1 through 2.3. It is designed to demonstrate a full deployment cycle without manual T-SQL execution.

### Automated Workflow Logic
| Phase | Focus Area | Actions Performed |
| :--- | :--- | :--- |
| **01** | Connectivity | Verifies SQL instances and initializes the `Test` database. |
| **02** | Recovery | Backs up data, executes physical corruption, and performs restoration. |
| **03** | Security | Configures RBAC, Login/Role hierarchies, and `DENY` permissions. |
| **04** | Automation | Sets up Database Mail, Operators, and SQL Agent Maintenance Jobs. |
| **05** | Replication | Configures Transactional Replication from `sql1` to `sql2`. |
| **06** | Performance | Injects high-volume data and implements Columnstore optimization. |



---

## Execution Instructions

These scripts are designed for a **Linux/WSL2** environment. Follow these steps for a successful deployment:

### 1. Grant Execution Permissions
Before running the scripts for the first time, you must grant the necessary permissions:
```bash
chmod +x scripts/*.sh
chmod +x 03-backup-restore/*.sh
```

### 2. Execute the Laboratory Suite
Run the main orchestrator from the root of the repository:
```bash
./scripts/run_all_labs.sh
```

**Technical Requirements & Notes**

| Requirement | Details |
|-------------|---------|
| **Elevated Privileges** | Script requires `sudo` for `dd` utility (modifies `.mdf` files in Docker volumes) |
| **Security Credentials** | Default password: `YourStrongPassword123!`. Update `P` variable if changed in `docker-compose.yml` |
| **Tooling** | `mssql-tools18` required (`sqlcmd` at `/opt/mssql-tools18/bin/sqlcmd`) |
| **Environment Reset** | Clean re-run: `./scripts/cleanup.sh` |

---

## Output & Logging

Script provides real-time log of every action. Failed SQL commands (e.g., duplicate objects) are caught, allowing continuation for maximum lab coverage.

**Automated MS SQL Server Administration Suite**
