-- =============================================
-- SQL SERVER INTERVIEW PRACTICE DEMO SCRIPTS
-- =============================================

-- Create Database
USE master;
GO
IF EXISTS (SELECT name FROM sys.databases WHERE name = 'InterviewPractice')
    DROP DATABASE InterviewPractice;
GO
CREATE DATABASE InterviewPractice;
GO
USE InterviewPractice;
GO

-- =============================================
-- 1. CREATE DEMO TABLES WITH SAMPLE DATA
-- =============================================

-- Employees Table
CREATE TABLE Employees (
    EmployeeID INT PRIMARY KEY IDENTITY(1,1),
    FirstName NVARCHAR(50) NOT NULL,
    LastName NVARCHAR(50) NOT NULL,
    Email NVARCHAR(100) UNIQUE,
    DepartmentID INT,
    Salary DECIMAL(10,2),
    HireDate DATE,
    ManagerID INT,
    IsActive BIT DEFAULT 1
);

-- Departments Table
CREATE TABLE Departments (
    DepartmentID INT PRIMARY KEY IDENTITY(1,1),
    DepartmentName NVARCHAR(100) NOT NULL,
    Location NVARCHAR(100),
    Budget DECIMAL(15,2)
);

-- Orders Table
CREATE TABLE Orders (
    OrderID INT PRIMARY KEY IDENTITY(1,1),
    CustomerID INT,
    EmployeeID INT,
    OrderDate DATETIME DEFAULT GETDATE(),
    TotalAmount DECIMAL(12,2),
    Status NVARCHAR(20) DEFAULT 'Pending'
);

-- Products Table
CREATE TABLE Products (
    ProductID INT PRIMARY KEY IDENTITY(1,1),
    ProductName NVARCHAR(100) NOT NULL,
    Price DECIMAL(10,2),
    CategoryID INT,
    StockQuantity INT DEFAULT 0
);

-- OrderDetails Table
CREATE TABLE OrderDetails (
    OrderDetailID INT PRIMARY KEY IDENTITY(1,1),
    OrderID INT,
    ProductID INT,
    Quantity INT,
    UnitPrice DECIMAL(10,2)
);

-- Categories Table
CREATE TABLE Categories (
    CategoryID INT PRIMARY KEY IDENTITY(1,1),
    CategoryName NVARCHAR(50) NOT NULL,
    Description NVARCHAR(255)
);

-- Sales Table (for analytical functions)
CREATE TABLE Sales (
    SaleID INT PRIMARY KEY IDENTITY(1,1),
    EmployeeID INT,
    SaleDate DATE,
    Amount DECIMAL(10,2),
    Quarter INT,
    Year INT
);

-- =============================================
-- 2. INSERT SAMPLE DATA
-- =============================================

-- Insert Departments
INSERT INTO Departments (DepartmentName, Location, Budget) VALUES
('IT', 'New York', 500000.00),
('HR', 'Chicago', 200000.00),
('Finance', 'Boston', 300000.00),
('Marketing', 'Los Angeles', 250000.00),
('Sales', 'Miami', 400000.00);

-- Insert Employees
INSERT INTO Employees (FirstName, LastName, Email, DepartmentID, Salary, HireDate, ManagerID) VALUES
('John', 'Doe', 'john.doe@company.com', 1, 75000.00, '2020-01-15', NULL),
('Jane', 'Smith', 'jane.smith@company.com', 1, 65000.00, '2020-03-10', 1),
('Mike', 'Johnson', 'mike.johnson@company.com', 2, 55000.00, '2021-05-20', NULL),
('Sarah', 'Williams', 'sarah.williams@company.com', 2, 50000.00, '2021-07-12', 3),
('David', 'Brown', 'david.brown@company.com', 3, 80000.00, '2019-11-08', NULL),
('Lisa', 'Davis', 'lisa.davis@company.com', 3, 70000.00, '2020-09-15', 5),
('Tom', 'Wilson', 'tom.wilson@company.com', 4, 60000.00, '2022-01-03', NULL),
('Amy', 'Taylor', 'amy.taylor@company.com', 4, 55000.00, '2022-02-14', 7),
('Chris', 'Anderson', 'chris.anderson@company.com', 5, 90000.00, '2018-06-01', NULL),
('Emma', 'Thomas', 'emma.thomas@company.com', 5, 75000.00, '2019-08-20', 9),
('Robert', 'Jackson', 'robert.jackson@company.com', 1, 85000.00, '2017-12-10', 1),
('Maria', 'Garcia', 'maria.garcia@company.com', 3, 72000.00, '2021-03-25', 5);

-- Insert Categories
INSERT INTO Categories (CategoryName, Description) VALUES
('Electronics', 'Electronic devices and accessories'),
('Clothing', 'Apparel and fashion items'),
('Books', 'Books and educational materials'),
('Sports', 'Sports equipment and accessories');

-- Insert Products
INSERT INTO Products (ProductName, Price, CategoryID, StockQuantity) VALUES
('Laptop', 999.99, 1, 50),
('Mouse', 25.99, 1, 200),
('T-Shirt', 19.99, 2, 100),
('Jeans', 59.99, 2, 75),
('Novel', 12.99, 3, 150),
('Textbook', 89.99, 3, 30),
('Basketball', 29.99, 4, 80),
('Tennis Racket', 149.99, 4, 25);

-- Insert Orders
INSERT INTO Orders (CustomerID, EmployeeID, OrderDate, TotalAmount, Status) VALUES
(101, 2, '2024-01-15', 1025.98, 'Completed'),
(102, 2, '2024-01-20', 79.98, 'Completed'),
(103, 10, '2024-02-01', 45.98, 'Pending'),
(104, 10, '2024-02-05', 179.98, 'Completed'),
(105, 8, '2024-02-10', 89.99, 'Shipped'),
(106, 8, '2024-02-15', 29.99, 'Completed'),
(107, 2, '2024-03-01', 12.99, 'Pending');

