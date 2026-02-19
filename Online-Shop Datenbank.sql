CREATE DATABASE OnlineShop;
USE OnlineShop;

GO

CREATE TABLE Customers (
    CustomerID INT IDENTITY(1,1) PRIMARY KEY,
    FirstName VARCHAR(50),
    LastName VARCHAR(50),
    Email VARCHAR(100),
    City VARCHAR(50),
    CreatedAt DATE
);

GO

CREATE TABLE Products (
    ProductID INT IDENTITY(1,1) PRIMARY KEY,
    ProductName VARCHAR(100),
    Category VARCHAR(50),
    Price DECIMAL(10,2),
    Stock INT
);
GO

CREATE TABLE Orders (
    OrderID INT IDENTITY(1,1) PRIMARY KEY,
    CustomerID INT,
    OrderDate DATE,
    CONSTRAINT FK_Orders_Customers FOREIGN KEY (CustomerID) REFERENCES Customers(CustomerID)
);
GO

CREATE TABLE OrderItems (
    OrderItemID INT IDENTITY(1,1) PRIMARY KEY,
    OrderID INT,
    ProductID INT,
    Quantity INT,
    Price DECIMAL(10,2),
    CONSTRAINT FK_OrderItems_Orders FOREIGN KEY (OrderID) REFERENCES Orders(OrderID),
    CONSTRAINT FK_OrderItems_Products FOREIGN KEY (ProductID) REFERENCES Products(ProductID)
);

GO

INSERT INTO Customers (FirstName, LastName, Email, City, CreatedAt) VALUES
('Max', 'Müller', 'max@mail.de', 'Berlin', '2025-01-10'),
('Anna', 'Schmidt', 'anna@mail.de', 'Hamburg', '2025-02-05'),
('Tom', 'Weber', 'tom@mail.de', 'München', '2025-02-20'),
('Lisa', 'Fischer', 'lisa@mail.de', 'Köln', '2025-03-01');

GO

INSERT INTO Products (ProductName, Category, Price, Stock) VALUES
('Gaming Maus', 'Gaming', 49.99, 100),
('Gaming Tastatur', 'Gaming', 89.99, 50),
('Monitor 24 Zoll', 'Hardware', 199.99, 30),
('Headset', 'Gaming', 79.99, 60),
('USB Kabel', 'Zubehör', 9.99, 200);

GO

INSERT INTO Orders (CustomerID, OrderDate) VALUES
(1, '2025-03-10'),
(2, '2025-03-12'),
(1, '2025-04-01'),
(3, '2025-04-05');

GO

INSERT INTO OrderItems (OrderID, ProductID, Quantity, Price) VALUES
(1, 1, 2, 49.99),
(1, 5, 3, 9.99),
(2, 2, 1, 89.99),
(3, 3, 1, 199.99),
(4, 4, 2, 79.99);

GO

SELECT 
    c.CustomerID,
    c.FirstName,
    c.LastName,
    o.OrderID,
    o.OrderDate
FROM Customers c
JOIN Orders o ON c.CustomerID = o.CustomerID;

GO

SELECT 
    c.CustomerID,
    c.FirstName,
    c.LastName,
    SUM(oi.Quantity * oi.Price) AS TotalRevenue
FROM Customers c
JOIN Orders o ON c.CustomerID = o.CustomerID
JOIN OrderItems oi ON o.OrderID = oi.OrderID
GROUP BY c.CustomerID, c.FirstName, c.LastName
ORDER BY TotalRevenue DESC;

GO

SELECT
    p.ProductName,
    SUM(oi.Quantity) AS TotalSold
FROM Products p
JOIN OrderItems oi ON p.ProductID = oi.ProductID
GROUP BY p.ProductName
ORDER BY TotalSold DESC
OFFSET 0 ROWS FETCH NEXT 10 ROWS ONLY;

GO

SELECT 
    YEAR(o.OrderDate) AS Year,
    MONTH(o.OrderDate) AS Month,
    SUM(oi.Quantity * oi.Price) AS MonthlyRevenue
FROM Orders o
JOIN OrderItems oi ON o.OrderID = oi.OrderID
GROUP BY YEAR(o.OrderDate), MONTH(o.OrderDate)
ORDER BY Year, Month;

GO

SELECT TOP 1
    p.ProductName,
    SUM(oi.Quantity) AS TotalSold
FROM Products p
JOIN OrderItems oi ON p.ProductID = oi.ProductID
GROUP BY p.ProductName
ORDER BY TotalSold DESC;

GO

SELECT 
    c.CustomerID,
    c.FirstName,
    c.LastName
FROM Customers c
LEFT JOIN Orders o ON c.CustomerID = o.CustomerID
WHERE o.OrderID IS NULL;

GO

