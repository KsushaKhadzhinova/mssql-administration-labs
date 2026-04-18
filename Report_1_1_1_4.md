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

**[Screenshot #0.1]** ![WSL2 and Ubuntu Installation]
<img width="1159" height="402" alt="image" src="https://github.com/user-attachments/assets/8242bc1d-8da2-4af6-ab6d-45c73722c3a6" />
*Figure 1: Successful installation of WSL2 and Ubuntu distribution.*

**[Screenshot #0.2]** ![Docker Compose Success]
<img width="906" height="161" alt="photo_5_2026-04-18_21-37-05" src="https://github.com/user-attachments/assets/5fcced87-dffa-4306-af06-683a81941eea" />
*Figure 2: Orchestration of sql1, sql2, sql3, and mailhog containers.*

---

## Lab 1.1: Installation and Connectivity Verification

### Objective
Deploy a distributed infrastructure consisting of multiple SQL Server instances and verify network connectivity.

### Tasks Completed
- **Container Deployment:** Orchestrated three SQL Server instances using Docker Compose with non-standard port mapping (14331-14333).
- **Connectivity Check:** Verified server access using the `sqlcmd` utility and automated Bash scripts.

**[Screenshot #1.1]** ![Connectivity Verification]
<img width="1280" height="432" alt="photo_3_2026-04-18_21-37-05" src="https://github.com/user-attachments/assets/98c553a3-1c01-4f46-b5eb-93030ab389f5" />
*Figure 3: Output of verify_connectivity.sh showing active SQL Server versions and container IDs.*

---

## Lab 1.2: Database and File Management

### Objective
Configure the physical architecture of a database, manage file growth, and implement logical schemas.

### Tasks Completed
- **Physical Layout:** Configured the `Test` database with primary (`.mdf`) and secondary (`.ndf`) data files across different filegroups.
- **Schema Management:** Implemented `OtherOwnerSchema` assigned to a non-login user (`OtherUser`) to demonstrate advanced ownership models.

**[Screenshot #2.1]** ![Schema Ownership]
<img width="1280" height="639" alt="photo_6_2026-04-18_21-37-05" src="https://github.com/user-attachments/assets/9f122ddb-a672-4f4e-85fb-8fbfab018294" />
*Figure 4: List of database schemas and their respective owners.*

**[Screenshot #2.2]** ![File Management]
<img width="1280" height="768" alt="photo_7_2026-04-18_21-37-05" src="https://github.com/user-attachments/assets/ce835b95-4848-4f5f-93fd-4b29fbb78c9d" />
*Figure 5: Physical file locations in /var/opt/mssql/data/ and their growth settings.*

---

## Lab 1.3: Backup and Disaster Recovery

### Objective
Implement Disaster Recovery (DR) strategies and simulate physical file failures.

### Tasks Completed
- **Backup Execution:** Performed Full Backups of system and user databases.
- **Corruption Simulation:** Manually corrupted the `.mdf` file header using the Linux `dd` utility to simulate a "hard" drive failure.
- **Restoration:** Successfully recovered the database from the backup media, moving the state from `RECOVERY_PENDING` back to `ONLINE`.

**[Screenshot #3.0]** ![Manual Backup Execution]
<img width="1148" height="234" alt="photo_8_2026-04-18_21-37-05" src="https://github.com/user-attachments/assets/c3e05a20-3964-4cfb-8c1c-2c64fdc015e7" />
*Figure 6: Execution of a full database and log backup via sqlcmd.*

**[Screenshot #3.1]** ![Corruption Simulation]
<img width="1279" height="353" alt="photo_9_2026-04-18_21-37-05" src="https://github.com/user-attachments/assets/98fcb53b-cf77-49ea-9bfa-c52c01999950" />
*Figure 6: Database corruption command and the resulting "Database cannot be opened" error.*

**[Screenshot #3.2]** ![Successful Restore]
<img width="1280" height="286" alt="photo_10_2026-04-18_21-37-05" src="https://github.com/user-attachments/assets/15a5fdf4-ed2a-45fe-a2e3-8eb753daa86e" />
*Figure 7: Final restoration log showing the database returning to ONLINE status.*

---

## Lab 1.4: Security and Access Management

### Objective
Implement a Role-Based Access Control (RBAC) model to enforce the principle of least privilege.

### Tasks Completed
- **Role Configuration:** Created `Manager` and `Employee` database roles with specific permission sets.
- **Access Restriction:** Applied `DENY` permissions to restrict the `Employee` role from accessing sensitive tables.
- **Security Validation:** Verified permissions using the `EXECUTE AS USER` context.

**[Screenshot #4.1]** ![Security Verification]
<img width="1280" height="474" alt="photo_11_2026-04-18_21-37-05" src="https://github.com/user-attachments/assets/753b1470-f3d8-44cf-9e20-fe577de7129a" />
*Figure 8: Error Msg 229 confirming that the SELECT permission was denied as expected.*

---

## Summary (Section #1)

During this phase, a resilient and secure MS SQL Server environment was successfully established within Docker. Core administrative skills—including disaster recovery, physical file tuning, and RBAC security—were demonstrated and verified through automated scripts. All instances are synchronized and ready for high-availability configuration.