-- Insert OrderDetails
INSERT INTO OrderDetails (OrderID, ProductID, Quantity, UnitPrice) VALUES
(1, 1, 1, 999.99), (1, 2, 1, 25.99),
(2, 3, 2, 19.99), (2, 4, 1, 59.99),
(3, 5, 2, 12.99), (3, 3, 1, 19.99),
(4, 8, 1, 149.99), (4, 7, 1, 29.99),
(5, 6, 1, 89.99),
(6, 7, 1, 29.99),
(7, 5, 1, 12.99);

-- Insert Sales data
INSERT INTO Sales (EmployeeID, SaleDate, Amount, Quarter, Year) VALUES
(2, '2024-01-15', 1500.00, 1, 2024),
(2, '2024-02-20', 2000.00, 1, 2024),
(10, '2024-01-10', 1800.00, 1, 2024),
(10, '2024-03-15', 2200.00, 1, 2024),
(8, '2024-02-05', 1200.00, 1, 2024),
(8, '2024-03-20', 1600.00, 1, 2024),
(2, '2024-04-10', 1900.00, 2, 2024),
(10, '2024-05-15', 2100.00, 2, 2024),
(8, '2024-06-20', 1400.00, 2, 2024);

-- Add Foreign Key Constraints
ALTER TABLE Employees ADD CONSTRAINT FK_Employees_Department 
    FOREIGN KEY (DepartmentID) REFERENCES Departments(DepartmentID);

ALTER TABLE Employees ADD CONSTRAINT FK_Employees_Manager 
    FOREIGN KEY (ManagerID) REFERENCES Employees(EmployeeID);

ALTER TABLE Orders ADD CONSTRAINT FK_Orders_Employee 
    FOREIGN KEY (EmployeeID) REFERENCES Employees(EmployeeID);

ALTER TABLE Products ADD CONSTRAINT FK_Products_Category 
    FOREIGN KEY (CategoryID) REFERENCES Categories(CategoryID);

ALTER TABLE OrderDetails ADD CONSTRAINT FK_OrderDetails_Order 
    FOREIGN KEY (OrderID) REFERENCES Orders(OrderID);

ALTER TABLE OrderDetails ADD CONSTRAINT FK_OrderDetails_Product 
    FOREIGN KEY (ProductID) REFERENCES Products(ProductID);

ALTER TABLE Sales ADD CONSTRAINT FK_Sales_Employee 
    FOREIGN KEY (EmployeeID) REFERENCES Employees(EmployeeID);

-- =============================================
-- 3. INDEXES CREATION EXAMPLES
-- =============================================

-- Clustered Index (Primary Key creates this automatically)
-- Non-clustered indexes
CREATE NONCLUSTERED INDEX IX_Employees_DepartmentID ON Employees(DepartmentID);
CREATE NONCLUSTERED INDEX IX_Employees_Salary ON Employees(Salary DESC);
CREATE NONCLUSTERED INDEX IX_Orders_OrderDate ON Orders(OrderDate);
CREATE NONCLUSTERED INDEX IX_Products_Price ON Products(Price);

-- Composite Index
CREATE NONCLUSTERED INDEX IX_Sales_Employee_Date ON Sales(EmployeeID, SaleDate);

-- Covering Index (includes additional columns)
CREATE NONCLUSTERED INDEX IX_Employees_Dept_Covering 
    ON Employees(DepartmentID) INCLUDE (FirstName, LastName, Salary);

-- Unique Index
CREATE UNIQUE NONCLUSTERED INDEX IX_Employees_Email_Unique ON Employees(Email);

-- View Index information
SELECT 
    i.name AS IndexName,
    i.type_desc AS IndexType,
    t.name AS TableName,
    c.name AS ColumnName,
    ic.is_included_column
FROM sys.indexes i
JOIN sys.index_columns ic ON i.object_id = ic.object_id AND i.index_id = ic.index_id
JOIN sys.columns c ON ic.object_id = c.object_id AND ic.column_id = c.column_id
JOIN sys.tables t ON i.object_id = t.object_id
WHERE t.name IN ('Employees', 'Orders', 'Products', 'Sales')
ORDER BY t.name, i.name, ic.key_ordinal;

-- =============================================
-- 4. STORED PROCEDURES EXAMPLES
-- =============================================

-- Simple Procedure
CREATE PROCEDURE GetEmployeesByDepartment
    @DepartmentID INT
AS
BEGIN
    SET NOCOUNT ON;
    
    SELECT e.EmployeeID, e.FirstName, e.LastName, e.Salary, d.DepartmentName
    FROM Employees e
    JOIN Departments d ON e.DepartmentID = d.DepartmentID
    WHERE e.DepartmentID = @DepartmentID;
END;
GO

-- Procedure with Output Parameter
CREATE PROCEDURE GetEmployeeCount
    @DepartmentID INT = NULL,
    @TotalCount INT OUTPUT
AS
BEGIN
    SET NOCOUNT ON;
    
    IF @DepartmentID IS NULL
        SELECT @TotalCount = COUNT(*) FROM Employees;
    ELSE
        SELECT @TotalCount = COUNT(*) FROM Employees WHERE DepartmentID = @DepartmentID;
END;
GO

-- Procedure with Error Handling and Transaction
CREATE PROCEDURE UpdateEmployeeSalary
    @EmployeeID INT,
    @NewSalary DECIMAL(10,2),
    @UpdatedBy NVARCHAR(50) = 'System'
AS
BEGIN
    SET NOCOUNT ON;
    
    BEGIN TRY
        BEGIN TRANSACTION;
        
        IF NOT EXISTS (SELECT 1 FROM Employees WHERE EmployeeID = @EmployeeID)
        BEGIN
            RAISERROR('Employee not found', 16, 1);
            RETURN;
        END
        
        UPDATE Employees 
        SET Salary = @NewSalary 
        WHERE EmployeeID = @EmployeeID;
        
        COMMIT TRANSACTION;
        PRINT 'Salary updated successfully';
        
    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT > 0
            ROLLBACK TRANSACTION;
        
        DECLARE @ErrorMessage NVARCHAR(4000) = ERROR_MESSAGE();
        RAISERROR(@ErrorMessage, 16, 1);
    END CATCH
