USE AdventureWorks2022
GO

SET NOCOUNT ON
-- declare variables
DECLARE @ProductID INT
DECLARE @ProductName VARCHAR(50)
DECLARE @Color VARCHAR(50)
DECLARE @ListPrice DECIMAL(10,2)

-- Declare a cursor for a Table
DECLARE productsCR CURSOR STATIC FOR
SELECT TOP(50) 
    ProductID, 
    [Name], 
    ListPrice
FROM Production.Product

OPEN productsCR
IF @@CURSOR_ROWS > 0
BEGIN
    FETCH NEXT FROM productsCR INTO @ProductID, @ProductName, @ListPrice

    WHILE @@FETCH_STATUS = 0
    BEGIN
        PRINT ('ProductID = ' + CONVERT(VARCHAR(10), @ProductID) + ', Product Name = ' + @ProductName + ', List Price = ' + CONVERT(VARCHAR(15), @ListPrice))
        
        FETCH NEXT FROM productsCR INTO @ProductID, @ProductName, @ListPrice
    END
END

CLOSE productsCR
DEALLOCATE productsCR
GO