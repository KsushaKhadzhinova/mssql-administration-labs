# MS SQL Server Administration Portfolio
**Student:** Kseniya Khadzhinova  
**Technologies:** Docker, SQL Server 2022 (Linux), Ubuntu (WSL2), Bash, T-SQL

## Infrastructure Architecture
The project simulates a distributed corporate network consisting of three nodes connected via a dedicated Docker virtual network.



## Database Logic
1. **Database `Test`** (Labs 1.2 — 1.3): Sandbox for physical file management and disaster recovery scenarios.
2. **Database `ProjectDB`** (Labs 1.4 — 2.3): Environment for security, automation, replication, and performance tuning.

## Navigation
| Folder | Task |
| :--- | :--- |
| **[01-sql-installation](./01-sql-installation)** | Instance verification and connectivity. |
| **[03-backup-restore](./03-backup-restore)** | Corruption simulation and recovery. |
| **[05-admin-automation](./05-admin-automation)** | Jobs, Alerts, and Mail. |
| **[06-replication-ha](./06-replication-ha)** | Transactional Replication and Standby nodes. |

## Deployment
1. Start containers: `docker-compose up -d`
2. Run automated labs: `bash scripts/run_all_labs.sh`
3. Reset environment: `bash scripts/cleanup.sh`

## Contact
**Email:** [kseniyakhadzhynava@gmail.com](mailto:kseniyakhadzhynava@gmail.com)