END;
GO

-- Execute Procedure Examples
EXEC GetEmployeesByDepartment @DepartmentID = 1;

DECLARE @Count INT;
EXEC GetEmployeeCount @DepartmentID = 1, @TotalCount = @Count OUTPUT;
SELECT @Count as EmployeeCount;

-- =============================================
-- 5. VIEWS EXAMPLES
-- =============================================

-- Simple View
CREATE VIEW vw_EmployeeDetails AS
SELECT 
    e.EmployeeID,
    e.FirstName + ' ' + e.LastName AS FullName,
    e.Email,
    d.DepartmentName,
    e.Salary,
    e.HireDate
FROM Employees e
JOIN Departments d ON e.DepartmentID = d.DepartmentID;
GO

-- Complex View with Calculations
CREATE VIEW vw_DepartmentSummary AS
SELECT 
    d.DepartmentID,
    d.DepartmentName,
    COUNT(e.EmployeeID) AS EmployeeCount,
    AVG(e.Salary) AS AverageSalary,
    MAX(e.Salary) AS MaxSalary,
    MIN(e.Salary) AS MinSalary,
    SUM(e.Salary) AS TotalSalary
FROM Departments d
LEFT JOIN Employees e ON d.DepartmentID = e.DepartmentID
GROUP BY d.DepartmentID, d.DepartmentName;
GO

-- Indexed View (Materialized)
CREATE VIEW vw_OrderSummary
WITH SCHEMABINDING
AS
SELECT 
    o.OrderID,
    o.CustomerID,
    o.OrderDate,
    SUM(od.Quantity * od.UnitPrice) AS OrderTotal,
    COUNT_BIG(*) AS ItemCount
FROM dbo.Orders o
JOIN dbo.OrderDetails od ON o.OrderID = od.OrderID
GROUP BY o.OrderID, o.CustomerID, o.OrderDate;
GO

CREATE UNIQUE CLUSTERED INDEX IX_vw_OrderSummary ON vw_OrderSummary(OrderID);

-- Use Views
SELECT * FROM vw_EmployeeDetails WHERE DepartmentName = 'IT';
SELECT * FROM vw_DepartmentSummary ORDER BY AverageSalary DESC;

-- =============================================
-- 6. WINDOW FUNCTIONS EXAMPLES
-- =============================================

-- ROW_NUMBER, RANK, DENSE_RANK
SELECT 
    FirstName,
    LastName,
    DepartmentID,
    Salary,
    ROW_NUMBER() OVER (ORDER BY Salary DESC) AS RowNum,
    RANK() OVER (ORDER BY Salary DESC) AS Rank_,
    DENSE_RANK() OVER (ORDER BY Salary DESC) AS DenseRank,
    ROW_NUMBER() OVER (PARTITION BY DepartmentID ORDER BY Salary DESC) AS DeptRowNum
FROM Employees;

-- NTILE (Quartiles)
SELECT 
    FirstName,
    LastName,
    Salary,
    NTILE(4) OVER (ORDER BY Salary) AS SalaryQuartile
FROM Employees;

-- Aggregate Window Functions
SELECT 
    e.FirstName,
    e.LastName,
    e.Salary,
    d.DepartmentName,
    AVG(e.Salary) OVER (PARTITION BY e.DepartmentID) AS DeptAvgSalary,
    SUM(e.Salary) OVER (PARTITION BY e.DepartmentID) AS DeptTotalSalary,
    COUNT(*) OVER (PARTITION BY e.DepartmentID) AS DeptEmployeeCount,
    MIN(e.Salary) OVER (PARTITION BY e.DepartmentID) AS DeptMinSalary,
    MAX(e.Salary) OVER (PARTITION BY e.DepartmentID) AS DeptMaxSalary
FROM Employees e
JOIN Departments d ON e.DepartmentID = d.DepartmentID;

-- LAG and LEAD Functions
SELECT 
    SaleDate,
    Amount,
    LAG(Amount, 1) OVER (ORDER BY SaleDate) AS PreviousSale,
    LEAD(Amount, 1) OVER (ORDER BY SaleDate) AS NextSale,
    Amount - LAG(Amount, 1) OVER (ORDER BY SaleDate) AS SalesDifference
FROM Sales
ORDER BY SaleDate;

-- Running Totals
SELECT 
    SaleDate,
    Amount,
    SUM(Amount) OVER (ORDER BY SaleDate ROWS UNBOUNDED PRECEDING) AS RunningTotal,
    AVG(Amount) OVER (ORDER BY SaleDate ROWS 2 PRECEDING) AS MovingAvg3
FROM Sales
ORDER by SaleDate;

-- =============================================
-- 7. JOINS EXAMPLES
-- =============================================

-- INNER JOIN
SELECT e.FirstName, e.LastName, d.DepartmentName
FROM Employees e
INNER JOIN Departments d ON e.DepartmentID = d.DepartmentID;

-- LEFT OUTER JOIN
SELECT d.DepartmentName, e.FirstName, e.LastName
FROM Departments d
LEFT JOIN Employees e ON d.DepartmentID = e.DepartmentID;

-- RIGHT OUTER JOIN
SELECT e.FirstName, e.LastName, d.DepartmentName
FROM Employees e
RIGHT JOIN Departments d ON e.DepartmentID = d.DepartmentID;

-- FULL OUTER JOIN
SELECT 
    ISNULL(d.DepartmentName, 'No Department') AS Department,
    ISNULL(e.FirstName + ' ' + e.LastName, 'No Employee') AS Employee
FROM Departments d
FULL OUTER JOIN Employees e ON d.DepartmentID = e.DepartmentID;

