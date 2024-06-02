USE Demo
GO
CREATE TABLE OrdersAuditLog
(
    LogID INT PRIMARY KEY IDENTITY,
    OrderID INT,
    [Action] VARCHAR(10),
    ModifiedDate DATETIME,
    CustomerName VARCHAR(50),
    OrderDate DATE,
    TotalAmount DECIMAL(10,2)
);
GO

CREATE OR ALTER TRIGGER trg_OrdersAuditLog
ON Orders
INSTEAD OF INSERT, UPDATE, DELETE
AS
BEGIN
    IF EXISTS (SELECT * FROM inserted) -- INSERT or UPDATE action
    BEGIN
        IF EXISTS (SELECT * FROM deleted)
        BEGIN
            -- UPDATE action
            -- You have to think about UPDATE statements as a DELETE followed by an INSERT
            INSERT INTO OrdersAuditLog
            (
                OrderID,
                [Action],
                ModifiedDate,
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

            UPDATE o
            SET 
                o.CustomerName = i.CustomerName,
                o.OrderDate = i.OrderDate,
                o.TotalAmount = i.TotalAmount
            FROM Orders o
            INNER JOIN inserted i ON o.OrderID = i.OrderID
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
            
            INSERT INTO OrdersAuditLog
            (
                OrderID,
                [Action],
                ModifiedDate,
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

            INSERT INTO Orders (OrderID, CustomerName,OrderDate,TotalAmount)
            SELECT OrderID, CustomerName,OrderDate,TotalAmount
            FROM inserted
        END
    END 
    ELSE
    BEGIN
        --DELETE action
        INSERT INTO OrdersAuditLog
        (
            OrderID,
            [Action],
            ModifiedDate,
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

        DELETE o
        FROM Orders o
        INNER JOIN deleted d ON o.OrderID = d.OrderID;
    END 
END

INSERT INTO Orders
(
    OrderID,
    CustomerName,
    OrderDate,
    TotalAmount
)
VALUES 
(
    5,
    'John Brown',
    '2023-07-01',
    100.00
);

UPDATE Orders
SET TotalAmount = 150.00
WHERE OrderID = 5;

DELETE FROM Orders
WHERE OrderID = 5;
