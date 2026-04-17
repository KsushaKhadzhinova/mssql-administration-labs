USE [msdb];
GO

EXEC msdb.dbo.sp_add_alert 
    @name = N'Critical I/O Error 823', 
    @message_id = 823, 
    @severity = 0, 
    @enabled = 1, 
    @delay_between_responses = 60, 
    @include_event_description_in = 1, 
    @job_id = N'00000000-0000-0000-0000-000000000000';

EXEC msdb.dbo.sp_add_notification 
    @alert_name = N'Critical I/O Error 823', 
    @operator_name = N'DBA_Admin', 
    @notification_method = 1;
GO