-- CROSS JOIN
SELECT d.DepartmentName, c.CategoryName
FROM Departments d
CROSS JOIN Categories c;

-- SELF JOIN (Manager-Employee relationship)
SELECT 
    e.FirstName + ' ' + e.LastName AS Employee,
    m.FirstName + ' ' + m.LastName AS Manager
FROM Employees e
LEFT JOIN Employees m ON e.ManagerID = m.EmployeeID;

-- Multiple JOINS
SELECT 
    o.OrderID,
    e.FirstName + ' ' + e.LastName AS Employee,
    d.DepartmentName,
    o.OrderDate,
    o.TotalAmount
FROM Orders o
JOIN Employees e ON o.EmployeeID = e.EmployeeID
JOIN Departments d ON e.DepartmentID = d.DepartmentID;

-- =============================================
-- 8. CTE (Common Table Expression) EXAMPLES
-- =============================================

-- Simple CTE
WITH DepartmentAvg AS (
    SELECT 
        DepartmentID,
        AVG(Salary) AS AvgSalary
    FROM Employees
    GROUP BY DepartmentID
)
SELECT 
    e.FirstName,
    e.LastName,
    e.Salary,
    da.AvgSalary,
    CASE 
        WHEN e.Salary > da.AvgSalary THEN 'Above Average'
        ELSE 'Below Average'
    END AS SalaryCategory
FROM Employees e
JOIN DepartmentAvg da ON e.DepartmentID = da.DepartmentID;

-- Recursive CTE (Organizational Hierarchy)
WITH EmployeeHierarchy AS (
    -- Anchor: Top-level managers
    SELECT 
        EmployeeID,
        FirstName,
        LastName,
        ManagerID,
        0 AS Level,
        CAST(FirstName + ' ' + LastName AS NVARCHAR(1000)) AS HierarchyPath
    FROM Employees
    WHERE ManagerID IS NULL
    
    UNION ALL
    
    -- Recursive: Subordinates
    SELECT 
        e.EmployeeID,
        e.FirstName,
        e.LastName,
        e.ManagerID,
        eh.Level + 1,
        eh.HierarchyPath + ' -> ' + e.FirstName + ' ' + e.LastName
    FROM Employees e
    JOIN EmployeeHierarchy eh ON e.ManagerID = eh.EmployeeID
)
SELECT * FROM EmployeeHierarchy ORDER BY Level, LastName;

-- Multiple CTEs
WITH SalesSummary AS (
    SELECT 
        EmployeeID,
        SUM(Amount) AS TotalSales,
        COUNT(*) AS SalesCount
    FROM Sales
    GROUP BY EmployeeID
),
TopPerformers AS (
    SELECT TOP 3 *
    FROM SalesSummary
    ORDER BY TotalSales DESC
)
SELECT 
    e.FirstName + ' ' + e.LastName AS EmployeeName,
    d.DepartmentName,
    tp.TotalSales,
    tp.SalesCount
FROM TopPerformers tp
JOIN Employees e ON tp.EmployeeID = e.EmployeeID
JOIN Departments d ON e.DepartmentID = d.DepartmentID;

-- =============================================
-- 9. DYNAMIC QUERIES EXAMPLES
-- =============================================

-- Simple Dynamic Query
DECLARE @SQL NVARCHAR(MAX);
DECLARE @DepartmentName NVARCHAR(100) = 'IT';

SET @SQL = 'SELECT e.FirstName, e.LastName FROM Employees e 
            JOIN Departments d ON e.DepartmentID = d.DepartmentID 
            WHERE d.DepartmentName = ''' + @DepartmentName + '''';

EXEC sp_executesql @SQL;

-- Dynamic Query with Parameters (Safer)
DECLARE @SQL2 NVARCHAR(MAX);
DECLARE @DeptID INT = 1;

SET @SQL2 = N'SELECT FirstName, LastName, Salary 
              FROM Employees 
              WHERE DepartmentID = @DepartmentID';

EXEC sp_executesql @SQL2, N'@DepartmentID INT', @DepartmentID = @DeptID;

-- Dynamic Pivot Query
DECLARE @Columns NVARCHAR(MAX);
DECLARE @PivotSQL NVARCHAR(MAX);

SELECT @Columns = STUFF((
    SELECT DISTINCT ',' + QUOTENAME(DepartmentName) 
    FROM Departments 
    FOR XML PATH(''), TYPE).value('.', 'NVARCHAR(MAX)'), 1, 1, '');

SET @PivotSQL = N'
SELECT * FROM (
    SELECT 
        YEAR(HireDate) AS HireYear,
        d.DepartmentName
    FROM Employees e
    JOIN Departments d ON e.DepartmentID = d.DepartmentID
) AS SourceTable
PIVOT (
    COUNT(DepartmentName)
    FOR DepartmentName IN (' + @Columns + ')
) AS PivotTable';

EXEC sp_executesql @PivotSQL;

-- =============================================
-- 10. QUERY OPTIMIZATION EXAMPLES
-- =============================================

-- Show Execution Plan
SET STATISTICS IO ON;
SET STATISTICS TIME ON;

-- Inefficient Query (Table Scan)
SELECT * FROM Employees WHERE FirstName = 'John';

-- Optimized Query (Index Seek)
SELECT EmployeeID, FirstName, LastName FROM Employees WHERE EmployeeID = 1;

-- Use of WHERE clause before JOIN
-- Good
SELECT e.FirstName, d.DepartmentName
FROM Employees e
JOIN Departments d ON e.DepartmentID = d.DepartmentID
WHERE e.Salary > 70000;

-- Query with EXISTS vs IN
-- Using EXISTS (generally more efficient)
SELECT FirstName, LastName
FROM Employees e
WHERE EXISTS (SELECT 1 FROM Orders o WHERE o.EmployeeID = e.EmployeeID);

