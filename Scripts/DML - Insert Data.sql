-- Insert new currency - Cayman Dollar
INSERT INTO [Sales].[Currency]
(
    [CurrencyCode],
    [Name],
    [ModifiedDate]
)
VALUES
(
    'KYD',
    'Cayman Dollar',
    GETDATE()
);
GO

-- Insert new currency - Bitcoin
INSERT INTO [Sales].[Currency]
VALUES
(
    'BTC',
    'Bitcoin',
    GETDATE()
);
GO

-- Insert several crypto currency symbols
INSERT INTO [Sales].[Currency]
VALUES
(
    'ETH', 'Ethereum', GETDATE()
),
(
    'BCH', 'Bitcoin Cash', GETDATE()
),
(
    'BNB', 'BNB', GETDATE()
);
GO

-- Insert new currency - Litecoin
INSERT INTO [Sales].[Currency]
(
    [CurrencyCode],
    [Name]
)
VALUES
(
    'LTC',
    'Litecoin'
);
GO

-- Insert new CountryRegionCurrency - Cayman Islands
INSERT INTO [Sales].[CountryRegionCurrency]
(
    [CountryRegionCode],
    [CurrencyCode]
)
VALUES
(
    'KY',
    'KYD'
);
GO

-- Insert new sales territory - Jamaica
INSERT INTO [Sales].[SalesTerritory]
(
    [Name],
    [CountryRegionCode],
    [Group],
    [rowguid]
)
VALUES
(
    'Jamaica',
    'JM',
    'Latam',
    NEWID()
);
GO

-- Create a backup copy of PurchaseOrderDetail table
SELECT * INTO [Purchasing].[PurchaseOrderDetailBackup] 
FROM [Purchasing].[PurchaseOrderDetail];
GO

-- Create a backup copy of PurchaseOrderDetail table but only of specific columns
SELECT PurchaseOrderID, EmployeeID, OrderDate, TotalDue INTO [Purchasing].[PurchaseOrders2024] 
FROM [Purchasing].[PurchaseOrderHeader];
GO

-- Create a new empty table based on the PurchaseOrderDetail table
SELECT * INTO [Purchasing].[PurchaseOrderDetailNew] 
FROM [Purchasing].[PurchaseOrderDetail]
WHERE 1 = 0;
GO

-- Create new database and select into a table from this database
USE master
CREATE DATABASE AdventureWorks2024
GO
USE AdventureWorks2022
SELECT * INTO AdventureWorks2024.dbo.PurchaseOrderDetail
FROM Purchasing.PurchaseOrderDetail;
GO