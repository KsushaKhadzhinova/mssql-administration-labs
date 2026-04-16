# Lab 2.2: Replication and High Availability (HA/DR)

This lab configures replication, log shipping, and a practical HA/DR strategy for the company scenario.

---

## [STEP 1] Configure Distribution (sql1)

Set up the first instance as both Distributor and Publisher:

```bash
sqlcmd -S localhost,14331 -U sa -P 'YourStrongPassword123!' -C -Q "
EXEC sp_adddistributor @distributor = 'sql1', @password = 'YourStrongPassword123!';
EXEC sp_adddistributiondb @database = 'distribution';
EXEC sp_adddistpublisher @publisher = 'sql1', @distribution_db = 'distribution', @working_directory = '/var/opt/mssql/data';
"
```

**Expected Result:**  
Distribution database is created and `sql1` is configured as Distributor and Publisher.

---

## [STEP 2] Create Publication (sql1)

Enable replication for `ProjectDB` and create a transactional publication for the `Orders` table:

```bash
sqlcmd -S localhost,14331 -U sa -P 'YourStrongPassword123!' -C -d ProjectDB -Q "
EXEC sp_replicationdboption @dbname = 'ProjectDB', @optname = 'publish', @value = 'true';
EXEC sp_addpublication @publication = 'Pub_Orders', @repl_freq = 'continuous', @status = 'active', @independent_agent = 'true';
EXEC sp_addpublication_snapshot @publication = 'Pub_Orders', @agent_name = 'sql1_snapshot_agent';
EXEC sp_addarticle @publication = 'Pub_Orders', @article = 'Orders', @source_object = 'Orders', @type = 'logbased', @destination_table = 'Orders_Replica';
"
```

**Expected Result:**  
Publication `Pub_Orders` is created and the `Orders` table is added as an article.

---

## [STEP 3] Create Push Subscription (sql1 to sql3)

Configure `sql3` as a subscriber to receive replicated data from `sql1`:

```bash
sqlcmd -S localhost,14331 -U sa -P 'YourStrongPassword123!' -C -d ProjectDB -Q "
EXEC sp_addsubscription @publication = 'Pub_Orders', @subscriber = 'sql3', @destination_db = 'ProjectDB_Sub', @subscription_type = 'Push';
EXEC sp_addpushsubscription_agent @publication = 'Pub_Orders', @subscriber = 'sql3', @subscriber_db = 'ProjectDB_Sub', @subscriber_security_mode = 0, @subscriber_login = 'sa', @subscriber_password = 'YourStrongPassword123!';
"
```

**Expected Result:**  
`sql3` is registered as a push subscriber for `Pub_Orders`.

---

## [STEP 4] Configure Log Shipping (sql1 to sql2)

Set up a manual log shipping sequence between `sql1` as primary and `sql2` as secondary.

### On sql1: Create backup job

```bash
sqlcmd -S localhost,14331 -U sa -P 'YourStrongPassword123!' -C -Q "
EXEC msdb.dbo.sp_add_job @job_name = 'LS_Backup_ProjectDB';
EXEC msdb.dbo.sp_add_jobstep @job_name = 'LS_Backup_ProjectDB', @step_name = 'Backup', 
    @command = 'BACKUP LOG ProjectDB TO DISK = ''/var/opt/mssql/backup/ProjectDB_LS.trn'' WITH FORMAT';
EXEC msdb.dbo.sp_add_jobserver @job_name = 'LS_Backup_ProjectDB';
"
```

### On sql2: Initialize database and create restore job

```bash
sqlcmd -S localhost,14332 -U sa -P 'YourStrongPassword123!' -C -Q "
RESTORE DATABASE ProjectDB_LS FROM DISK = '/var/opt/mssql/backup/Test.bak' WITH NORECOVERY, 
    MOVE 'testdata_a' TO '/var/opt/mssql/data/ls_data.mdf',
    MOVE 'testdata_b' TO '/var/opt/mssql/data/ls_data.ndf',
    MOVE 'Test_log' TO '/var/opt/mssql/data/ls_log.ldf';
GO
EXEC msdb.dbo.sp_add_job @job_name = 'LS_Restore_ProjectDB';
EXEC msdb.dbo.sp_add_jobstep @job_name = 'LS_Restore_ProjectDB', @step_name = 'Restore', 
    @command = 'RESTORE LOG ProjectDB_LS FROM DISK = ''/var/opt/mssql/backup/ProjectDB_LS.trn'' WITH NORECOVERY';
EXEC msdb.dbo.sp_add_jobserver @job_name = 'LS_Restore_ProjectDB';
"
```

**Expected Result:**  
Backup and restore jobs are created for log shipping workflow.

---

## [STEP 5] Mechanism Description for the Company Scenario

Recommended infrastructure strategy:

- Server 1 (`Orders`) to client: use **Transactional Replication** for near real-time delivery of order data.
- Server 2 (`Suppliers`) to client: use **SSIS** or daily differential backups, since supplier data changes less frequently.
- Server 3 (`Stocks`) to client: use **Transactional Replication** or **AlwaysOn Availability Groups**, because stock data needs low latency.
- Data preservation: use a unified **Full / Differential / Log** backup strategy on all servers, with backups stored in the shared `/var/opt/mssql/backup` volume to emulate a network share.

**Expected Result:**  
A clear HA/DR plan balancing data freshness, restore time, and operational cost.

---

## [STEP 6] Verify Replication Status

Check whether the subscription is active on the distributor:

```bash
sqlcmd -S localhost,14331 -U sa -P 'YourStrongPassword123!' -C -Q "SELECT * FROM distribution.dbo.MSsubscriptions;"
```

**Expected Result:**  
A record showing `sql3` as a subscriber for the `Pub_Orders` publication.

---

**End of Lab 2.2**