-- Using IN
SELECT FirstName, LastName
FROM Employees e
WHERE e.EmployeeID IN (SELECT DISTINCT EmployeeID FROM Orders WHERE EmployeeID IS NOT NULL);

SET STATISTICS IO OFF;
SET STATISTICS TIME OFF;

-- =============================================
-- 11. DEADLOCK SIMULATION
-- =============================================

-- Create test tables for deadlock
CREATE TABLE TestTable1 (ID INT PRIMARY KEY, Value NVARCHAR(50));
CREATE TABLE TestTable2 (ID INT PRIMARY KEY, Value NVARCHAR(50));

INSERT INTO TestTable1 VALUES (1, 'Test1'), (2, 'Test2');
INSERT INTO TestTable2 VALUES (1, 'Test1'), (2, 'Test2');

-- Session 1 (Run in one window):
/*
BEGIN TRANSACTION;
UPDATE TestTable1 SET Value = 'Updated1' WHERE ID = 1;
WAITFOR DELAY '00:00:05';
UPDATE TestTable2 SET Value = 'Updated2' WHERE ID = 1;
COMMIT;
*/

-- Session 2 (Run simultaneously in another window):
/*
BEGIN TRANSACTION;
UPDATE TestTable2 SET Value = 'Updated2' WHERE ID = 1;
WAITFOR DELAY '00:00:05';
UPDATE TestTable1 SET Value = 'Updated1' WHERE ID = 1;
COMMIT;
*/

-- =============================================
-- 12. ISOLATION LEVELS EXAMPLES
-- =============================================

-- READ UNCOMMITTED (Dirty Read)
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;
SELECT * FROM Employees;

-- READ COMMITTED (Default)
SET TRANSACTION ISOLATION LEVEL READ COMMITTED;
SELECT * FROM Employees;

-- REPEATABLE READ
SET TRANSACTION ISOLATION LEVEL REPEATABLE READ;
BEGIN TRANSACTION;
SELECT * FROM Employees WHERE EmployeeID = 1;
-- Run this twice in same transaction - same results
SELECT * FROM Employees WHERE EmployeeID = 1;
COMMIT;

-- SERIALIZABLE
SET TRANSACTION ISOLATION LEVEL SERIALIZABLE;
SELECT * FROM Employees;

-- SNAPSHOT
-- Enable snapshot isolation
ALTER DATABASE InterviewPractice SET ALLOW_SNAPSHOT_ISOLATION ON;
SET TRANSACTION ISOLATION LEVEL SNAPSHOT;
SELECT * FROM Employees;

-- =============================================
-- 13. PRIMARY KEY vs FOREIGN KEY DIFFERENCES
-- =============================================

-- Primary Key characteristics demonstrated
SELECT 
    tc.CONSTRAINT_NAME,
    tc.TABLE_NAME,
    kcu.COLUMN_NAME,
    tc.CONSTRAINT_TYPE
FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS tc
JOIN INFORMATION_SCHEMA.KEY_COLUMN_USAGE kcu 
    ON tc.CONSTRAINT_NAME = kcu.CONSTRAINT_NAME
WHERE tc.CONSTRAINT_TYPE IN ('PRIMARY KEY', 'FOREIGN KEY')
ORDER BY tc.TABLE_NAME, tc.CONSTRAINT_TYPE;

-- =============================================
-- 14. UNION vs UNION ALL
-- =============================================

-- UNION (removes duplicates)
SELECT FirstName, LastName FROM Employees WHERE DepartmentID = 1
UNION
SELECT FirstName, LastName FROM Employees WHERE Salary > 70000;

-- UNION ALL (keeps duplicates)
SELECT FirstName, LastName FROM Employees WHERE DepartmentID = 1
UNION ALL
SELECT FirstName, LastName FROM Employees WHERE Salary > 70000;

-- Performance comparison
SELECT 'UNION' as QueryType, COUNT(*) as ResultCount FROM (
    SELECT FirstName, LastName FROM Employees WHERE DepartmentID = 1
    UNION
    SELECT FirstName, LastName FROM Employees WHERE Salary > 70000
) t

UNION ALL

SELECT 'UNION ALL' as QueryType, COUNT(*) as ResultCount FROM (
    SELECT FirstName, LastName FROM Employees WHERE DepartmentID = 1
    UNION ALL
    SELECT FirstName, LastName FROM Employees WHERE Salary > 70000
) t;

-- =============================================
-- 15. CHAR vs VARCHAR DATA TYPES
-- =============================================

-- Create table to demonstrate CHAR vs VARCHAR
CREATE TABLE DataTypeDemo (
    ID INT IDENTITY(1,1),
    FixedChar CHAR(10),
    VariableChar VARCHAR(10),
    FixedCharValue AS DATALENGTH(FixedChar),
    VariableCharValue AS DATALENGTH(VariableChar)
);

INSERT INTO DataTypeDemo (FixedChar, VariableChar) VALUES 
('ABC', 'ABC'),
('ABCDEFGHIJ', 'ABCDEFGHIJ'),
('A', 'A');

SELECT * FROM DataTypeDemo;

-- Storage difference
SELECT 
    FixedChar,
    VariableChar,
    DATALENGTH(FixedChar) AS CharLength,
    DATALENGTH(VariableChar) AS VarcharLength,
    LEN(FixedChar) AS CharLenFunction,
    LEN(VariableChar) AS VarcharLenFunction
FROM DataTypeDemo;

-- =============================================
-- 16. ANALYTICAL FUNCTIONS
-- =============================================

-- FIRST_VALUE and LAST_VALUE
SELECT 
    EmployeeID,
    FirstName,
    Salary,
    DepartmentID,
    FIRST_VALUE(Salary) OVER (PARTITION BY DepartmentID ORDER BY Salary) AS LowestSalaryInDept,
    LAST_VALUE(Salary) OVER (PARTITION BY DepartmentID ORDER BY Salary 
        ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING) AS HighestSalaryInDept
FROM Employees;

