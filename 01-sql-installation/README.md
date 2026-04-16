# Lab 1.1: Installation and Connectivity Verification

This laboratory work verifies the deployment of multiple SQL Server instances, tests network connectivity across custom ports, and validates server-level configurations (Authentication Mode and Backup Paths).

---

## [1] How to Use This Folder

### Connect to the Repository

Navigate to your local repository directory:

```bash
cd ~/mssql-administration-labs/01-sql-installation
```

**Note:** If working on a new machine, first clone the repo:
```bash
git clone https://github.com/KsushaKhadzhinova/mssql-administration-labs.git
```

### Prerequisites

The infrastructure from `00-environment-setup` must be active. Check containers:

```bash
docker ps
```

You should see `sql1` (port 14331) and `sql2` (port 14332) with status `Up`.

---

## [2] Running Verification Scripts

### Step 1: Check Docker Instance Status

Filter and display only SQL Server containers and their port mappings:

```bash
chmod +x check_instances.sh
./check_instances.sh
```

### Step 2: Test SQL Connectivity

Connect to both instances using `sqlcmd` to confirm default and named instance functionality:

```bash
chmod +x verify_connectivity.sh
./verify_connectivity.sh
```

---

## [3] Validating Server Configurations (T-SQL)

Execute T-SQL scripts to verify critical installation requirements.

### Step 3: Verify Backup Directory and Default Settings

Check the default backup path and test master database backup:

```bash
sqlcmd -S localhost,14331 -U sa -P 'YourStrongPassword123!' -C -i setup_backup_dir.sql
```

### Step 4: Confirm Authentication Mode

Verify Mixed Mode authentication as required by lab specifications:

```bash
sqlcmd -S localhost,14331 -U sa -P 'YourStrongPassword123!' -C -i check_auth_mode.sql
```

---

## [4] Expected Results Summary

| Task | Script/Command | Expected Output |
|------|----------------|-----------------|
| Instance Status | `check_instances.sh` | List showing `sql1` and `sql2` with status `Up` |
| Connectivity | `verify_connectivity.sh` | ServerName and Version displayed for both instances |
| Backup Path | `setup_backup_dir.sql` | Path shows `/var/opt/mssql/backup/` |
| Security Mode | `check_auth_mode.sql` | Output confirms `Mixed Mode` |

---

## [TECHNICAL NOTES]

- **Ports:** `sql1` uses host port `14331`, `sql2` uses host port `14332`
- **Credentials:** Scripts use default `sa` account with setup password
- **CLI Environment:** All commands execute from Ubuntu (WSL2) terminal using `mssql-tools18`

---

**Lab 1.1 verification complete**
