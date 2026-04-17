# Lab 1.2: Database and File Management

This lab demonstrates database creation, filegroup configuration, and schema management on both SQL Server instances.

---

## STEP 1: Database Creation on Default Instance (sql1)

Connect to the first instance and create database **Test** with specific file parameters:

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

**Expected Result:** `Commands completed successfully.`

---

## STEP 2: Filegroup and Secondary File Setup

Add new filegroup and secondary NDF file to `Test` database:

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

**Expected Result:** Confirmation of database modification.

---

## STEP 3: Verify File Configuration

Check physical file locations and growth parameters:

```bash
sqlcmd -S localhost,14331 -U sa -P 'YourStrongPassword123!' -C -Q "
SELECT name, physical_name, size*8/1024 AS SizeMB, growth 
FROM sys.master_files 
WHERE database_id = DB_ID('Test');
"
```

**Expected Result:** Table listing `testdata_a.mdf` and `testdata_b.ndf` under `/var/opt/mssql/data/`.

---

## STEP 4: Database Creation on Named Instance (sql2)

Create database using initials:

```bash
sqlcmd -S localhost,14332 -U sa -P 'YourStrongPassword123!' -C -Q "
CREATE DATABASE Test_KK;
"
```

**Expected Result:** `Test_KK` database created.

---

## STEP 5: Schema and Table Operations (sql2)

Create schemas, tables, and user with ownership:

```bash
sqlcmd -S localhost,14332 -U sa -P 'YourStrongPassword123!' -C -d Test_KK -Q "
CREATE SCHEMA CustomSchema;
GO
CREATE TABLE CustomSchema.TABLE_1 (ID INT PRIMARY KEY, Data NVARCHAR(50));
GO
ALTER DATABASE Test_KK ADD FILEGROUP TestFileGroup;
ALTER DATABASE Test_KK ADD FILE (
    NAME = Test_KK_Secondary, 
    FILENAME = '/var/opt/mssql/data/test_kk_sec.ndf'
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

**Expected Result:** Schemas, tables, and user created successfully.

---

## STEP 6: Final Verification

Verify schemas and owners:

```bash
sqlcmd -S localhost,14332 -U sa -P 'YourStrongPassword123!' -C -d Test_KK -Q "
SELECT s.name AS SchemaName, u.name AS OwnerName 
FROM sys.schemas s 
JOIN sys.database_principals u ON s.principal_id = u.principal_id;
"
```

**Expected Result:**
- `CustomSchema` — owner `dbo` or `sa`
- `OtherOwnerSchema` — owner `OtherUser`
