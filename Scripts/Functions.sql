USE AdventureWorks2022
GO

-- Create a function that returns the average sales for an given year
CREATE FUNCTION ufnGetAverageSalesForYear
(
    -- Parameters
    @Year INT
)
RETURNS DECIMAL(10,2)
AS
BEGIN
    -- Declare the return variable
    DECLARE @AverageSalesAmount DECIMAL(10,2)

    -- T-SQL statement
    SELECT @AverageSalesAmount = AVG(TotalDue)
    FROM Sales.SalesOrderHeader
    WHERE YEAR(OrderDate) = @Year

    -- Return the result
    RETURN @AverageSalesAmount
END
GO

-- For testing purposes
DECLARE @Year INT = 2012;
SELECT dbo.ufnGetAverageSalesForYear(@Year) [Average Sales], TotalDue
FROM Sales.SalesOrderHeader
WHERE YEAR(OrderDate) = @Year;
GO

-- Create a function that returns the products with inventory greather than a given value 
CREATE FUNCTION ufnGetProductsWithInventoryGreatherThan(@count INT)
RETURNS TABLE
AS
RETURN
    SELECT 
        p.Name,
        pi.Quantity
    FROM Production.Product p 
    INNER JOIN Production.ProductInventory pi ON pi.ProductID = p.ProductID
    WHERE pi.Quantity >= @count
GO

-- For testing purposes
SELECT * FROM dbo.ufnGetProductsWithInventoryGreatherThan(800);