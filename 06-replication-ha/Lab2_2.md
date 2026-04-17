# Lab 2.2: Replication and High Availability (HA/DR)

This lab configures replication, log shipping, and practical HA/DR strategy for company scenario.

---

## STEP 1: Configure Distribution (sql1)

Set up first instance as Distributor and Publisher:

```bash
sqlcmd -S localhost,14331 -U sa -P 'YourStrongPassword123!' -C -Q "
EXEC sp_adddistributor @distributor = 'sql1', @password = 'YourStrongPassword123!';
EXEC sp_adddistributiondb @database = 'distribution';
EXEC sp_adddistpublisher @publisher = 'sql1', @distribution_db = 'distribution', @working_directory = '/var/opt/mssql/backup';
"
```

---

## STEP 2: Create Publication (sql1)

Enable replication for `ProjectDB`, publish `Products` and `Categories`:

```bash
sqlcmd -S localhost,14331 -U sa -P 'YourStrongPassword123!' -C -d ProjectDB -Q "
EXEC sp_replicationdboption @dbname = 'ProjectDB', @optname = 'publish', @value = 'true';
EXEC sp_addpublication @publication = 'Pub_ProjectDB_Data', @repl_freq = 'continuous', @status = 'active', @independent_agent = 'true';
EXEC sp_addpublication_snapshot @publication = 'Pub_ProjectDB_Data', @frequency_type = 1;
EXEC sp_addarticle @publication = 'Pub_ProjectDB_Data', @article = 'Products', @source_object = 'Products', @type = 'logbased', @destination_table = 'Products';
EXEC sp_addarticle @publication = 'Pub_ProjectDB_Data', @article = 'Categories', @source_object = 'Categories', @type = 'logbased', @destination_table = 'Categories';
"
```

---

## STEP 3: Create Push Subscription (sql1 → sql2)

Initialize replica and configure subscription:

```bash
sqlcmd -S localhost,14332 -U sa -P 'YourStrongPassword123!' -C -Q "CREATE DATABASE ProjectDB_Replica;"
sqlcmd -S localhost,14331 -U sa -P 'YourStrongPassword123!' -C -d ProjectDB -Q "
EXEC sp_addsubscription @publication = 'Pub_ProjectDB_Data', @subscriber = 'sql2', @destination_db = 'ProjectDB_Replica', @subscription_type = 'Push';
EXEC sp_addpushsubscription_agent @publication = 'Pub_ProjectDB_Data', @subscriber = 'sql2', @subscriber_db = 'ProjectDB_Replica', @subscriber_security_mode = 0, @subscriber_login = 'sa', @subscriber_password = 'YourStrongPassword123!';
"
```

---

## STEP 4: Configure Log Shipping (sql1 → sql3)

**sql1 (backup job):**

```bash
sqlcmd -S localhost,14331 -U sa -P 'YourStrongPassword123!' -C -Q "
EXEC msdb.dbo.sp_add_job @job_name = 'LS_Backup_ProjectDB';
EXEC msdb.dbo.sp_add_jobstep @job_name = 'LS_Backup_ProjectDB', @step_name = 'Backup_Step', @command = 'BACKUP LOG ProjectDB TO DISK = ''/var/opt/mssql/backup/ProjectDB_LS.trn'' WITH FORMAT';
EXEC msdb.dbo.sp_add_jobserver @job_name = 'LS_Backup_ProjectDB';
"
```

**sql3 (restore job):**

```bash
sqlcmd -S localhost,14333 -U sa -P 'YourStrongPassword123!' -C -Q "
RESTORE DATABASE ProjectDB_LS FROM DISK = '/var/opt/mssql/backup/ProjectDB_Auto.bak' WITH NORECOVERY, 
MOVE 'ProjectDB' TO '/var/opt/mssql/data/ProjectDB_LS.mdf', 
MOVE 'ProjectDB_log' TO '/var/opt/mssql/data/ProjectDB_LS.ldf';
EXEC msdb.dbo.sp_add_job @job_name = 'LS_Restore_ProjectDB';
EXEC msdb.dbo.sp_add_jobstep @job_name = 'LS_Restore_ProjectDB', @step_name = 'Restore_Step', @command = 'RESTORE LOG ProjectDB_LS FROM DISK = ''/var/opt/mssql/backup/ProjectDB_LS.trn'' WITH NORECOVERY';
EXEC msdb.dbo.sp_add_jobserver @job_name = 'LS_Restore_ProjectDB';
"
```

---

## STEP 5: Company Scenario Strategy

**Recommendations:**
- **Products/Categories → Client:** Transactional Replication (real-time)
- **Suppliers → Client:** SSIS/daily differential backups (low frequency)
- **Stocks → Client:** Transactional Replication/AlwaysOn (low latency)

---

## STEP 6: Verify Replication Status

```bash
sqlcmd -S localhost,14331 -U sa -P 'YourStrongPassword123!' -C -Q "SELECT * FROM distribution.dbo.MSsubscriptions;"
```

---

**End of Lab 2.2**
