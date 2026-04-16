# Lab 1.4: Security Management

This lab covers SQL logins, database users, roles, permissions, schema ownership, and verification of access restrictions.

---

## [STEP 1] Create Logins and Server Role Assignment

Connect to the first instance and create SQL logins with the required privileges:

```bash
sqlcmd -S localhost,14331 -U sa -P 'YourStrongPassword123!' -C -Q "
CREATE LOGIN TestLogin1 WITH PASSWORD = 'TestPassword123!', CHECK_POLICY = OFF;
ALTER SERVER ROLE sysadmin ADD MEMBER TestLogin1;
ALTER LOGIN TestLogin1 WITH DEFAULT_DATABASE = Test;
CREATE LOGIN TestLogin2 WITH PASSWORD = 'TestPassword123!', CHECK_POLICY = OFF;
"
```

**Expected Result:**  
`TestLogin1` is added to `sysadmin`, and both logins are created successfully.

---

## [STEP 2] Create Users and Database Roles

Configure users in the `Test` database and set up hierarchical roles:

```bash
sqlcmd -S localhost,14331 -U sa -P 'YourStrongPassword123!' -C -d Test -Q "
CREATE USER TestUser1 FOR LOGIN TestLogin1;
CREATE USER TestUser2 FOR LOGIN TestLogin2;
CREATE ROLE Manager;
CREATE ROLE Employee;
ALTER ROLE Manager ADD MEMBER TestUser1;
ALTER ROLE Employee ADD MEMBER TestUser2;
"
```

**Expected Result:**  
Users and roles are created, and role membership is assigned.

---

## [STEP 3] Configure Permissions and Restrictions

Apply `DENY` restrictions for the `Employee` role and a new restricted role:

```bash
sqlcmd -S localhost,14331 -U sa -P 'YourStrongPassword123!' -C -d Test -Q "
DENY ALTER ON USER::guest TO Employee;
CREATE ROLE ReadOnlyNoUpdate;
DENY UPDATE TO ReadOnlyNoUpdate;
"
```

**Expected Result:**  
`DENY` permissions are applied to the specified roles.

---

## [STEP 4] Task 4.1 - Custom Schema and Table

Create a schema authorized by `TestUser1` and a table within it:

```bash
sqlcmd -S localhost,14331 -U sa -P 'YourStrongPassword123!' -C -d Test -Q "
CREATE SCHEMA SecureSchema AUTHORIZATION TestUser1;
CREATE TABLE SecureSchema.PrivateData (ID INT, Info NVARCHAR(100));
"
```

**Expected Result:**  
Schema `SecureSchema` and table `PrivateData` are created successfully.

---

## [STEP 5] Task 4.2 - Multi-user Restrictions

Add more users to the `Manager` role and deny `SELECT` access in different ways:

```bash
sqlcmd -S localhost,14331 -U sa -P 'YourStrongPassword123!' -C -d Test -Q "
CREATE USER User1 WITHOUT LOGIN;
CREATE USER User2 WITHOUT LOGIN;
ALTER ROLE Manager ADD MEMBER User1;
ALTER ROLE Manager ADD MEMBER User2;
DENY SELECT ON OBJECT::SecureSchema.PrivateData TO User1;
DENY SELECT ON SCHEMA::SecureSchema TO User2;
"
```

**Expected Result:**  
Users are added to `Manager`, and `SELECT` is denied at both object and schema level.

---

## [STEP 6] Verify Permissions

Check active database permissions:

```bash
sqlcmd -S localhost,14331 -U sa -P 'YourStrongPassword123!' -C -d Test -Q "
SELECT grantee_principal_id, permission_name, state_desc, class_desc 
FROM sys.database_permissions 
WHERE state_desc = 'DENY';
"
```

**Expected Result:**  
A table showing `DENY` states for `SELECT`, `UPDATE`, and `ALTER` permissions across object, schema, and database classes.

---

## [STEP 7] Final Login Test

Try connecting with the new `TestLogin1` account:

```bash
sqlcmd -S localhost,14331 -U TestLogin1 -P 'TestPassword123!' -C -Q "SELECT DB_NAME() AS CurrentDB, SUSER_SNAME() AS LoginName"
```

**Expected Result:**  
`CurrentDB` shows `Test`, and `LoginName` shows `TestLogin1`.

---

**End of Lab 1.4**