-- PERCENT_RANK and CUME_DIST
SELECT 
    FirstName,
    LastName,
    Salary,
    PERCENT_RANK() OVER (ORDER BY Salary) AS PercentRank,
    CUME_DIST() OVER (ORDER BY Salary) AS CumulativeDistribution,
    PERCENTILE_CONT(0.5) WITHIN GROUP (ORDER BY Salary) OVER () AS MedianSalary
FROM Employees;

-- =============================================
-- 17. FUNCTIONS vs PROCEDURES DIFFERENCES
-- =============================================

-- Scalar Function
CREATE FUNCTION fn_GetEmployeeFullName(@EmployeeID INT)
RETURNS NVARCHAR(101)
AS
BEGIN
    DECLARE @FullName NVARCHAR(101);
    
    SELECT @FullName = FirstName + ' ' + LastName
    FROM Employees
    WHERE EmployeeID = @EmployeeID;
    
    RETURN ISNULL(@FullName, 'Not Found');
END;
GO

-- Table-Valued Function
CREATE FUNCTION fn_GetEmployeesByDepartment(@DepartmentID INT)
RETURNS TABLE
AS
RETURN (
    SELECT EmployeeID, FirstName, LastName, Salary
    FROM Employees
    WHERE DepartmentID = @DepartmentID
);
GO

-- Use Functions
SELECT dbo.fn_GetEmployeeFullName(1) AS FullName;
SELECT * FROM dbo.fn_GetEmployeesByDepartment(1);

-- Compare with Procedure (already created above)
EXEC GetEmployeesByDepartment @DepartmentID = 1;

-- =============================================
-- 18. FIND DUPLICATE RECORDS
-- =============================================

-- Insert some duplicate data for demonstration
INSERT INTO Employees (FirstName, LastName, Email, DepartmentID, Salary, HireDate)
VALUES ('John', 'Doe', 'john.doe2@company.com', 1, 75000.00, '2020-01-15'),
       ('Jane', 'Smith', 'jane.smith2@company.com', 1, 65000.00, '2020-03-10');

-- Method 1: Using GROUP BY and HAVING
SELECT FirstName, LastName, COUNT(*) as DuplicateCount
FROM Employees
GROUP BY FirstName, LastName
HAVING COUNT(*) > 1;

-- Method 2: Using Window Functions
SELECT *
FROM (
    SELECT *,
           ROW_NUMBER() OVER (PARTITION BY FirstName, LastName ORDER BY EmployeeID) as RowNum
    FROM Employees
) t
WHERE RowNum > 1;

-- Method 3: Using EXISTS
SELECT e1.*
FROM Employees e1
WHERE EXISTS (
    SELECT 1
    FROM Employees e2
    WHERE e1.FirstName = e2.FirstName
      AND e1.LastName = e2.LastName
      AND e1.EmployeeID <> e2.EmployeeID
);

-- Method 4: Self Join
SELECT DISTINCT e1.*
FROM Employees e1
INNER JOIN Employees e2 ON e1.FirstName = e2.FirstName 
                        AND e1.LastName = e2.LastName 
                        AND e1.EmployeeID <> e2.EmployeeID;

-- Remove Duplicates (Keep only one record)
WITH DuplicateCTE AS (
    SELECT *,
           ROW_NUMBER() OVER (PARTITION BY FirstName, LastName ORDER BY EmployeeID) as RowNum
    FROM Employees
)
DELETE FROM DuplicateCTE WHERE RowNum > 1;

-- =============================================
-- 19. FIND NTH HIGHEST SALARY
-- =============================================

-- Method 1: Using DENSE_RANK (Recommended)
WITH SalaryRanks AS (
    SELECT 
        EmployeeID,
        FirstName,
        LastName,
        Salary,
        DENSE_RANK() OVER (ORDER BY Salary DESC) as SalaryRank
    FROM Employees
)
SELECT * FROM SalaryRanks WHERE SalaryRank = 3; -- 3rd highest

-- Method 2: Using ROW_NUMBER
WITH SalaryRows AS (
    SELECT DISTINCT
        Salary,
        ROW_NUMBER() OVER (ORDER BY Salary DESC) as RowNum
    FROM Employees
)
SELECT e.EmployeeID, e.FirstName, e.LastName, e.Salary
FROM Employees e
JOIN SalaryRows sr ON e.Salary = sr.Salary
WHERE sr.RowNum = 2; -- 2nd highest

-- Method 3: Using OFFSET and FETCH (SQL Server 2012+)
SELECT DISTINCT Salary
FROM Employees
ORDER BY Salary DESC
OFFSET 2 ROWS FETCH NEXT 1 ROWS ONLY; -- 3rd highest salary value

-- Method 4: Using Subquery (Traditional approach)
SELECT TOP 1 Salary
FROM (
    SELECT DISTINCT TOP 3 Salary
    FROM Employees
    ORDER BY Salary DESC
) t
ORDER BY Salary ASC; -- 3rd highest

-- Method 5: Using NTILE for Salary Percentiles
SELECT 
    FirstName,
    LastName,
    Salary,
    NTILE(10) OVER (ORDER BY Salary) as SalaryDecile,
    CASE 
        WHEN NTILE(10) OVER (ORDER BY Salary) >= 9 THEN 'Top 20%'
        WHEN NTILE(10) OVER (ORDER BY Salary) >= 7 THEN 'Top 40%'
        ELSE 'Others'
    END as SalaryBracket
FROM Employees;

-- Dynamic Nth Highest Salary Function
CREATE FUNCTION fn_GetNthHighestSalary(@N INT)
RETURNS DECIMAL(10,2)
AS
BEGIN
    DECLARE @Result DECIMAL(10,2);
    
    WITH SalaryRanks AS (
        SELECT 
            Salary,
            DENSE_RANK() OVER (ORDER BY Salary DESC) as Rank_
        FROM Employees
    )
    SELECT @Result = Salary
    FROM SalaryRanks
    WHERE Rank_ = @N;
    
    RETURN @Result;
