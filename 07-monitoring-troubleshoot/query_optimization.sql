USE [ProjectDB];
GO

-- 1. Наполнение таблицы OrderDetails данными (50,000 строк) для теста производительности
SET NOCOUNT ON;
DECLARE @i INT = 1;
WHILE @i <= 50000
BEGIN
    INSERT INTO OrderDetails (OrderID, ProductID, Quantity, PriceAtOrder)
    VALUES ( (ABS(CHECKSUM(NEWID())) % 5) + 1, (ABS(CHECKSUM(NEWID())) % 7) + 1, (ABS(CHECKSUM(NEWID())) % 100), 10.50);
    SET @i = @i + 1;
END;
GO

-- 2. Включение текстового плана выполнения
SET SHOWPLAN_TEXT ON;
GO

-- Запрос ДО оптимизации Columnstore индексом
SELECT ProductID, SUM(Quantity) as TotalQty 
FROM OrderDetails 
GROUP BY ProductID;
GO

SET SHOWPLAN_TEXT OFF;
GO

-- 3. Создание некластеризованного Columnstore индекса
CREATE COLUMNSTORE INDEX IX_OrderDetails_ColumnStore 
ON OrderDetails (ProductID, Quantity);
GO

-- 4. Запрос ПОСЛЕ оптимизации (сравните план выполнения)
SET SHOWPLAN_TEXT ON;
GO
SELECT ProductID, SUM(Quantity) as TotalQty 
FROM OrderDetails 
GROUP BY ProductID;
GO
SET SHOWPLAN_TEXT OFF;
GO
