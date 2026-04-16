USE ProjectDB;
GO
INSERT INTO Categories (CategoryName) VALUES ('Electronics'), ('Laptops'), ('Peripherals'), ('Software'), ('Storage'), ('Networking'), ('Accessories');
INSERT INTO Suppliers (SupplierName, ContactEmail) VALUES ('TechSupply Corp', 'sales@techsupply.com'), ('Global Components', 'info@globalcomp.com'), ('DataSystems Ltd', 'support@datasystems.net');
INSERT INTO Products (ProductName, CategoryID, SupplierID, UnitPrice) VALUES ('ThinkPad X1', 2, 1, 1500.00), ('Monitor 27-inch', 3, 2, 300.00), ('Mechanical Keyboard', 3, 1, 120.00), ('SSD 1TB', 5, 2, 100.00), ('Router AX6000', 6, 3, 250.00), ('SQL Server License', 4, 3, 2000.00), ('USB-C Hub', 7, 1, 50.00);
INSERT INTO Stocks (ProductID, Quantity, WarehouseLocation) VALUES (1, 10, 'A1-Row1'), (2, 25, 'B2-Row3'), (3, 50, 'A1-Row2'), (4, 100, 'C3-Row1'), (5, 15, 'D4-Row2'), (6, 999, 'Digital'), (7, 40, 'A1-Row5');
INSERT INTO Customers (FullName) VALUES ('Alice Johnson'), ('Bob Smith'), ('Charlie Davis'), ('Diana Prince'), ('Evan Wright');
INSERT INTO Orders (CustomerID, TotalAmount) VALUES (1, 1620.00), (2, 300.00), (3, 120.00), (4, 2100.00), (5, 50.00);
INSERT INTO OrderDetails (OrderID, ProductID, Quantity, PriceAtOrder) VALUES (1, 1, 1, 1500.00), (1, 3, 1, 120.00), (2, 2, 1, 300.00), (3, 3, 1, 120.00), (4, 6, 1, 2000.00), (4, 4, 1, 100.00), (5, 7, 1, 50.00);
GO
