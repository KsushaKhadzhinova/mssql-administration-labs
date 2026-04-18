# Laboratory Report: Labs 1.1 – 1.4

**Course:** MS SQL Server Administration  
**Student:** Kseniya Khadzhinova  
**Environment:** Docker, Ubuntu (WSL2), MS SQL Server 2022

---

## Lab 00: Infrastructure and Environment Setup

### Objective
Prepare the host operating system to support Linux-based containers and orchestrate the SQL Server environment.

### Tasks Completed
- **WSL2 Integration:** Enabled the Virtual Machine Platform and Windows Subsystem for Linux via PowerShell.
- **Linux Distribution:** Installed Ubuntu 22.04 LTS as the primary environment for administrative tools.
- **Docker Orchestration:** Defined and launched a multi-container network using Docker Compose to isolate database instances.

**[Screenshot #0.1]** ![WSL2 and Ubuntu Installation](photo_1.jpg)  
*Figure 1: Successful installation of WSL2 and Ubuntu distribution.*

**[Screenshot #0.2]** ![Docker Compose Success](photo_5.jpg)  
*Figure 2: Orchestration of sql1, sql2, sql3, and mailhog containers.*

---

## Lab 1.1: Installation and Connectivity Verification

### Objective
Deploy a distributed infrastructure consisting of multiple SQL Server instances and verify network connectivity.

### Tasks Completed
- **Container Deployment:** Orchestrated three SQL Server instances using Docker Compose with non-standard port mapping (14331-14333).
- **Connectivity Check:** Verified server access using the `sqlcmd` utility and automated Bash scripts.

**[Screenshot #1.1]** ![Connectivity Verification](photo_3.jpg)  
*Figure 3: Output of verify_connectivity.sh showing active SQL Server versions and container IDs.*

---

## Lab 1.2: Database and File Management

### Objective
Configure the physical architecture of a database, manage file growth, and implement logical schemas.

### Tasks Completed
- **Physical Layout:** Configured the `Test` database with primary (`.mdf`) and secondary (`.ndf`) data files across different filegroups.
- **Schema Management:** Implemented `OtherOwnerSchema` assigned to a non-login user (`OtherUser`) to demonstrate advanced ownership models.

**[Screenshot #2.1]** ![Schema Ownership](photo_6.jpg)  
*Figure 4: List of database schemas and their respective owners.*

**[Screenshot #2.2]** ![File Management](photo_7.jpg)  
*Figure 5: Physical file locations in /var/opt/mssql/data/ and their growth settings.*

---

## Lab 1.3: Backup and Disaster Recovery

### Objective
Implement Disaster Recovery (DR) strategies and simulate physical file failures.

### Tasks Completed
- **Backup Execution:** Performed Full Backups of system and user databases.
- **Corruption Simulation:** Manually corrupted the `.mdf` file header using the Linux `dd` utility to simulate a "hard" drive failure.
- **Restoration:** Successfully recovered the database from the backup media, moving the state from `RECOVERY_PENDING` back to `ONLINE`.

**[Screenshot #3.1]** ![Corruption Simulation](photo_9.jpg)  
*Figure 6: Database corruption command and the resulting "Database cannot be opened" error.*

**[Screenshot #3.2]** ![Successful Restore](photo_10.jpg)  
*Figure 7: Final restoration log showing the database returning to ONLINE status.*

---

## Lab 1.4: Security and Access Management

### Objective
Implement a Role-Based Access Control (RBAC) model to enforce the principle of least privilege.

### Tasks Completed
- **Role Configuration:** Created `Manager` and `Employee` database roles with specific permission sets.
- **Access Restriction:** Applied `DENY` permissions to restrict the `Employee` role from accessing sensitive tables.
- **Security Validation:** Verified permissions using the `EXECUTE AS USER` context.

**[Screenshot #4.1]** ![Security Verification](photo_11.jpg)  
*Figure 8: Error Msg 229 confirming that the SELECT permission was denied as expected.*

---

## Summary (Section #1)

During this phase, a resilient and secure MS SQL Server environment was successfully established within Docker. Core administrative skills—including disaster recovery, physical file tuning, and RBAC security—were demonstrated and verified through automated scripts. All instances are synchronized and ready for high-availability configuration.
