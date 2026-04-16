# Lab 1.1: Installation and Basic Configuration

This lab verifies that Docker containers and SQL Server instances are correctly deployed and operational.

---

## [STEP 1] Verify Running Instances

Execute the following command to check active SQL Server containers:

```bash
docker ps
```

**Expected Result:**  
Table output showing `sql1` and `sql2` containers with status `Up`.

---

## [STEP 2] Connection Test (Default Instance)

Connect to the first SQL Server instance and verify its name:

```bash
sqlcmd -S localhost,14331 -U sa -P 'YourStrongPassword123!' -C -Q "SELECT @@SERVERNAME"
```

**Expected Result:**  
Output displays the container ID or server name for the first instance.

---

## [STEP 3] Check Server Properties

Retrieve version, edition, and collation details through the SQL CLI:

```bash
sqlcmd -S localhost,14331 -U sa -P 'YourStrongPassword123!' -C -Q "SELECT SERVERPROPERTY('ProductVersion') AS Version, SERVERPROPERTY('Edition') AS Edition, SERVERPROPERTY('Collation') AS Collation"
```

**Expected Result:**  
List showing columns:
- Version (e.g., `16.0.x`)
- Edition (`Developer`)
- Collation (e.g., `SQL_Latin1_General_CP1_CI_AS`)

---

## [STEP 4] Stop and Start Server

Demonstrate container lifecycle operations using Docker commands:

```bash
docker stop sql1
docker ps
docker start sql1
docker ps
```

**Expected Result:**  
`sql1` disappears from the list after `stop` and re‑appears after `start`.

---

## [STEP 5] Connection Test (Named Instance)

Connect to the second SQL Server instance via its assigned host port:

```bash
sqlcmd -S localhost,14332 -U sa -P 'YourStrongPassword123!' -C -Q "SELECT @@SERVERNAME"
```

**Expected Result:**  
Output shows the server name corresponding to the second instance (`sql2`).

---

## [STEP 6] Verify Port Configuration

Confirm that the second instance listens on the correct external port mapping:

```bash
docker inspect --format='{{range $p, $conf := .NetworkSettings.Ports}}{{$p}} -> {{(index $conf 0).HostPort}}{{end}}' sql2
```

**Expected Result:**  
Displays mapping information similar to:
