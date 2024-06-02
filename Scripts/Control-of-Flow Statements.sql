USE AdventureWorks2022
GO

-- Evaluate a number
BEGIN
    DECLARE @ID INT = 10;
    
    IF @ID >= 10
    BEGIN
        PRINT('The number is greather than 10');

        IF @ID = 10
            PRINT('The number is 10');
    END
    ELSE
        PRINT('The number is not greather than 10');
END

-- Check if there is a record with a particular BusinessEntityID
BEGIN
    DECLARE @BID INT = 10;
    
    SELECT * FROM Person.Person WHERE BusinessEntityID = @BID;

    IF @@ROWCOUNT > 0
        PRINT('Record of Person with Business Entity ID ' + CAST(@BID AS VARCHAR) + ' has been found!');
    ELSE
        PRINT('Record of Person with Business Entity ID ' + CAST(@BID AS VARCHAR) + ' has not been found!');
END

-- Example using WHILE
BEGIN
    DECLARE @num INT = 1;
    DECLARE @total INT = 0;

    WHILE @num <=10
    BEGIN
        SET @total += @num;
        SET @num += 1;
        PRINT @total;
    END
    PRINT @total;
END

-- Example of using BREAK to stop the cycle
DECLARE @number INT = 1;
DECLARE @result INT = 0;

WHILE @number <=10
BEGIN
    SET @result += @number;
    SET @number += 1;
    PRINT @result;
    IF @number = 5
        BREAK;
END
PRINT @result;

-- Example using CASE to change the displayed value according to gender 
SELECT 
    JobTitle, 
    BirthDate, 
    HireDate,
    CASE Gender 
        WHEN 'M' THEN 'MALE'
        WHEN 'F' THEN 'FEMALE'
        ELSE 'N/A'
    END AS Gender
FROM HumanResources.Employee;