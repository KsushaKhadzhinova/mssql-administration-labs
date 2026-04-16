# Environment Setup Guide

This folder contains the automation scripts required to prepare your local machine for all SQL Server administration laboratory works. The environment is based on **WSL2 (Ubuntu)**, **Docker**, and **MS SQL Server 2022**.

---

## [1] Local Repository Connection

To use these scripts, first clone your repository to your local machine:

```bash
git clone https://github.com/KsushaKhadzhinova/mssql-administration-labs.git
cd mssql-administration-labs/00-environment-setup
```

---

## [2] Infrastructure Deployment Steps

### Step 1: Prepare Windows 11 Host

Open **PowerShell as Administrator** on your Windows 11 machine and run:

```powershell
.\setup_wsl.ps1
```

**Result:**  
WSL2 is activated and Ubuntu distribution is installed. **Restart your computer** after completion.

### Step 2: Provision Linux Environment

Open your Ubuntu terminal and install Docker and SQL command-line tools:

```bash
chmod +x install_docker_tools.sh
./install_docker_tools.sh
```

**Result:**  
Docker, Docker Compose, and `sqlcmd` are ready for use.

### Step 3: Launch SQL Server Containers

Start three isolated SQL Server instances using Docker Compose:

```bash
docker-compose up -d
```

**Result:**  
Instances `sql1`, `sql2`, and `sql3` are running on host ports `14331`, `14332`, and `14333` respectively.

---

## [3] Database Initialization (ProjectDB)

After containers are healthy, initialize the **ProjectDB** schema and seed data.

### Step 4: Create Database Schema

Run the schema creation script on the primary instance (`sql1`):

```bash
sqlcmd -S localhost,14331 -U sa -P 'YourStrongPassword123!' -C -i create_project_db.sql
```

### Step 5: Populate Data

Run the seeding script to fill the tables with test data:

```bash
sqlcmd -S localhost,14331 -U sa -P 'YourStrongPassword123!' -C -i seed_project_data.sql
```

---

## [4] Verification

Confirm everything is working correctly:

```bash
sqlcmd -S localhost,14331 -U sa -P 'YourStrongPassword123!' -C -Q "SELECT COUNT(*) AS TotalProducts FROM ProjectDB.dbo.Products;"
```

**Expected Result:**  
Table output showing the count of records inserted by the seed script.

---

## [TECHNICAL NOTES]

- All SQL instances share a common backup volume at `./shared/backup`.
- **SQL Server Agent** is enabled by default in all containers for automated jobs.
- **Database Mail** is pre-configured to connect to the `mailhog` container for alert testing.

---

**Environment ready for Labs 1.1–2.3**
