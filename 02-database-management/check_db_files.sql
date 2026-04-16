SELECT 
    name AS LogicalName, 
    physical_name AS PhysicalLocation, 
    state_desc AS Status, 
    size * 8 / 1024 AS SizeMB,
    growth * 8 / 1024 AS GrowthMB
FROM sys.master_files 
WHERE database_id = DB_ID('Test');
GO