END;
GO

-- Use the function
SELECT dbo.fn_GetNthHighestSalary(2) as SecondHighestSalary;
SELECT dbo.fn_GetNthHighestSalary(3) as ThirdHighestSalary;

-- =============================================
-- 20. ADVANCED QUERY EXAMPLES
-- =============================================

-- Running Totals by Department
SELECT 
    e.FirstName,
    e.LastName,
    d.DepartmentName,
    e.Salary,
    SUM(e.Salary) OVER (PARTITION BY e.DepartmentID ORDER BY e.Salary 
                        ROWS UNBOUNDED PRECEDING) as RunningTotal
FROM Employees e
JOIN Departments d ON e.DepartmentID = d.DepartmentID
ORDER BY d.DepartmentName, e.Salary;

-- Monthly Sales Trend
WITH MonthlySales AS (
    SELECT 
        YEAR(SaleDate) as SaleYear,
        MONTH(SaleDate) as SaleMonth,
        SUM(Amount) as MonthlyTotal
    FROM Sales
    GROUP BY YEAR(SaleDate), MONTH(SaleDate)
)
SELECT 
    SaleYear,
    SaleMonth,
    MonthlyTotal,
    LAG(MonthlyTotal) OVER (ORDER BY SaleYear, SaleMonth) as PreviousMonth,
    MonthlyTotal - LAG(MonthlyTotal) OVER (ORDER BY SaleYear, SaleMonth) as GrowthAmount,
    CASE 
        WHEN LAG(MonthlyTotal) OVER (ORDER BY SaleYear, SaleMonth) IS NULL THEN NULL
        ELSE ((MonthlyTotal - LAG(MonthlyTotal) OVER (ORDER BY SaleYear, SaleMonth)) * 100.0 / 
              LAG(MonthlyTotal) OVER (ORDER BY SaleYear, SaleMonth))
    END as GrowthPercentage
FROM MonthlySales;

-- Employee Performance Comparison
SELECT 
    e.FirstName + ' ' + e.LastName as EmployeeName,
    d.DepartmentName,
    e.Salary,
    AVG(e.Salary) OVER (PARTITION BY e.DepartmentID) as DeptAvgSalary,
    e.Salary - AVG(e.Salary) OVER (PARTITION BY e.DepartmentID) as SalaryDifference,
    CASE 
        WHEN e.Salary > AVG(e.Salary) OVER (PARTITION BY e.DepartmentID) THEN 'Above Average'
        WHEN e.Salary = AVG(e.Salary) OVER (PARTITION BY e.DepartmentID) THEN 'Average'
        ELSE 'Below Average'
    END as PerformanceCategory
FROM Employees e
JOIN Departments d ON e.DepartmentID = d.DepartmentID;

-- Complex Pivot Example - Sales by Employee and Quarter
DECLARE @PivotCols NVARCHAR(MAX);
DECLARE @PivotQuery NVARCHAR(MAX);

SELECT @PivotCols = STUFF((
    SELECT DISTINCT ',' + QUOTENAME('Q' + CAST(Quarter AS VARCHAR(1)))
    FROM Sales
    FOR XML PATH(''), TYPE).value('.', 'NVARCHAR(MAX)'), 1, 1, '');

SET @PivotQuery = N'
SELECT 
    EmployeeName,
    ' + @PivotCols + '
FROM (
    SELECT 
        e.FirstName + '' '' + e.LastName as EmployeeName,
        ''Q'' + CAST(s.Quarter AS VARCHAR(1)) as Quarter,
        s.Amount
    FROM Sales s
    JOIN Employees e ON s.EmployeeID = e.EmployeeID
) as SourceData
PIVOT (
    SUM(Amount)
    FOR Quarter IN (' + @PivotCols + ')
) as PivotTable';

EXEC sp_executesql @PivotQuery;

-- =============================================
-- 21. PERFORMANCE MONITORING QUERIES
-- =============================================

-- Check Index Usage
SELECT 
    OBJECT_NAME(i.object_id) as TableName,
    i.name as IndexName,
    i.type_desc as IndexType,
    ius.user_seeks,
    ius.user_scans,
    ius.user_lookups,
    ius.user_updates,
    ius.last_user_seek,
    ius.last_user_scan,
    ius.last_user_lookup
FROM sys.indexes i
LEFT JOIN sys.dm_db_index_usage_stats ius 
    ON i.object_id = ius.object_id AND i.index_id = ius.index_id
WHERE OBJECT_NAME(i.object_id) IN ('Employees', 'Orders', 'Products')
ORDER BY TableName, IndexName;

-- Missing Index Suggestions
SELECT 
    mid.statement as TableName,
    migs.avg_total_user_cost * (migs.avg_user_impact / 100.0) * (migs.user_seeks + migs.user_scans) as ImprovementMeasure,
    'CREATE INDEX IX_' + REPLACE(REPLACE(REPLACE(mid.statement,'[',''),']',''),'.','_') + '_Missing ON ' + mid.statement 
    + ' (' + ISNULL(mid.equality_columns,'') 
    + CASE WHEN mid.equality_columns IS NOT NULL AND mid.inequality_columns IS NOT NULL THEN ',' ELSE '' END
    + ISNULL(mid.inequality_columns, '') + ')'  
    + ISNULL(' INCLUDE (' + mid.included_columns + ')', '') as CreateIndexStatement
FROM sys.dm_db_missing_index_groups mig
INNER JOIN sys.dm_db_missing_index_group_stats migs ON migs.group_handle = mig.index_group_handle
INNER JOIN sys.dm_db_missing_index_details mid ON mig.index_handle = mid.index_handle
WHERE migs.avg_total_user_cost * (migs.avg_user_impact / 100.0) * (migs.user_seeks + migs.user_scans) > 10
ORDER BY ImprovementMeasure DESC;

-- =============================================
-- 22. CLEANUP AND UTILITY SCRIPTS
-- =============================================

