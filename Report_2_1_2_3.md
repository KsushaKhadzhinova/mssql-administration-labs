# Laboratory Report: Labs 2.1 – 2.3

**Course:** MS SQL Server Administration  
**Student:** Kseniya Khadzhinova  
**Environment:** Docker, Ubuntu (WSL2), MS SQL Server 2022

---

## Lab 2.1: Administration Automation

### Objective
Automate routine maintenance tasks using SQL Server Agent, Jobs, and Alerts to ensure database reliability and proactive monitoring.

### Tasks Completed
- **Operator & Mail Configuration:** Configured Database Mail and assigned an Operator for automated notifications.
- **Maintenance Jobs:** Created the `Daily_ProjectDB_Backup` job to automate full backups.
- **Alerting:** Set up SQL Server Alerts for critical errors (Severity 17-25) to trigger immediate responses.
- **Validation:** Manually triggered the backup job to verify execution flow and SQL Agent responsiveness.

**[Screenshot #1]** ![Backup Job Execution]
<img width="1187" height="272" alt="photo_1_2026-04-18_21-52-11" src="https://github.com/user-attachments/assets/0b7076b0-e4a1-4fc6-94ba-72f5600dd7fb" />
*Figure 1: Successful manual start of the automated backup job via SQL Agent.*

---

## Lab 2.2: Replication & High Availability (HA)

### Objective
Implement data redundancy and high availability using Transactional Replication and Log Shipping.

### Tasks Completed
- **Transactional Replication:** - Configured `sql1` as the Distributor and Publisher.
    - Created the `Pub_ProjectDB_Data` publication.
    - Configured `sql2` as the Subscriber with a Push Subscription for real-time data synchronization.
- **Log Shipping (HA):** - Established Log Shipping between `sql1` (Primary) and `sql3` (Secondary).
    - Verified the standby database state on the secondary server.

**[Screenshot #2.1]** ![Replication Success]
<img width="1280" height="331" alt="photo_10_2026-04-18_21-52-11" src="https://github.com/user-attachments/assets/cb38c020-5677-4cb4-ba62-e599bd609fb7" />
*Figure 2: Completion of the replication and HA configuration script.*

**[Screenshot #2.2]** ![HA Standby State]
<img width="1280" height="198" alt="photo_12_2026-04-18_21-52-11" src="https://github.com/user-attachments/assets/511bfc25-5d80-485f-8d76-fe025b20e295" />
*Figure 3: Verification of ProjectDB_LS on sql3, confirming the RESTORING state required for Log Shipping.*

---

## Lab 2.3: Monitoring & Performance Troubleshooting

### Objective
Identify system bottlenecks using Dynamic Management Views (DMVs) and optimize query performance through indexing.

### Tasks Completed
- **DMV Analysis:** Captured system-wide wait statistics to identify resource contention (e.g., `SOS_WORK_DISPATCHER`).
- **Data Population:** Injected 60,000 records into the `OrderDetails` table to simulate a production workload.
- **Query Optimization:** - Identified a performance bottleneck in a `GROUP BY` query performing a Clustered Index Scan.
    - Implemented a Non-Clustered Index (`IX_ProductID_Quantity`).
- **Validation:** Used `SET SHOWPLAN_TEXT` to confirm the transition from a Table Scan to an efficient **Index Scan**.

**[Screenshot #3.1]** ![Wait Statistics]
<img width="1280" height="526" alt="photo_15_2026-04-18_21-52-11" src="https://github.com/user-attachments/assets/bab8a3e2-5331-4405-b310-4fcdae68830c" />
*Figure 4: Analysis of server wait types using sys.dm_os_wait_stats.*

**[Screenshot #3.2]** ![Execution Plan Optimization]
<img width="1280" height="431" alt="photo_16_2026-04-18_21-52-11" src="https://github.com/user-attachments/assets/06de9036-2203-46fd-acbc-38903153bb75" />
*Figure 5: The optimized execution plan demonstrating the successful use of the new index.*

---

## Lab Cleanup: System Decommissioning

### Objective
Ensure environment integrity by removing persistent data volumes and stopping containerized services.

### Tasks Completed
- **Volume Purging:** Cleared the physical data and log directories on the host to prevent data drift between lab sessions.
- **Service Termination:** Stopped all SQL Server instances and removed the Docker network using Docker Compose.

**[Screenshot #4.1]** ![Volume Cleanup]
<img width="1280" height="599" alt="photo_11_2026-04-18_21-52-11" src="https://github.com/user-attachments/assets/49e6e463-e1cf-4277-9476-5961a1acf658" />
*Figure 6: Manual removal of SQL Server data volumes.*

**[Screenshot #4.2]** ![Docker Down]
<img width="1242" height="261" alt="photo_17_2026-04-18_21-52-11" src="https://github.com/user-attachments/assets/24a54093-f35e-49cb-8bc1-8f018ffb0dae" />
*Figure 7: Final shutdown and removal of the containerized infrastructure.*

---

## Final Summary (Section #2)

The second phase of the laboratory demonstrated the implementation of advanced SQL Server features. By combining SQL Agent automation, Transactional Replication, and Indexing strategies, we established a high-performance, resilient database environment. The transition of the execution plan to an Index Scan serves as a definitive validation of the performance tuning phase.
