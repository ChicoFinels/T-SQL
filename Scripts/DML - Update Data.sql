-- Update the EmailPromotion for everyone
UPDATE [Person].[Person]
SET
    [EmailPromotion] = 1;
GO

-- Update the EmailPromotion of a single person
UPDATE [Person].[Person]
SET
    [EmailPromotion] = 0
WHERE BusinessEntityID = 1;
GO

-- Update the Title and MiddleName of a person
UPDATE [Person].[Person]
SET
    [Title] = 'Mr.', MiddleName = 'Jackson'
WHERE BusinessEntityID = 10;
GO

-- Set the EmailPromotion = 2 to everyone of Bothell
UPDATE [Person].[Person] SET EmailPromotion = 2
FROM [Person].[Person] p
INNER JOIN [Person].[BusinessEntityAddress] bea ON bea.BusinessEntityID = p.BusinessEntityID
INNER JOIN [Person].[Address] a ON a.AddressID = bea.AddressID
WHERE City = 'Bothell';
GO

-- Update sales person from US region with a bonus of 50%
WITH CTE
AS
(
    SELECT BusinessEntityID, Bonus, CountryRegionCode
    FROM [Sales].[SalesPerson] sp 
    INNER JOIN [Sales].[SalesTerritory] st ON st.TerritoryID = sp.TerritoryID
    WHERE CountryRegionCode = 'US'
)
UPDATE CTE SET Bonus += Bonus * 0.5;