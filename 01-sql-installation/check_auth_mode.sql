SELECT 
    CASE SERVERPROPERTY('IsIntegratedSecurityOnly')   
        WHEN 1 THEN 'Windows Authentication'   
        WHEN 0 THEN 'Mixed Mode'   
    END AS AuthenticationMode;
GO