-- Check Database Size
SELECT 
    name as DatabaseName,
    size/128.0 as SizeMB,
    size/128.0/1024.0 as SizeGB
FROM sys.master_files
WHERE DB_NAME(database_id) = 'InterviewPractice';

-- Check Table Sizes
SELECT 
    t.name as TableName,
    p.rows as RowCount,
    SUM(a.total_pages) * 8 as TotalSpaceKB,
    SUM(a.used_pages) * 8 as UsedSpaceKB,
    (SUM(a.total_pages) - SUM(a.used_pages)) * 8 as UnusedSpaceKB
FROM sys.tables t
INNER JOIN sys.indexes i ON t.object_id = i.object_id
INNER JOIN sys.partitions p ON i.object_id = p.object_id AND i.index_id = p.index_id
INNER JOIN sys.allocation_units a ON p.partition_id = a.container_id
WHERE t.name NOT LIKE 'dt%' AND i.object_id > 255
GROUP BY t.name, p.rows
ORDER BY TotalSpaceKB DESC;

-- =============================================
-- 23. SAMPLE INTERVIEW QUESTIONS WITH ANSWERS
-- =============================================

-- Q: Find employees who earn more than their manager
SELECT 
    e.FirstName + ' ' + e.LastName as Employee,
    e.Salary as EmployeeSalary,
    m.FirstName + ' ' + m.LastName as Manager,
    m.Salary as ManagerSalary
FROM Employees e
JOIN Employees m ON e.ManagerID = m.EmployeeID
WHERE e.Salary > m.Salary;

-- Q: Find departments with no employees
SELECT d.DepartmentName
FROM Departments d
LEFT JOIN Employees e ON d.DepartmentID = e.DepartmentID
WHERE e.EmployeeID IS NULL;

-- Q: Find employees hired in the same year
SELECT 
    e1.FirstName + ' ' + e1.LastName as Employee1,
    e2.FirstName + ' ' + e2.LastName as Employee2,
    YEAR(e1.HireDate) as HireYear
FROM Employees e1
JOIN Employees e2 ON YEAR(e1.HireDate) = YEAR(e2.HireDate)
                  AND e1.EmployeeID < e2.EmployeeID
ORDER BY HireYear;

-- Q: Calculate running difference in salary
SELECT 
    FirstName + ' ' + LastName as EmployeeName,
    Salary,
    Salary - LAG(Salary) OVER (ORDER BY Salary) as SalaryDifference,
    CASE 
        WHEN LAG(Salary) OVER (ORDER BY Salary) IS NULL THEN 'First Record'
        WHEN Salary > LAG(Salary) OVER (ORDER BY Salary) THEN 'Higher'
        ELSE 'Lower'
    END as Comparison
FROM Employees
ORDER BY Salary;

-- Q: Find the most recent order for each customer
WITH CustomerLatestOrder AS (
    SELECT 
        CustomerID,
        MAX(OrderDate) as LatestOrderDate
    FROM Orders
    GROUP BY CustomerID
)
SELECT 
    o.CustomerID,
    o.OrderID,
    o.OrderDate,
    o.TotalAmount
FROM Orders o
JOIN CustomerLatestOrder clo ON o.CustomerID = clo.CustomerID 
                             AND o.OrderDate = clo.LatestOrderDate;

-- =============================================
-- END OF DEMO SCRIPTS
-- =============================================

-- Summary of covered topics:
-- 1. ✓ Indexes creation (Clustered, Non-clustered, Composite, Covering, Unique)
-- 2. ✓ Stored Procedures (Simple, with parameters, error handling, transactions)
-- 3. ✓ Views (Simple, Complex, Indexed views)
-- 4. ✓ Window Functions (ROW_NUMBER, RANK, DENSE_RANK, NTILE, SUM, AVG, MIN, MAX, LAG, LEAD)
-- 5. ✓ Joins (INNER, LEFT, RIGHT, FULL OUTER, CROSS, SELF)
-- 6. ✓ CTE (Common Table Expression - Simple, Recursive, Multiple)
-- 7. ✓ Dynamic Queries (Simple, Parameterized, Pivot)
-- 8. ✓ Query Optimization techniques and examples
-- 9. ✓ Deadlock simulation and handling
-- 10. ✓ Isolation Levels (READ UNCOMMITTED, READ COMMITTED, REPEATABLE READ, SERIALIZABLE, SNAPSHOT)
-- 11. ✓ Primary Key and Foreign Key differences with examples
-- 12. ✓ UNION vs UNION ALL with performance comparison
-- 13. ✓ Types of Joins with detailed examples
-- 14. ✓ CHAR vs VARCHAR data types with storage demonstration
-- 15. ✓ Analytical Functions (FIRST_VALUE, LAST_VALUE, PERCENT_RANK, CUME_DIST)
-- 16. ✓ Functions vs Procedures differences with examples
-- 17. ✓ Find Duplicate Records (Multiple methods)
-- 18. ✓ Find Nth Highest Salary (Multiple methods)

PRINT 'Demo database setup complete! You can now practice with all the SQL topics.';
PRINT 'Remember to execute sections individually for better understanding.';
PRINT 'Use SET STATISTICS IO ON/OFF and actual execution plans for performance analysis.';






-----------============================
EXEC sp_addlinkedserver   
    @server     = 'ProductsServer',        -- Friendly name you will use in queries
    @srvproduct = '',                      -- Must be empty string, not NULL
    @provider   = 'SQLNCLI11',             -- Or use 'MSOLEDBSQL' or 'SQLNCLI' based on what's installed
    @datasrc    = '10.10.1.219';           -- Remote SQL Server IP
EXEC sp_addlinkedsrvlogin  
    @rmtsrvname = 'ProductsServer',  
    @useself = 'true';   -- Use your current Windows credentials (no username/password)
SELECT TOP 5 * 
FROM [ProductsServer].[DataAnalytics_LAD].[dbo].[LessonPlan];