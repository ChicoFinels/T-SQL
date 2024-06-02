-- Declare a variable and print it's value
DECLARE @tempMessage VARCHAR(100);
SELECT @tempMessage = 'Test';
PRINT @tempMessage;

-- Example 1
DECLARE @Multiplier INT = 10;
SELECT
    p.FirstName [First Name],
    p.LastName [Last Name],
    COUNT(TotalDue) * @Multiplier [Total Sales Amount],
    AVG(TotalDue) * @Multiplier [Average Sales Amount],
    MIN(TotalDue) * @Multiplier [Lowest Sales Amount],
    MAX(TotalDue) * @Multiplier [Highest Sales Amount]
FROM [Sales].[SalesPerson] sp
INNER JOIN Person.Person p ON p.BusinessEntityID = sp.BusinessEntityID
INNER JOIN Sales.SalesOrderHeader soh ON soh.SalesPersonID = sp.BusinessEntityID
GROUP BY p.FirstName, p.LastName;

-- Example 2
DECLARE @HighestSaleFigure DECIMAL(10,2);
SELECT TOP (1)
    @HighestSaleFigure = MAX(TotalDue)
FROM [Sales].[SalesPerson] sp
INNER JOIN Person.Person p ON p.BusinessEntityID = sp.BusinessEntityID
INNER JOIN Sales.SalesOrderHeader soh ON soh.SalesPersonID = sp.BusinessEntityID
GROUP BY p.FirstName, p.LastName
ORDER BY MAX(TotalDue) DESC;

PRINT @HighestSaleFigure;