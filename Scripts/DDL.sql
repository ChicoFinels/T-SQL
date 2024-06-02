CREATE DATABASE DatabaseTest
GO
USE DatabaseTest
GO
-- Drop the table if it already exists
IF OBJECT_ID('[dbo].[Employee]', 'U') IS NOT NULL
DROP TABLE [dbo].[Employee]
GO
-- Create the table in the specified schema
CREATE TABLE Employee
(
    Id INT PRIMARY KEY IDENTITY, -- Primary Key column
    FirstName VARCHAR(50) NOT NULL,
    LastName NVARCHAR(50) NOT NULL,
    DateOfBirth DATETIME2
);
GO
-- Drop the table if it already exists
IF OBJECT_ID('[dbo].[JobTitle]', 'U') IS NOT NULL
DROP TABLE [dbo].[JobTitle]
GO
CREATE TABLE JobTitle
(
    Id INT PRIMARY KEY IDENTITY, -- Primary Key column
    [Name] VARCHAR(100) NOT NULL
);
GO
ALTER TABLE Employee
ADD JobTitleId INT NOT NULL, FOREIGN KEY (JobTitleId) REFERENCES JobTitle(Id);
GO
ALTER TABLE Employee
ADD EmployeeId VARCHAR(10), EmployementDate DATETIME2 DEFAULT GETDATE();
GO
ALTER TABLE Employee
ALTER COLUMN DateOfBirth DATE;
GO
ALTER TABLE Employee
DROP COLUMN DateOfBirth;
GO
ALTER TABLE Employee
ADD CONSTRAINT UQ_EmployeeId UNIQUE(EmployeeId);
GO
-- ALTER TABLE Employee
-- DROP CONSTRAINT UQ_EmployeeId;
-- GO
-- DROP TABLE Employee;
-- GO
-- DROP TABLE JobTitle;
-- GO
-- DROP DATABASE DatabaseTest
-- GO