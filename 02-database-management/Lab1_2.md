# Lab 1.2: Database and File Management

This lab demonstrates database creation, filegroup configuration, and schema management on both SQL Server instances.

---

## [STEP 1] Database Creation on Default Instance (sql1)

Connect to the first instance and create a database **Test** with specific file parameters:

```bash
sqlcmd -S localhost,14331 -U sa -P 'YourStrongPassword123!' -C -Q "
CREATE DATABASE Test
ON PRIMARY (
    NAME = testdata_a,
    FILENAME = '/var/opt/mssql/data/testdata_a.mdf',
    SIZE = 4MB,
    MAXSIZE = 10MB,
    FILEGROWTH = 2MB
);
"
```

**Expected Result:**  
Message `Commands completed successfully.`

---

## [STEP 2] Filegroup and Secondary File Setup

Add a new filegroup and a secondary NDF file to the **Test** database:

```bash
sqlcmd -S localhost,14331 -U sa -P 'YourStrongPassword123!' -C -Q "
ALTER DATABASE Test ADD FILEGROUP TestFileGroup;
ALTER DATABASE Test ADD FILE (
    NAME = testdata_b,
    FILENAME = '/var/opt/mssql/data/testdata_b.ndf',
    SIZE = 5MB,
    MAXSIZE = UNLIMITED,
    FILEGROWTH = 2MB
) TO FILEGROUP TestFileGroup;
"
```

**Expected Result:**  
Confirmation of database modification.

---

## [STEP 3] Verify File Configuration

Check physical file locations and growth parameters:

```bash
sqlcmd -S localhost,14331 -U sa -P 'YourStrongPassword123!' -C -Q "
SELECT name, physical_name, size*8/1024 AS SizeMB, growth 
FROM sys.master_files 
WHERE database_id = DB_ID('Test');
"
```

**Expected Result:**  
Table listing:
- `testdata_a.mdf`
- `testdata_b.ndf`  
with paths under `/var/opt/mssql/data/`.

---

## [STEP 4] Database Creation on Named Instance (sql2)

Connect to the second instance and create a database using your initials:

```bash
sqlcmd -S localhost,14332 -U sa -P 'YourStrongPassword123!' -C -Q "
CREATE DATABASE Test_JD;
"
```

**Expected Result:**  
New database `Test_JD` is created.

---

## [STEP 5] Schema and Table Operations (sql2)

Create schemas, tables, and a user with assigned ownership:

```bash
sqlcmd -S localhost,14332 -U sa -P 'YourStrongPassword123!' -C -d Test_JD -Q "
CREATE SCHEMA CustomSchema;
GO
CREATE TABLE CustomSchema.TABLE_1 (ID INT PRIMARY KEY, Data NVARCHAR(50));
GO
ALTER DATABASE Test_JD ADD FILEGROUP TestFileGroup;
ALTER DATABASE Test_JD ADD FILE (
    NAME = Test_JD_Secondary, 
    FILENAME = '/var/opt/mssql/data/test_jd_sec.ndf'
) TO FILEGROUP TestFileGroup;
GO
CREATE TABLE CustomSchema.TABLE_2 (ID INT) ON TestFileGroup;
GO
CREATE USER OtherUser WITHOUT LOGIN;
GO
CREATE SCHEMA OtherOwnerSchema AUTHORIZATION OtherUser;
GO
CREATE TABLE OtherOwnerSchema.TABLE_3 (ID INT);
"
```

**Expected Result:**  
Multiple batches executed successfully — creation of schemas, tables, and user confirmed.

---

## [STEP 6] Final Verification

Verify the existence of schemas and their corresponding owners:

```bash
sqlcmd -S localhost,14332 -U sa -P 'YourStrongPassword123!' -C -d Test_JD -Q "
SELECT s.name AS SchemaName, u.name AS OwnerName 
FROM sys.schemas s 
JOIN sys.sysusers u ON s.principal_id = u.uid;
"
```

**Expected Result:**  
Result set includes:
- `CustomSchema` — owner `dbo` or `sa`
- `OtherOwnerSchema` — owner `OtherUser`

---

**End of Lab 1.2**
