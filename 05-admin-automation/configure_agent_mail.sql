EXEC sp_configure 'show advanced options', 1;
RECONFIGURE;
EXEC sp_configure 'Database Mail XPs', 1;
RECONFIGURE;
GO
EXECUTE msdb.dbo.sysmail_add_profile_sp @profile_name = 'AdminProfile';
EXECUTE msdb.dbo.sysmail_add_account_sp
    @account_name = 'AdminAccount',
    @email_address = 'kseniyakhadzhynava@gmail.com',
    @mailserver_name = 'mailhog',
    @port = 1025;
EXECUTE msdb.dbo.sysmail_add_profileaccount_sp
    @profile_name = 'AdminProfile',
    @account_name = 'AdminAccount',
    @sequence_number = 1;
EXEC msdb.dbo.sp_add_operator 
    @name = N'DBA_Admin', 
    @enabled = 1, 
    @email_address = N'kseniyakhadzhynava@gmail.com';
GO
