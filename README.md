# MS SQL Server Administration Portfolio

**Student:** Kseniya Khadzhinova  
**Technologies:** Docker, SQL Server 2022 (Linux), Ubuntu (WSL2), Bash, T-SQL

This repository demonstrates a complete administrative lifecycle for a distributed Microsoft SQL Server environment. It covers infrastructure deployment, disaster recovery, security auditing, automation, and high-availability configurations.

---

## Infrastructure Architecture

The project utilizes a three-node distributed system within a private Docker network. Each node serves a specific role in the administration labs.

* **sql1 (Port 14331):** Primary Instance. Acts as the Publisher and Distributor for replication.
* **sql2 (Port 14332):** Secondary Instance. Acts as the Replication Subscriber.
* **sql3 (Port 14333):** Standby Instance. Used for Log Shipping and disaster recovery simulations.

---

## Database Logic & Segmentation

To maintain clarity and prevent technical conflicts, the project is divided into two logical segments:

1.  **Database `Test`:** Dedicated to Physical Architecture and Disaster Recovery (Labs 1.2 – 1.3). It is used to demonstrate filegroup management and page-level restoration after manual corruption.
2.  **Database `ProjectDB`:** Dedicated to Production Administration (Labs 1.4 – 2.3). It is used for Security (RBAC), SQL Agent Automation, Transactional Replication, and Performance Tuning.

---

## Laboratory Navigation

| Folder | Description | Key Deliverables |
| :--- | :--- | :--- |
| **[00-environment-setup](./00-environment-setup)** | Docker & Network | `docker-compose.yml`, `init.sql` |
| **[01-sql-installation](./01-sql-installation)** | Connectivity & Versioning | `check_version.sql`, Instance validation |
| **[02-database-management](./02-database-management)** | Storage Engine | Filegroups, NDF files, Schema ownership |
| **[03-backup-restore](./03-backup-restore)** | Disaster Recovery | Corruption simulation, Page restore |
| **[04-security-management](./04-security-management)** | Security Auditing | RBAC, DENY permissions, Logins |
| **[05-admin-automation](./05-admin-automation)** | Operations | SQL Agent Jobs, Alerts, Database Mail |
| **[06-replication-ha](./06-replication-ha)** | High Availability | Transactional Replication (sql1 -> sql2) |
| **[07-monitoring-troubleshoot](./07-monitoring-troubleshoot)** | Performance | Columnstore indexes, DMV Analysis |

---

## Deployment & Execution

Since the project scripts were developed in a Linux environment, you must ensure they have the correct execution permissions after cloning the repository.

### 1. Initialize Environment
```bash
docker-compose up -d
```

### 2. Grant Script Permissions
```bash
chmod +x scripts/*.sh
chmod +x 03-backup-restore/*.sh
```

### 3. Run Automated Labs
The orchestrator script will create databases, simulate errors, and configure the infrastructure automatically:
```bash
./scripts/run_all_labs.sh
```

### 4. System Cleanup
To wipe the environment, including all persistent Docker volumes and backups:
```bash
./scripts/cleanup.sh
```
