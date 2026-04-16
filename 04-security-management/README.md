# Lab 1.4: Security Management

This laboratory work establishes a robust security hierarchy within SQL Server, including server logins, database users, custom roles (`Manager` and `Employee`), schema-level security, and access restriction verification using `DENY` permissions and execution context switching.

---

## [1] How to Use This Folder

### Navigate to the Directory

Open your Ubuntu (WSL2) terminal:

```bash
cd ~/mssql-administration-labs/04-security-management
```

### Prerequisites

- SQL Server containers from `00-environment-setup` must be running
- `ProjectDB` database must be initialized

---

## [2] Automated Execution

Run the master Bash script for complete security setup:

```bash
# Grant execution permissions
chmod +x verify_lab_04.sh

# Run the complete security setup
./verify_lab_04.sh
```

---

## [3] Manual Step-by-Step Execution

### Step 1: Set up Logins, Users, and Roles

Create SQL Logins (`TestLogin1`, `TestLogin2`) and assign to `Manager`/`Employee` roles:

```bash
sqlcmd -S localhost,14331 -U sa -P 'YourStrongPassword123!' -C -i setup_logins_roles.sql
```

### Step 2: Configure Permissions and Secure Schemas

Disable `guest` user alterations, create `SecureSchema` owned by `TestUser1`, apply `DENY` on sensitive tables:

```bash
sqlcmd -S localhost,14331 -U sa -P 'YourStrongPassword123!' -C -i configure_permissions.sql
```

### Step 3: Test Security Policies

Verify security using `EXECUTE AS` to impersonate `TestUser2`:

```bash
sqlcmd -S localhost,14331 -U sa -P 'YourStrongPassword123!' -C -i test_security_access.sql
```

---

## [4] Verification & Expected Results

| Security Task | Script | Expected Outcome |
|---------------|--------|------------------|
| Server Logins | `setup_logins_roles.sql` | `TestLogin1` and `TestLogin2` created |
| RBAC | `setup_logins_roles.sql` | Users added to `Manager` and `Employee` roles |
| Schema Security | `configure_permissions.sql` | `SecureSchema.SalaryData` created with restricted access |
| Impersonation Test | `test_security_access.sql` | "Access to SalaryData denied as expected" appears |

---

## [TECHNICAL NOTES]

- **Instance Targeting:** All scripts execute against `sql1` (host port `14331`)
- **Mixed Mode:** Requires SQL Server in Mixed Mode Authentication (configured in Lab 1.1)
- **Permissions Hierarchy:** `DENY` at any level overrides `GRANT`
- **Security Context:** Testing script uses `REVERT` to return session to `sa` account

---

**Lab 1.4 verification complete**
