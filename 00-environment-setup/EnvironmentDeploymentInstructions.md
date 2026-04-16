# Environment Deployment Instructions for Lab Works

This document explains how to deploy and configure the environment for Labs 1.1–2.3, including WSL2, Docker, and SQL Server instances.

---

## [STEP 1] Windows 11 Preparation (PowerShell)

Run **PowerShell as Administrator** and execute the following commands:

```powershell
dism.exe /online /enable-feature /featurename:Microsoft-Windows-Subsystem-Linux /all /norestart
dism.exe /online /enable-feature /featurename:VirtualMachinePlatform /all /norestart
wsl --set-default-version 2
wsl --install -d Ubuntu
```

**Action:**  
Restart your computer after execution.  
After rebooting, the Ubuntu console will open — set your username and password.

---

## [STEP 2] Docker and Tools Installation in Linux (Bash)

Run the following commands inside the Ubuntu console:

```bash
sudo apt-get update
sudo apt-get install -y ca-certificates curl gnupg lsb-release docker.io docker-compose
sudo systemctl enable docker
sudo systemctl start docker
```

Add Microsoft package repository and install SQL Server Tools:

```bash
curl https://packages.microsoft.com/keys/microsoft.asc | sudo tee /etc/apt/trusted.gpg.d/microsoft.asc
curl https://packages.microsoft.com/config/ubuntu/$(lsb_release -rs)/prod.list | sudo tee /etc/apt/sources.list.d/mssql-release.list
sudo apt-get update
sudo ACCEPT_EULA=Y apt-get install -y mssql-tools18 unixodbc-dev
echo 'export PATH="$PATH:/opt/mssql-tools18/bin"' >> ~/.bashrc
source ~/.bashrc
```

**Result:**  
Commands `docker --version` and `sqlcmd` should return valid responses.

---

## [STEP 3] Container Deployment (Docker Compose)

Create a working directory and configure three containers (for HA/DR and replication):

```bash
mkdir ~/mssql_labs && cd ~/mssql_labs
mkdir -p volumes/sql1/data volumes/sql2/data volumes/sql3/data shared/backup
```

Create the `docker-compose.yml` file:

```yaml
version: '3.8'
services:
  sql1:
    image: mcr.microsoft.com/mssql/server:2022-latest
    container_name: sql1
    environment:
      - ACCEPT_EULA=Y
      - MSSQL_SA_PASSWORD=YourStrongPassword123!
      - MSSQL_AGENT_ENABLED=True
    ports:
      - "14331:1433"
    volumes:
      - ./volumes/sql1/data:/var/opt/mssql
      - ./shared/backup:/var/opt/mssql/backup

  sql2:
    image: mcr.microsoft.com/mssql/server:2022-latest
    container_name: sql2
    environment:
      - ACCEPT_EULA=Y
      - MSSQL_SA_PASSWORD=YourStrongPassword123!
      - MSSQL_AGENT_ENABLED=True
    ports:
      - "14332:1433"
    volumes:
      - ./volumes/sql2/data:/var/opt/mssql
      - ./shared/backup:/var/opt/mssql/backup

  sql3:
    image: mcr.microsoft.com/mssql/server:2022-latest
    container_name: sql3
    environment:
      - ACCEPT_EULA=Y
      - MSSQL_SA_PASSWORD=YourStrongPassword123!
      - MSSQL_AGENT_ENABLED=True
    ports:
      - "14333:1433"
    volumes:
      - ./volumes/sql3/data:/var/opt/mssql
      - ./shared/backup:/var/opt/mssql/backup
```

Start all servers:

```bash
sudo docker-compose up -d
```

**Result:**  
Command `sudo docker ps` should list 3 running containers.

---

## [STEP 4] ProjectDB Database Creation (T‑SQL)

Connect to SQL1 and create the **ProjectDB** database with 7 tables:

```bash
sqlcmd -S localhost,14331 -U sa -P 'YourStrongPassword123!' -C
```

Paste the following SQL commands into the terminal:

```sql
CREATE DATABASE ProjectDB;
GO
USE ProjectDB;
GO

CREATE TABLE Categories (
    CategoryID INT PRIMARY KEY IDENTITY(1,1),
    CategoryName NVARCHAR(100) NOT NULL
);

CREATE TABLE Suppliers (
    SupplierID INT PRIMARY KEY IDENTITY(1,1),
    SupplierName NVARCHAR(150) NOT NULL,
    ContactEmail VARCHAR(100)
);

CREATE TABLE Products (
    ProductID INT PRIMARY KEY IDENTITY(1,1),
    ProductName NVARCHAR(200) NOT NULL,
    CategoryID INT FOREIGN KEY REFERENCES Categories(CategoryID),
    SupplierID INT FOREIGN KEY REFERENCES Suppliers(SupplierID),
    UnitPrice DECIMAL(18,2)
);

CREATE TABLE Stocks (
    StockID INT PRIMARY KEY IDENTITY(1,1),
    ProductID INT FOREIGN KEY REFERENCES Products(ProductID),
    Quantity INT DEFAULT 0,
    WarehouseLocation NVARCHAR(50)
);

CREATE TABLE Customers (
    CustomerID INT PRIMARY KEY IDENTITY(1,1),
    FullName NVARCHAR(200) NOT NULL,
    RegistrationDate DATETIME DEFAULT GETDATE()
);

CREATE TABLE Orders (
    OrderID INT PRIMARY KEY IDENTITY(1,1),
    CustomerID INT FOREIGN KEY REFERENCES Customers(CustomerID),
    OrderDate DATETIME DEFAULT GETDATE(),
    TotalAmount DECIMAL(18,2)
);

CREATE TABLE OrderDetails (
    DetailID INT PRIMARY KEY IDENTITY(1,1),
    OrderID INT FOREIGN KEY REFERENCES Orders(OrderID),
    ProductID INT FOREIGN KEY REFERENCES Products(ProductID),
    Quantity INT,
    PriceAtOrder DECIMAL(18,2)
);
GO

INSERT INTO Categories (CategoryName) VALUES ('Electronics'), ('Office');
INSERT INTO Suppliers (SupplierName) VALUES ('Global Trade Inc'), ('Main Distro');
GO
```

**Result:**  
Database `ProjectDB` with all 7 tables is created and ready for Lab 1.1 and following tasks.

---

## [FIRST INSTANCE LAUNCH AND VERIFICATION]

Check the SQL Server instances:

```bash
# Connect to SQL1
sqlcmd -S localhost,14331 -U sa -P 'YourStrongPassword123!' -C -Q "SELECT @@SERVERNAME; SELECT @@VERSION;"

# Connect to SQL2
sqlcmd -S localhost,14332 -U sa -P 'YourStrongPassword123!' -C -Q "SELECT @@SERVERNAME;"
```

---

**End of Deployment Instructions**
