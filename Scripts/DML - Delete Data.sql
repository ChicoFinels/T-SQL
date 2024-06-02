-- Create table from select statement
DROP TABLE Person.PersonDEMO;
SELECT * INTO Person.PersonDEMO FROM Person.Person;

-- Delete all rows when a person's middle name is 'J'
DELETE FROM Person.PersonDEMO 
WHERE MiddleName = 'J';

-- Delete all rows
TRUNCATE TABLE Person.PersonDEMO;

-- Delete the first 10 rows of a table
WITH CTE
AS
(
    SELECT TOP(10) * FROM Person.PersonDEMO
)
DELETE FROM CTE;