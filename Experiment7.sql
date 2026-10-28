
-- EXPERIMENT 7: NORMALIZATION

-- STEP 1: Create Initial Table
CREATE TABLE Sales_UNF (
    OrderID INT PRIMARY KEY,
    OrderDate DATE,
    CustomerID INT,
    CustomerName VARCHAR(50),
    CustomerCity VARCHAR(50),
    Salesperson VARCHAR(50),
    Region VARCHAR(50),
    ProductDetails VARCHAR(200)
);

INSERT INTO Sales_UNF VALUES
(101,'2026-10-01',1,'Aarav Sharma','Lucknow','Riya','North','P1: Laptop, P2: Mouse'),
(102,'2026-10-02',2,'Ananya Verma','Kanpur','Aman','North','P2: Mouse, P3: Keyboard'),
(103,'2026-10-03',3,'Rohan Gupta','Delhi','Riya','North','P1: Laptop');

SELECT * FROM Sales_UNF;

-- STEP 2: Functional Dependencies
-- OrderID -> OrderDate, CustomerID, Salesperson
-- CustomerID -> CustomerName, CustomerCity
-- ProductID -> ProductName, UnitPrice
-- Salesperson -> Region
-- (OrderID, ProductID) -> Quantity

-- STEP 3: First Normal Form (1NF)
CREATE TABLE Sales_1NF (
    OrderID INT,
    OrderDate DATE,
    CustomerID INT,
    CustomerName VARCHAR(50),
    CustomerCity VARCHAR(50),
    Salesperson VARCHAR(50),
    Region VARCHAR(50),
    ProductID VARCHAR(10),
    ProductName VARCHAR(50),
    UnitPrice DECIMAL(10,2),
    Quantity INT,
    PRIMARY KEY (OrderID, ProductID)
);

INSERT INTO Sales_1NF VALUES
(101,'2026-10-01',1,'Aarav Sharma','Lucknow','Riya','North','P1','Laptop',50000,1),
(101,'2026-10-01',1,'Aarav Sharma','Lucknow','Riya','North','P2','Mouse',500,2),
(102,'2026-10-02',2,'Ananya Verma','Kanpur','Aman','North','P2','Mouse',500,1),
(102,'2026-10-02',2,'Ananya Verma','Kanpur','Aman','North','P3','Keyboard',1500,1),
(103,'2026-10-03',3,'Rohan Gupta','Delhi','Riya','North','P1','Laptop',50000,1);

SELECT * FROM Sales_1NF;

-- STEP 4: Second Normal Form (2NF)
CREATE TABLE Orders_2NF (
    OrderID INT PRIMARY KEY,
    OrderDate DATE,
    CustomerID INT,
    CustomerName VARCHAR(50),
    CustomerCity VARCHAR(50),
    Salesperson VARCHAR(50),
    Region VARCHAR(50)
);

INSERT INTO Orders_2NF VALUES
(101,'2026-10-01',1,'Aarav Sharma','Lucknow','Riya','North'),
(102,'2026-10-02',2,'Ananya Verma','Kanpur','Aman','North'),
(103,'2026-10-03',3,'Rohan Gupta','Delhi','Riya','North');

CREATE TABLE Products (
    ProductID VARCHAR(10) PRIMARY KEY,
    ProductName VARCHAR(50),
    UnitPrice DECIMAL(10,2)
);

INSERT INTO Products VALUES
('P1','Laptop',50000),
('P2','Mouse',500),
('P3','Keyboard',1500);

CREATE TABLE OrderItems (
    OrderID INT,
    ProductID VARCHAR(10),
    Quantity INT,
    PRIMARY KEY (OrderID, ProductID)
);

INSERT INTO OrderItems VALUES
(101,'P1',1),
(101,'P2',2),
(102,'P2',1),
(102,'P3',1),
(103,'P1',1);

SELECT * FROM Orders_2NF;
SELECT * FROM Products;
SELECT * FROM OrderItems;

-- STEP 5: Third Normal Form (3NF)
CREATE TABLE Customers (
    CustomerID INT PRIMARY KEY,
    CustomerName VARCHAR(50),
    CustomerCity VARCHAR(50)
);

INSERT INTO Customers VALUES
(1,'Aarav Sharma','Lucknow'),
(2,'Ananya Verma','Kanpur'),
(3,'Rohan Gupta','Delhi');

CREATE TABLE Salespeople (
    Salesperson VARCHAR(50) PRIMARY KEY,
    Region VARCHAR(50)
);

INSERT INTO Salespeople VALUES
('Riya','North'),
('Aman','North');

CREATE TABLE Orders_3NF (
    OrderID INT PRIMARY KEY,
    OrderDate DATE,
    CustomerID INT,
    Salesperson VARCHAR(50),
    FOREIGN KEY (CustomerID) REFERENCES Customers(CustomerID),
    FOREIGN KEY (Salesperson) REFERENCES Salespeople(Salesperson)
);

INSERT INTO Orders_3NF VALUES
(101,'2026-10-01',1,'Riya'),
(102,'2026-10-02',2,'Aman'),
(103,'2026-10-03',3,'Riya');

SELECT * FROM Customers;
SELECT * FROM Salespeople;
SELECT * FROM Orders_3NF;

-- STEP 6: BCNF Verification
SELECT * FROM Customers;
SELECT * FROM Salespeople;
SELECT * FROM Orders_3NF;
SELECT * FROM Products;
SELECT * FROM OrderItems;

-- Lossless Join Verification
SELECT
    O.OrderID,
    O.OrderDate,
    C.CustomerName,
    C.CustomerCity,
    S.Salesperson,
    S.Region,
    P.ProductID,
    P.ProductName,
    P.UnitPrice,
    I.Quantity
FROM Orders_3NF O
JOIN Customers C
    ON O.CustomerID = C.CustomerID
JOIN Salespeople S
    ON O.Salesperson = S.Salesperson
JOIN OrderItems I
    ON O.OrderID = I.OrderID
JOIN Products P
    ON I.ProductID = P.ProductID
ORDER BY O.OrderID, P.ProductID;

-- Dependency Preservation Verification
SELECT CustomerID, CustomerName, CustomerCity
FROM Customers;

SELECT Salesperson, Region
FROM Salespeople;

SELECT ProductID, ProductName, UnitPrice
FROM Products;

SELECT OrderID, ProductID, Quantity
FROM OrderItems;

-- RESULT
-- Sales data normalized into 1NF, 2NF and 3NF.
-- Lossless reconstruction and dependency representation demonstrated.
