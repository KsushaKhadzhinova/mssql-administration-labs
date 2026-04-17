# Laboratory Report: Labs 2.1 – 2.3

**Course:** MS SQL Server Administration  
**Student:** Kseniya Khadzhinova  
**Environment:** Docker, Ubuntu (WSL2), MS SQL Server 2022

---

## Lab 2.1: Administration Automation

### Objective
Configure automated database maintenance mechanisms and implement a proactive notification system.

### Tasks Completed

**Database Mail Configuration:**
- Activated the `Database Mail XPs` component via `sp_configure`.
- Created a mail profile named `AdminProfile` and an account associated with `kseniyakhadzhynava@gmail.com`.
- Defined a `DBA_Admin` Operator to receive system alerts and notifications.

**SQL Server Agent Jobs:**
- Developed the `AutoBackup_ProjectDB` job to automate daily backups of the `ProjectDB` database.
- Configured a precise schedule and enabled automatic startup through the SQL Server Agent.

**Alert Management:**
- Configured a high-severity alert for Critical I/O errors (Error 823).
- Linked the alert to the Operator for immediate incident notification.

**[Screenshot #1]** *(List of SQL Server Agent Jobs and the configuration/logs of the Database Mail profile)*

---

## Lab 2.2: Replication and High Availability (HA)

### Objective
Ensure data synchronization and fault tolerance between distributed nodes.

### Tasks Completed

**Transactional Replication:**
- Configured `sql1` as the Distributor and Publisher.
- Created the `Pub_ProjectDB_Data` publication, including tables such as `Products` and `Categories`.
- Configured a Push Subscription on `sql2` to enable near real-time data synchronization.

**Log Shipping (Warm Standby):**
- Prepared `sql3` as a Warm Standby instance.
- Restored the database in `NORECOVERY` mode to enable the application of continuous transaction log backups from `sql1`.

**[Screenshot #2]** *(Replication Monitor status and the database state on `sql3` showing "Restoring" or "Standby" mode)*

---

## Lab 2.3: Monitoring and Troubleshooting

### Objective
Diagnose performance bottlenecks and optimize high-latency queries.

### Tasks Completed

**DMVs (Dynamic Management Views):**
- Analyzed wait statistics using `sys.dm_os_wait_stats` to identify resource contention.
- Monitored active sessions and transactional blocking chains.

**Extended Events (XEvents):**
- Deployed a `TrackLongQueries` session to capture and analyze queries with execution times exceeding 1 second.

**Query Optimization:**
- Conducted performance benchmarking on a dataset of 50,000 rows.
- Implemented a Columnstore Index to facilitate Batch Mode processing, significantly reducing execution time.

**[Screenshot #3]** *(Execution plan comparison between Rowstore and Columnstore, and captured events in the Extended Events viewer)*

---

## Final Course Conclusion

**Block 1 (1.1-1.4):** Established the foundation—infrastructure deployment, file management, disaster recovery, and role-based security.  
**Block 2 (2.1-2.3):** Scaled the environment—automation, high-availability replication, and deep performance monitoring.

A comprehensive, fully automated, and secure MS SQL Server administration infrastructure has been successfully implemented using a Docker-based architecture.

---
