-- 1. Enable Advanced Options and Database Mail
EXEC sp_configure 'show advanced options', 1;
RECONFIGURE;
EXEC sp_configure 'Database Mail XPs', 1;
RECONFIGURE;
GO

-- 2. Create a Database Mail Profile
EXECUTE msdb.dbo.sysmail_add_profile_sp
    @profile_name = 'AdminProfile',
    @description = 'Profile for administrative alerts';

-- 3. Create an account for the mail server (using a dummy SMTP for lab purposes)
EXECUTE msdb.dbo.sysmail_add_account_sp
    @account_name = 'AdminAccount',
    @description = 'Account for sending alerts',
    @email_address = 'kseniyakhadzhynava@gmail.com',
    @display_name = 'SQL Server Automation',
    @mailserver_name = 'localhost'; -- In production, use your SMTP server

-- 4. Add the account to the profile
EXECUTE msdb.dbo.sysmail_add_profileaccount_sp
    @profile_name = 'AdminProfile',
    @account_name = 'AdminAccount',
    @sequence_number = 1;

-- 5. Create an Operator to receive notifications
EXEC msdb.dbo.sp_add_operator 
    @name = N'DBA_Admin', 
    @enabled = 1, 
    @email_address = N'xju2005@gmail.com';
GO
