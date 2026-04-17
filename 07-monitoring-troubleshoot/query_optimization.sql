USE [ProjectDB];
GO

SET NOCOUNT ON;
DECLARE @i INT = 1;
WHILE @i <= 60000
BEGIN
    INSERT INTO OrderDetails (OrderID, ProductID, Quantity, PriceAtOrder)
    VALUES (1, 1, @i % 10 + 1, 100.00);
    SET @i = @i + 1;
END;
GO

SET SHOWPLAN_TEXT ON;
GO

SELECT ProductID, SUM(Quantity) AS TotalQty 
FROM OrderDetails 
GROUP BY ProductID;
GO

SET SHOWPLAN_TEXT OFF;
GO

CREATE COLUMNSTORE INDEX IX_OrderDetails_ColumnStore 
ON OrderDetails (ProductID, Quantity, PriceAtOrder);
GO

SET SHOWPLAN_TEXT ON;
GO

SELECT ProductID, SUM(Quantity) AS TotalQty 
FROM OrderDetails 
GROUP BY ProductID;
GO

SET SHOWPLAN_TEXT OFF;
GO

SET STATISTICS TIME ON;
GO

SELECT SUM(Quantity) FROM OrderDetails;
GO

SET STATISTICS TIME OFF;
GO
