USE AdventureWorks2022

-- Select all data from a table
SELECT * FROM Person.Person;

-- Select top 10 records from the table
SELECT TOP(10) * FROM Person.Person;

-- Select specific columns from the table
SELECT BusinessEntityID, FirstName, LastName FROM Person.Person;

-- Select only persons who are Marketing Assistants
SELECT * FROM HumanResources.Employee
WHERE JobTitle = 'Marketing Assistant';

-- Select only the employee with the id 20
SELECT * FROM HumanResources.Employee
WHERE BusinessEntityID = 20;

-- Select male marketing assistants
SELECT * FROM HumanResources.Employee
WHERE JobTitle = 'Marketing Assistant' AND Gender = 'M';

-- Select all employees sorted by hire date
SELECT * FROM HumanResources.Employee
ORDER BY HireDate DESC;

--Select all records with the word "Marketing" in the job title
SELECT * FROM HumanResources.Employee
WHERE JobTitle LIKE '%Marketing%';

-- Select data with alised columns
SELECT 
    BusinessEntityID AS Id, 
    FirstName [First Name], 
    LastName [Last Name]
FROM Person.Person;

-- Select all employees and the departments that they represent
SELECT 
    FirstName + ' ' + LastName [Full Name],
    JobTitle [Job Title],
    HireDate [Hire Date],
    d.Name [Department]
FROM [HumanResources].[Employee] e
INNER JOIN [HumanResources].[EmployeeDepartmentHistory] edh ON e.BusinessEntityID = edh.BusinessEntityID
INNER JOIN [HumanResources].[Department] d ON d.DepartmentID = edh.DepartmentID
INNER JOIN [Person].[Person] p ON p.BusinessEntityID = e.BusinessEntityID;

-- Select work orders, the product and their scrap reason
SELECT 
    p.Name [Product Name],
    p.ProductNumber [Product Number],
    wo.OrderQty [Order Qty],
    wo.StockedQty [Stocked Qty],
    sr.Name [Scrap Reason]
FROM [Production].[Product] p
INNER JOIN [Production].[WorkOrder] wo ON wo.ProductID = p.ProductID
LEFT JOIN [Production].[ScrapReason] sr ON sr.ScrapReasonID = wo.ScrapReasonID;

-- Select all customers and employees into one data set
SELECT FirstName
FROM [HumanResources].[Employee] e
INNER JOIN [Person].[Person] p ON p.BusinessEntityID = e.BusinessEntityID
UNION
SELECT FirstName
FROM [Sales].[Customer] c 
INNER JOIN [Person].[Person] p ON p.BusinessEntityID = c.PersonID;

-- Eliminate all duplicated names from the Customer table
SELECT DISTINCT FirstName, LastName
FROM [Sales].[Customer] c 
INNER JOIN [Person].[Person] p ON p.BusinessEntityID = c.PersonID;

SELECT FirstName, LastName
FROM [Sales].[Customer] c 
INNER JOIN [Person].[Person] p ON p.BusinessEntityID = c.PersonID
GROUP BY FirstName, LastName;

-- Find the number of customers with the same first name
SELECT FirstName, COUNT(FirstName)
FROM [Sales].[Customer] c 
INNER JOIN [Person].[Person] p ON p.BusinessEntityID = c.PersonID
GROUP BY FirstName
HAVING COUNT(FirstName) > 1
ORDER BY FirstName;

-- Find total, average, lowest and highest amounts for sales
SELECT 
    SUM(TotalDue) [Total Sales Amount], 
    AVG(TotalDue) [Average Sales Amount],
    MIN(TotalDue) [Lowest Sales Amount],
    MAX(TotalDue) [Highest Sales Amount] 
FROM [Sales].[SalesOrderHeader];

-- Find total, average, lowest and highest amounts for sales per salesperson
SELECT 
    FirstName + ' ' + LastName [Full Name], 
    COUNT(TotalDue) [Number of Sales], 
    FORMAT(SUM(TotalDue), 'C') [Total Sales Amount], 
    FORMAT(AVG(TotalDue), 'C') [Average Sales Amount],
    FORMAT(MIN(TotalDue), 'C') [Lowest Sales Amount],
    FORMAT(MAX(TotalDue), 'C') [Highest Sales Amount]
FROM [Sales].[SalesPerson] sp
INNER JOIN [Person].[Person] p ON p.BusinessEntityID = sp.BusinessEntityID
INNER JOIN [Sales].[SalesOrderHeader] soh ON soh.SalesPersonID = p.BusinessEntityID
GROUP BY FirstName, LastName
ORDER BY FirstName, LastName;

-- Employees who have more vacation available than the average
SELECT BusinessEntityID, JobTitle, VacationHours
FROM [HumanResources].[Employee]
WHERE VacationHours > (SELECT AVG(VacationHours) FROM [HumanResources].[Employee]);

-- Employees who have more vacation available than the average per job title
SELECT BusinessEntityID, e.JobTitle, VacationHours, tab.[AverageVacation]
FROM [HumanResources].[Employee] e
JOIN (SELECT JobTitle, AVG(VacationHours) AverageVacation FROM [HumanResources].[Employee] GROUP BY JobTitle) tab ON tab.JobTitle = e.JobTitle
WHERE VacationHours > AverageVacation;

-- Find the total number of sales orders per year of each sales person
WITH Sales_CTE
AS
(
    SELECT SalesPersonID, SalesOrderID, YEAR(OrderDate) SalesYear
    FROM [Sales].[SalesOrderHeader]
    WHERE SalesPersonID IS NOT NULL
)
SELECT SalesPersonID, COUNT(SalesOrderID) TotalSales, SalesYear
FROM Sales_CTE
GROUP BY SalesPersonID, SalesYear
ORDER BY SalesPersonID, SalesYear;

-- Find the maximum sale price
SELECT 
    SalesOrderID, 
    OrderQty, 
    UnitPrice,
    MAX(UnitPrice) OVER() MaxPrice
FROM [Sales].[SalesOrderDetail];

-- Find the maximum sale price per sales order
SELECT 
    SalesOrderID, 
    OrderQty, 
    UnitPrice,
    MAX(UnitPrice) OVER(PARTITION BY SalesOrderID) MaxPrice
FROM [Sales].[SalesOrderDetail];

-- Find the sum sale price per sales order
SELECT 
    SalesOrderID, 
    OrderQty, 
    UnitPrice,
    SUM(UnitPrice) OVER(PARTITION BY SalesOrderID) Total
FROM [Sales].[SalesOrderDetail];

-- Assign a number two each row of the result
-- Rank employee by vacation hours in the department
SELECT 
    BusinessEntityID, 
    JobTitle, 
    VacationHours,
    ROW_NUMBER() OVER(ORDER BY JobTitle) RowNumber,
    RANK() OVER(PARTITION BY JobTitle ORDER BY VacationHours) Rank,
    DENSE_RANK() OVER(PARTITION BY JobTitle ORDER BY VacationHours) DenseRank
FROM [HumanResources].[Employee];

-- Find the next/previous stock level that will be coming up
SELECT 
    ProductID,
    [Name],
    ProductNumber,
    SafetyStockLevel,
    LEAD(SafetyStockLevel, 1, 0) OVER(ORDER BY ProductID) NextStockLevel,
    LAG(SafetyStockLevel, 1, 0) OVER(ORDER BY ProductID) PrevStockLevel
FROM Production.Product;

-- Replace null values
SELECT TOP (10)
    ISNULL([Title], '') Title,
    [FirstName],
    COALESCE([MiddleName], 'N/A') MiddleName,
    [LastName]
FROM [Person].[Person];