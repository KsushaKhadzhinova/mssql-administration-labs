# Automation Scripts & Orchestration

This folder serves as the "control center" for the entire repository. It contains the consolidated `run_all_labs.sh` script for quick verification, demonstration, or restoration of the complete MSSQL lab environment.

---

## [1] Main Script: run_all_labs.sh

The `run_all_labs.sh` Bash script sequentially executes tasks from all laboratory works (1.1 through 2.3), eliminating the need to run dozens of SQL files manually.

**What happens during execution:**
- **Connectivity Check (Labs 1.1-1.2):** Verifies `sql1` and `sql2` containers, creates `Test` database with specified file parameters
- **Disaster Recovery (Lab 1.3):** Creates backups, stops container, corrupts database file using `dd`, restores it
- **Security (Lab 1.4):** Creates login/role hierarchy (`Manager`/`Employee`), configures schemas, applies `DENY` restrictions
- **Automation (Lab 2.1):** Enables Database Mail, creates operators, sets up recurring backup job for `ProjectDB`
- **High Availability (Lab 2.2):** Configures transactional replication (`sql1` → `sql2`), prepares `sql3` as standby node
- **Optimization (Lab 2.3):** Generates 10,000 data rows, demonstrates Columnstore index acceleration

---

## [2] Launch Instructions

**You must be in Ubuntu (WSL2) terminal.**

### Step 1: Navigate to Directory

```bash
cd ~/mssql-administration-labs/scripts
```

### Step 2: Set Execution Permissions

```bash
chmod +x run_all_labs.sh
```

### Step 3: Run

```bash
./run_all_labs.sh
```

---

## [3] Technical Notes

- **Credentials:** Script uses `YourStrongPassword123!`. Update `P` variable at script start if changed in `docker-compose.yml`
- **sudo Usage:** Script prompts for sudo password midway (required for `dd` utility to simulate file corruption in Docker volumes)
- **Dependencies:** Requires `mssql-tools18` (`sqlcmd` at `/opt/mssql-tools18/bin/sqlcmd`)
- **Cleanup:** Script doesn't auto-remove objects. For clean re-run:
  ```bash
  docker-compose down -v && docker-compose up -d
  ```

---

## [4] Output Structure

Script provides real-time execution log. Failed stages show `sqlcmd` error messages but continue to maximize task coverage.

---

**Complete MSSQL Labs 1.1-2.3 verification in one command**
