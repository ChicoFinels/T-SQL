USE AdventureWorks2022
GO
CREATE OR ALTER VIEW Sales.vSalesPersonsTotal
AS
SELECT 
    FirstName [First Name],
    LastName [Last Name], 
    COUNT(TotalDue) [Number of Sales], 
    FORMAT(SUM(TotalDue), 'C') [Total Sales Amount], 
    FORMAT(AVG(TotalDue), 'C') [Average Sales Amount],
    FORMAT(MIN(TotalDue), 'C') [Lowest Sales Amount],
    FORMAT(MAX(TotalDue), 'C') [Highest Sales Amount]
FROM [Sales].[SalesPerson] sp
INNER JOIN [Person].[Person] p ON p.BusinessEntityID = sp.BusinessEntityID
INNER JOIN [Sales].[SalesOrderHeader] soh ON soh.SalesPersonID = p.BusinessEntityID
GROUP BY FirstName, LastName;
GO
DROP VIEW Sales.vSalesPersonsTotal