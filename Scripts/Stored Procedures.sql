-- Create a stored procedure that retrieves the information of a person with a given BussinessEntityID and PersonType
CREATE OR ALTER PROCEDURE sp_PersonDetails
    @bussinessEntityID int,
    @personType VARCHAR(5)
AS
BEGIN
    SELECT BusinessEntityID, PersonType, FirstName, LastName FROM Person.Person
    WHERE BusinessEntityID = @bussinessEntityID AND PersonType = @personType
END
GO
EXECUTE sp_PersonDetails 200, 'EM'
GO

-- Create a stored procedure that retrieves the highest BussinessEntityID of a person
CREATE OR ALTER PROCEDURE sp_FindMaxPerson
    @result int OUTPUT
AS
BEGIN
    SELECT @result = MAX(BusinessEntityID) FROM Person.Person;
END
GO
DECLARE @result INT;
EXECUTE sp_FindMaxPerson @result OUTPUT;
PRINT(@result);
GO
