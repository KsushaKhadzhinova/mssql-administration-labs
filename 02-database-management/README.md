# Lab 1.2: Database and File Management

This laboratory work focuses on advanced database configuration, including secondary data files (`.ndf`) in custom filegroups, file growth restrictions, and database-level security through custom schemas and user-based authorization.

---

## [1] How to Use This Folder

### Navigate to the Directory

Ensure you are in your local repository folder within Ubuntu (WSL2) terminal:

```bash
cd ~/mssql-administration-labs/02-database-management
```

### Prerequisites

- Docker containers from `00-environment-setup` must be running
- `mssql-tools18` must be installed and added to `$PATH`

---

## [2] Automated Execution

Run the master Bash script to complete all tasks sequentially:

```bash
# Make the script executable
chmod +x verify_lab_02.sh

# Run the full lab cycle
./verify_lab_02.sh
```

---

## [3] Manual Step-by-Step Execution

### Step 1: Create the 'Test' Database with Filegroups

Creates `Test` database with primary data file, transaction log, and secondary data file (`testdata_b.ndf`) in custom filegroup:

```bash
sqlcmd -S localhost,14331 -U sa -P 'YourStrongPassword123!' -C -i create_test_db.sql
```

**Primary File:** 4MB size, 10MB max, 2MB growth  
**Secondary File:** 5MB size

### Step 2: Configure Schemas and Authorization

Create custom schema and "User without Login," then transfer ownership of second schema:

```bash
sqlcmd -S localhost,14331 -U sa -P 'YourStrongPassword123!' -C -i manage_schemas_users.sql
```

### Step 3: Verify Physical File Structure

Confirm `.mdf`, `.ldf`, and `.ndf` files placement and size/growth settings:

```bash
sqlcmd -S localhost,14331 -U sa -P 'YourStrongPassword123!' -C -i check_db_files.sql
```

---

## [4] Expected Results Summary

| Task | Expected Outcome |
|------|------------------|
| Database Creation | `Test` database created with 3 files total |
| Filegroups | `testdata_b.ndf` assigned to `TestFileGroup` |
| Growth Limits | `testdata_a` shows 10MB `MAXSIZE` limit |
| Schemas | `OtherOwnerSchema` owned by `OtherUser` |

---

## [TECHNICAL NOTES]

- **Physical Paths:** All database files stored at `/var/opt/mssql/data/` within container
- **Security:** Creates database user `OtherUser` without server login for internal authorization testing
- **Connection:** Targets host port `14331` (`sql1`)

---

**Lab 1.2 verification complete**
