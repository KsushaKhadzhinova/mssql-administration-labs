# Lab 2.3: Monitoring and Troubleshooting

This lab covers live system monitoring, Extended Events, performance testing, indexing, execution plan comparison, and trace cleanup.

---

## [STEP 1] System Activity Monitoring (CLI)

View active processes and resource waits using Dynamic Management Views:

```bash
sqlcmd -S localhost,14331 -U sa -P 'YourStrongPassword123!' -C -Q "
SELECT session_id, status, command, cpu_time, total_elapsed_time, wait_type, last_wait_type 
FROM sys.dm_exec_requests 
WHERE session_id > 50;
"
```

**Expected Result:**  
A table showing active requests, CPU time, elapsed time, and wait information.

---

## [STEP 2] Create Extended Events Session

Set up an Extended Events session for batch completions and save it to a file:

```bash
sqlcmd -S localhost,14331 -U sa -P 'YourStrongPassword123!' -C -Q "
CREATE EVENT SESSION [LabTrace] ON SERVER 
ADD EVENT sqlserver.sql_batch_completed(
    ACTION(package0.collect_system_time, sqlserver.client_app_name, sqlserver.sql_text)
)
ADD TARGET package0.event_file(SET filename='/var/opt/mssql/backup/LabTrace.xel');
ALTER EVENT SESSION [LabTrace] ON SERVER STATE = START;
"
```

**Expected Result:**  
The session starts and begins writing events to `LabTrace.xel`.

---

## [STEP 3] Populate Table with 50,000+ Records

Generate test data in `OrderDetails` for performance testing:

```bash
sqlcmd -S localhost,14331 -U sa -P 'YourStrongPassword123!' -C -d ProjectDB -Q "
SET NOCOUNT ON;
DECLARE @i INT = 1;
WHILE @i <= 60000
BEGIN
    INSERT INTO OrderDetails (OrderID, ProductID, Quantity, PriceAtOrder)
    VALUES (1, 1, @i % 10 + 1, 100.00);
    SET @i = @i + 1;
END;
"
```

**Expected Result:**  
60,000 rows are inserted into `OrderDetails`.

---

## [STEP 4] Analyze Query Plan without Indexes

Enable text-based showplan and run a search query:

```bash
sqlcmd -S localhost,14331 -U sa -P 'YourStrongPassword123!' -C -d ProjectDB -Q "
SET SHOWPLAN_TEXT ON;
GO
SELECT * FROM OrderDetails WHERE Quantity = 5;
GO
SET SHOWPLAN_TEXT OFF;
"
```

**Expected Result:**  
The plan should show `Table Scan` or `Index Scan`.

---

## [STEP 5] Create Non-Clustered and Columnstore Indexes

Optimize the table for search and analytical workloads:

```bash
sqlcmd -S localhost,14331 -U sa -P 'YourStrongPassword123!' -C -d ProjectDB -Q "
CREATE NONCLUSTERED INDEX IX_OrderDetails_Quantity ON OrderDetails(Quantity);
CREATE COLUMNSTORE INDEX IX_OrderDetails_ColumnStore ON OrderDetails(ProductID, Quantity, PriceAtOrder);
"
```

**Expected Result:**  
Indexes are created successfully.

---

## [STEP 6] Analyze Query Plan with Indexes

Run the same query again and compare the execution plan:

```bash
sqlcmd -S localhost,14331 -U sa -P 'YourStrongPassword123!' -C -d ProjectDB -Q "
SET SHOWPLAN_TEXT ON;
GO
SELECT * FROM OrderDetails WHERE Quantity = 5;
GO
SET SHOWPLAN_TEXT OFF;
"
```

**Expected Result:**  
The plan should now show `Index Seek` or `Columnstore Index Scan`.

---

## [STEP 7] Compare Performance Results

Measure execution time for a simple aggregate query:

```bash
sqlcmd -S localhost,14331 -U sa -P 'YourStrongPassword123!' -C -d ProjectDB -Q "
SET STATISTICS TIME ON;
GO
SELECT SUM(Quantity) FROM OrderDetails;
GO
SET STATISTICS TIME OFF;
"
```

**Expected Result:**  
The output shows CPU time and elapsed time for the query.

---

## [STEP 8] View Trace Results and Cleanup

Read captured events from the `.xel` file and stop the session:

```bash
sqlcmd -S localhost,14331 -U sa -P 'YourStrongPassword123!' -C -Q "
SELECT event_data = CAST(event_data AS XML) 
FROM sys.fn_xe_file_target_read_file('/var/opt/mssql/backup/LabTrace*.xel', NULL, NULL, NULL);

ALTER EVENT SESSION [LabTrace] ON SERVER STATE = STOP;
DROP EVENT SESSION [LabTrace] ON SERVER;
"
```

**Expected Result:**  
Captured events are returned from the trace file, then the Extended Events session is stopped and removed.

---

**End of Lab 2.3**
