# Laboratory Report: Labs 1.1 – 1.4

**Course:** MS SQL Server Administration  
**Student:** Kseniya Khadzhinova  
**Environment:** Docker, Ubuntu (WSL2), MS SQL Server 2022

---

## Lab 1.1: Installation and Connectivity Verification

### Objective
Deploy a distributed infrastructure consisting of multiple SQL Server instances and verify network connectivity.

### Tasks Completed
- **Container Deployment:** Orchestrated three SQL Server instances (`sql1`, `sql2`, `sql3`) using Docker Compose.
- **Port Configuration:** Mapped instances to non-standard host ports (`14331`, `14332`, `14333`) to prevent local conflicts.
- **Connectivity Check:** Verified server access using the `sqlcmd` utility from the WSL2 terminal.

**[Screenshot #1]** *(Output of `docker ps` and the results of `SELECT @@SERVERNAME` for all instances)*

---

## Lab 1.2: Database and File Management

### Objective
Configure the physical architecture of a database, manage file growth, and implement logical schemas.

### Tasks Completed
**Database `Test` Creation:**
- Primary data file (`.mdf`) restricted to a maximum size of 10 MB.
- Secondary Filegroup `TestFileGroup` added for storage optimization.
- Secondary data file (`.ndf`) created with a 5 MB initial size.

**Schema Management:**
- Created `CustomSchema` for logical object grouping.
- Created `OtherUser` (User without Login) to demonstrate schema ownership.
- Created `OtherOwnerSchema` and assigned `OtherUser` as the owner.

**[Screenshot #2]** *(Query results from `sys.master_files` and the list of schemas with their respective owners)*

---

## Lab 1.3: Backup and Disaster Recovery

### Objective
Implement Disaster Recovery strategies and simulate physical file failures.

### Tasks Completed
- **Backup Execution:** Performed Full Backups of the `master` and `Test` databases.
- **Corruption Simulation:** Manually corrupted the `.mdf` file header using the Linux `dd` utility, resulting in a `RECOVERY_PENDING` state.
- **Restoration:** Successfully restored the database from the backup media to verify the Recovery Time Objective (RTO).
- **Snapshots:** Created a Database Snapshot for rapid "Point-in-Time" data reverts.

**[Screenshot #3]** *(SQL Server Error Log showing corruption errors and the message confirming successful restoration)*

---

## Lab 1.4: Security and Access Management

### Objective
Implement a Role-Based Access Control (RBAC) model to enforce the principle of least privilege.

### Tasks Completed
**Logins and Users:**
- Created `TestLogin1` (assigned `sysadmin` role) and `TestLogin2`.

**Database Roles:**
- Configured `Manager` and `Employee` roles within the `ProjectDB` database.

**Permission Enforcement:**
- Applied `DENY` permissions to the `Employee` role to restrict access to sensitive data.
- Created `SecureSchema` to isolate high-security objects.

**Validation:** Verified access restrictions using the `EXECUTE AS USER` command to simulate different security contexts.

**[Screenshot #4]** *(Successful SELECT from `dbo` versus an `Access Denied` error when querying `SecureSchema`)*

---

## Summary (Section #1)

During this phase, a resilient and secure MS SQL Server environment was successfully established within Docker. Core administrative skills—including disaster recovery, physical file tuning, and RBAC security—were demonstrated and verified through automated scripts.

---
