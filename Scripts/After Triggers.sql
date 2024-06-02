-- Let's say we have two tables, Orders and OrdersHistory. We want to create a trigger that automatically inserts 
-- a record into the OrdersHistory table whenever an order is inserted, updated or deleted in the Orders table
CREATE DATABASE Demo;
GO
USE Demo
GO
CREATE TABLE Orders
(
    OrderID INT PRIMARY KEY,
    CustomerName VARCHAR(50),
    OrderDate DATE,
    TotalAmount DECIMAL(10,2)
);
GO
CREATE TABLE OrdersHistory
(
    HistoryID INT PRIMARY KEY IDENTITY,
    OrderID INT,
    [Action] VARCHAR(10),
    ActionDate DATE,
    CustomerName VARCHAR(50),
    OrderDate DATE,
    TotalAmount DECIMAL(10,2)
);
GO

CREATE OR ALTER TRIGGER trg_OrdersHistory
ON Orders
AFTER INSERT, UPDATE, DELETE
AS
BEGIN
    IF EXISTS (SELECT * FROM inserted) -- INSERT or UPDATE action
    BEGIN
        IF EXISTS (SELECT * FROM deleted)
        BEGIN
            -- UPDATE action
            -- You have to think about UPDATE statements as a DELETE followed by an INSERT
            -- If deleted and inserted exists, it is an UPDATE action
            IF EXISTS (SELECT * FROM inserted WHERE TotalAmount < 0)
                BEGIN
                    RAISERROR('Total amount must be greather than zero', 16, 1);
                    ROLLBACK TRANSACTION;
                    RETURN;
                END
            INSERT INTO OrdersHistory
            (
                OrderID,
                [Action],
                ActionDate,
                CustomerName,
                OrderDate,
                TotalAmount
            )
            SELECT 
                OrderID, 
                'UPDATE',
                GETDATE(),
                CustomerName,
                OrderDate,
                TotalAmount
            FROM inserted
        END
        ELSE
        BEGIN
            --INSERT action
            IF EXISTS (SELECT * FROM inserted WHERE TotalAmount < 0)
                BEGIN
                    RAISERROR('Total amount must be greather than zero', 16, 1);
                    ROLLBACK TRANSACTION;
                    RETURN;
                END
            INSERT INTO OrdersHistory
            (
                OrderID,
                [Action],
                ActionDate,
                CustomerName,
                OrderDate,
                TotalAmount
            )
            SELECT 
                OrderID, 
                'INSERT',
                GETDATE(),
                CustomerName,
                OrderDate,
                TotalAmount
            FROM inserted
        END
    END 
    ELSE
    BEGIN
        --DELETE action
        INSERT INTO OrdersHistory
        (
            OrderID,
            [Action],
            ActionDate,
            CustomerName,
            OrderDate,
            TotalAmount
        )
        SELECT 
            OrderID, 
            'DELETE',
            GETDATE(),
            CustomerName,
            OrderDate,
            TotalAmount
        FROM deleted
    END 
END

-- Test the trigger
INSERT INTO Orders
(
    OrderID,
    CustomerName,
    OrderDate,
    TotalAmount
)
VALUES 
(
    1,
    'John Doe',
    '2023-07-01',
    100.00
);

UPDATE Orders
SET TotalAmount = 150.00
WHERE OrderID = 1;

DELETE FROM Orders
WHERE OrderID = 1;

-- Enable/disable the trigger
DISABLE TRIGGER trg_OrdersHistory
ON Orders;

ENABLE TRIGGER trg_OrdersHistory
ON Orders;