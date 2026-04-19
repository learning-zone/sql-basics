# MSSQL-Server 2025 Basics

> *Click &#9733; if you like the project. Your contributions are heartily ♡ welcome.*

<br/>

## Related Topics

* *[SQL Commands](sql-commands.md)*
* *[SQL Query Practice](sql-query-practice.md)*
* *[SQL Multiple Choice Questions](sql-mcq.md)*

<br/>

## Table of Contents

* [Introduction](#-1-introduction)
* [SQL Data Types](#-2-sql-data-types)
* [SQL Database](#-3-sql-database)
* [SQL Table](#-4-sql-table)
* [SQL Select](#-5-sql-select)
* [SQL Clause](#-6-sql-clause)
* [SQL Order By](#-7-sql-order-by)
* [SQL Insert](#-8-sql-insert)
* [SQL Update](#-9-sql-update)
* [SQL Delete](#-10-sql-delete)
* [SQL Keys](#-11-sql-keys)
* [SQL Join](#-12-sql-join)
* [SQL RegEx](#-13-sql-regex)
* [SQL Indexes](#-14-sql-indexes)
* [SQL Wildcards](#-15-sql-wildcards)
* [SQL Date Format](#-16-sql-date-format)
* [SQL Transactions](#-17-sql-transactions)
* [SQL Functions](#-18-sql-functions)
* [SQL View](#-19-sql-view)
* [SQL Triggers](#-20-sql-triggers)
* [SQL Cursors](#-21-sql-cursors)
* [SQL Stored Procedures](#-22-sql-stored-procedures)
* [Miscellaneous](#-23-miscellaneous)

<br/>

## # 1. Introduction

<br/>

## Q. What is a database?

A database is a systematic or organized collection of related information stored in such a way that it can be easily accessed, retrieved, managed, and updated.

In SQL Server 2022, you create a database using `CREATE DATABASE`:

**Syntax:**

```sql
CREATE DATABASE database_name
[ ON PRIMARY (
    NAME = logical_name,
    FILENAME = 'path\file.mdf',
    SIZE = size,
    MAXSIZE = max_size,
    FILEGROWTH = growth_increment
  )
]
[ LOG ON (
    NAME = log_logical_name,
    FILENAME = 'path\file.ldf'
  )
];
```

**Example:**

```sql
CREATE DATABASE SalesDB
ON PRIMARY (
    NAME = SalesDB_Data,
    FILENAME = 'C:\SQLData\SalesDB.mdf',
    SIZE = 100MB,
    MAXSIZE = 1GB,
    FILEGROWTH = 10MB
)
LOG ON (
    NAME = SalesDB_Log,
    FILENAME = 'C:\SQLData\SalesDB_log.ldf',
    SIZE = 20MB,
    MAXSIZE = 500MB,
    FILEGROWTH = 5MB
);

USE SalesDB;
GO
```

<div align="right">
    <b><a href="#table-of-contents">↥ back to top</a></b>
</div>

## Q. What is a database table?

A database table is a structure that organizes data into rows and columns. Each row represents a record and each column represents a field (attribute).

**Example:**

```sql
CREATE TABLE Employees (
    EmployeeID   INT           IDENTITY(1,1) PRIMARY KEY,
    FirstName    NVARCHAR(50)  NOT NULL,
    LastName     NVARCHAR(50)  NOT NULL,
    HireDate     DATE          NOT NULL DEFAULT CAST(GETDATE() AS DATE),
    Salary       DECIMAL(10,2) NULL
);

SELECT * FROM Employees;
```

<div align="right">
    <b><a href="#table-of-contents">↥ back to top</a></b>
</div>

## Q. What is a database relationship?

Database relationships are associations between tables created using join statements. They improve table structure and reduce redundant data.

**Types of Database Relationships:**

**1. One-to-One:**

```sql
CREATE TABLE EmployeeContact (
    ContactID   INT PRIMARY KEY,
    EmployeeID  INT UNIQUE NOT NULL,
    Phone       NVARCHAR(20),
    CONSTRAINT fk_emp_contact FOREIGN KEY (EmployeeID)
        REFERENCES Employees(EmployeeID)
);
```

**2. One-to-Many:**

```sql
CREATE TABLE Departments (DeptID INT PRIMARY KEY, DeptName NVARCHAR(100) NOT NULL);

CREATE TABLE Staff (
    StaffID INT PRIMARY KEY,
    DeptID  INT NOT NULL,
    Name    NVARCHAR(100),
    CONSTRAINT fk_staff_dept FOREIGN KEY (DeptID) REFERENCES Departments(DeptID)
);
```

**3. Many-to-Many (junction table):**

```sql
CREATE TABLE Students (StudentID INT PRIMARY KEY, Name NVARCHAR(100));
CREATE TABLE Courses  (CourseID  INT PRIMARY KEY, Title NVARCHAR(100));

CREATE TABLE StudentCourses (
    StudentID INT NOT NULL,
    CourseID  INT NOT NULL,
    PRIMARY KEY (StudentID, CourseID),
    FOREIGN KEY (StudentID) REFERENCES Students(StudentID),
    FOREIGN KEY (CourseID)  REFERENCES Courses(CourseID)
);
```

<div align="right">
    <b><a href="#table-of-contents">↥ back to top</a></b>
</div>

## Q. What is data Integrity?

Data Integrity defines the accuracy and consistency of data stored in a database. SQL Server enforces it through constraints and triggers.

**1. Entity Integrity** – unique, non-null row identifiers.

```sql
CREATE TABLE Products (
    ProductID   INT          PRIMARY KEY,
    ProductCode NVARCHAR(20) UNIQUE NOT NULL
);
```

**2. Referential Integrity** – relationships between tables stay valid.

```sql
ALTER TABLE OrderItems
ADD CONSTRAINT fk_product FOREIGN KEY (ProductID)
    REFERENCES Products(ProductID)
    ON DELETE CASCADE ON UPDATE CASCADE;
```

**3. Domain Integrity** – values stay within valid ranges.

```sql
ALTER TABLE Employees
ADD CONSTRAINT chk_salary   CHECK (Salary > 0),
ADD CONSTRAINT df_hiredate  DEFAULT GETDATE() FOR HireDate;
```

**4. User-Defined Integrity** – business rules via triggers.

```sql
CREATE TRIGGER trg_PreventNegativeStock
ON Inventory AFTER UPDATE
AS
BEGIN
    IF EXISTS (SELECT 1 FROM inserted WHERE Quantity < 0)
    BEGIN
        RAISERROR('Stock cannot be negative.', 16, 1);
        ROLLBACK TRANSACTION;
    END
END;
```

<div align="right">
    <b><a href="#table-of-contents">↥ back to top</a></b>
</div>

## Q. What are the two principles of the relational database model?

1. **Entity Integrity** – every table has a primary key that is unique and NOT NULL.
2. **Referential Integrity** – every foreign key value must match an existing primary key, or be NULL.

**Example:**

```sql
CREATE TABLE Categories (
    CategoryID   INT          NOT NULL PRIMARY KEY,   -- entity integrity
    CategoryName NVARCHAR(50) NOT NULL
);

CREATE TABLE Items (
    ItemID     INT           NOT NULL PRIMARY KEY,
    CategoryID INT           NOT NULL,
    ItemName   NVARCHAR(100) NOT NULL,
    CONSTRAINT fk_category FOREIGN KEY (CategoryID)   -- referential integrity
        REFERENCES Categories(CategoryID)
);
```

<div align="right">
    <b><a href="#table-of-contents">↥ back to top</a></b>
</div>

## Q. What relational operations can be performed on a database?

| Operation | SQL Keyword | Description |
|-----------|-------------|-------------|
| Union | `UNION` | Combines result sets, removes duplicates |
| Intersection | `INTERSECT` | Returns rows common to both sets |
| Difference | `EXCEPT` | Rows in first set not in second |
| Cartesian Product | `CROSS JOIN` | Every row of A paired with every row of B |

**Example:**

```sql
CREATE TABLE #SetA (ID INT);
CREATE TABLE #SetB (ID INT);
INSERT INTO #SetA VALUES (1),(2),(3);
INSERT INTO #SetB VALUES (2),(3),(4);

SELECT ID FROM #SetA UNION     SELECT ID FROM #SetB;   -- 1,2,3,4
SELECT ID FROM #SetA INTERSECT SELECT ID FROM #SetB;   -- 2,3
SELECT ID FROM #SetA EXCEPT    SELECT ID FROM #SetB;   -- 1

SELECT a.ID AS A_ID, b.ID AS B_ID FROM #SetA a CROSS JOIN #SetB b; -- 9 rows
```

<div align="right">
    <b><a href="#table-of-contents">↥ back to top</a></b>
</div>

## Q. What is database normalization?

Normalization organizes a database to reduce redundancy and improve data integrity through a series of normal forms.

**Example – unnormalized → 3NF:**

```sql
-- 3NF: no transitive dependencies
CREATE TABLE Departments (
    DeptID   INT          PRIMARY KEY,
    DeptName NVARCHAR(100) NOT NULL
);

CREATE TABLE Employees_3NF (
    EmpID   INT          PRIMARY KEY,
    EmpName NVARCHAR(100) NOT NULL,
    DeptID  INT          NOT NULL REFERENCES Departments(DeptID)
);
```

<div align="right">
    <b><a href="#table-of-contents">↥ back to top</a></b>
</div>

## Q. What are the different types of normalization?

| Normal Form | Rule |
|-------------|------|
| 1NF | Atomic column values; no repeating groups |
| 2NF | 1NF + every non-key attribute fully depends on the whole PK |
| 3NF | 2NF + no transitive dependencies |
| BCNF | Every determinant is a candidate key |
| 4NF | BCNF + no multi-valued dependencies |
| 5NF | 4NF + no join dependencies not implied by candidate keys |

**Example – 1NF fix:**

```sql
-- Fix: separate repeating products into OrderLines
CREATE TABLE OrderLines (
    OrderID   INT NOT NULL,
    ProductID INT NOT NULL,
    Quantity  INT NOT NULL,
    PRIMARY KEY (OrderID, ProductID)
);
```

<div align="right">
    <b><a href="#table-of-contents">↥ back to top</a></b>
</div>

## Q. How is de-normalization different from normalization?

- **Normalization** reduces redundancy but can slow reads due to joins.
- **De-normalization** adds controlled redundancy to speed up read-heavy queries (e.g., data warehouses).

**Example:**

```sql
-- De-normalized reporting table (pre-joined for fast reads)
CREATE TABLE OrderSummary (
    OrderID      INT           PRIMARY KEY,
    CustomerName NVARCHAR(100),
    ProductName  NVARCHAR(100),
    TotalAmount  DECIMAL(10,2),
    OrderDate    DATE
);

INSERT INTO OrderSummary
SELECT o.OrderID, c.Name, p.ProductName, o.Total, o.OrderDate
FROM   Orders o
JOIN   Customers c ON o.CustomerID = c.CustomerID
JOIN   Products  p ON o.ProductID  = p.ProductID;
```

<div align="right">
    <b><a href="#table-of-contents">↥ back to top</a></b>
</div>

## Q. What are the levels of data abstraction?

1. **Physical level** – how data is stored (files, pages, extents).
2. **Logical level** – tables, columns, relationships, constraints.
3. **View level** – filtered subsets exposed to users (VIEWs, row-level security).

**Example – view-level abstraction:**

```sql
CREATE VIEW vw_ActiveEmployees AS
SELECT EmployeeID, FirstName + ' ' + LastName AS FullName, DeptID
FROM   Employees
WHERE  IsActive = 1;
GO

-- Application queries only the view
SELECT * FROM vw_ActiveEmployees;
```

<div align="right">
    <b><a href="#table-of-contents">↥ back to top</a></b>
</div>

## Q. What is data independence?

Data independence is the ability to change the schema at one level without affecting the schema at the next higher level.

- **Physical data independence** – move/resize data files without changing the logical schema.
- **Logical data independence** – add columns to a table without breaking views or applications.

**Example:**

```sql
-- Add a column without breaking the existing view
ALTER TABLE Employees ADD Department NVARCHAR(50) NULL;

SELECT * FROM vw_ActiveEmployees;  -- still works unchanged
```

<div align="right">
    <b><a href="#table-of-contents">↥ back to top</a></b>
</div>

## Q. How is a view related to data independence?

A VIEW stores a query, not data. Applications query the view so underlying schema changes (renamed tables, added columns) don\'t break the application as long as the view definition is updated.

```sql
CREATE VIEW vw_CustomerOrders AS
SELECT c.CustomerID, c.Name, o.OrderID, o.Total
FROM   Customers c
JOIN   Orders o ON o.CustomerID = c.CustomerID;

-- Application always queries the view — isolated from schema changes
SELECT * FROM vw_CustomerOrders WHERE CustomerID = 5;
```

<div align="right">
    <b><a href="#table-of-contents">↥ back to top</a></b>
</div>

## Q. Why are E-R models used?

E-R (Entity-Relationship) models visually design the database schema before implementation, showing entities, attributes, and relationships — a blueprint for DDL scripts.

**Example – E-R entities translated to SQL:**

```sql
CREATE TABLE Customers (
    CustomerID   INT           IDENTITY(1,1) PRIMARY KEY,
    CustomerName NVARCHAR(100) NOT NULL,
    Email        NVARCHAR(150) UNIQUE NOT NULL
);

CREATE TABLE Orders (
    OrderID    INT  IDENTITY(1,1) PRIMARY KEY,
    CustomerID INT  NOT NULL REFERENCES Customers(CustomerID),
    OrderDate  DATE NOT NULL DEFAULT CAST(GETDATE() AS DATE)
);
```

<div align="right">
    <b><a href="#table-of-contents">↥ back to top</a></b>
</div>

## Q. What is cardinality and why is it used?

Cardinality describes the numerical relationship between rows of two tables. It is used in E-R design and by the SQL Server Query Optimizer to choose efficient execution plans.

| Cardinality | Example |
|-------------|---------|
| One-to-One | Employee ↔ EmployeePassport |
| One-to-Many | Department → Employees |
| Many-to-Many | Students ↔ Courses |

```sql
-- View cardinality estimates via execution plan or DMV
SELECT p.rows AS EstimatedRows
FROM   sys.partitions p
WHERE  p.object_id = OBJECT_ID('Employees')
  AND  p.index_id  IN (0, 1);
```

<div align="right">
    <b><a href="#table-of-contents">↥ back to top</a></b>
</div>

## Q. What is DDL, DML, DCL, and TCL?

| Category | Commands | Purpose |
|----------|----------|---------|
| DDL – Data Definition Language | `CREATE`, `ALTER`, `DROP`, `TRUNCATE` | Define/modify schema objects |
| DML – Data Manipulation Language | `SELECT`, `INSERT`, `UPDATE`, `DELETE`, `MERGE` | Manipulate data |
| DCL – Data Control Language | `GRANT`, `REVOKE`, `DENY` | Manage permissions |
| TCL – Transaction Control Language | `BEGIN TRAN`, `COMMIT`, `ROLLBACK`, `SAVE TRAN` | Manage transactions |

**Example:**

```sql
-- DDL
CREATE TABLE Logs (LogID INT IDENTITY PRIMARY KEY, Msg NVARCHAR(500));

-- DML
INSERT INTO Logs (Msg) VALUES ('App started');
SELECT * FROM Logs;

-- DCL
GRANT SELECT ON Logs TO [ReportUser];
DENY  DELETE ON Logs TO [ReportUser];

-- TCL
BEGIN TRANSACTION;
    UPDATE Logs SET Msg = 'Updated' WHERE LogID = 1;
COMMIT;
```

<div align="right">
    <b><a href="#table-of-contents">↥ back to top</a></b>
</div>

## Q. How to prevent SQL Injection in SQL Server?

SQL Injection inserts malicious SQL into a query. The primary defence is **parameterized queries / stored procedures**.

```sql
-- VULNERABLE – never do this
DECLARE @sql NVARCHAR(500) = 'SELECT * FROM Users WHERE Username = ''' + @Input + '''';
EXEC(@sql);

-- SAFE 1: sp_executesql with parameters
EXEC sp_executesql
    N'SELECT * FROM Users WHERE Username = @u',
    N'@u NVARCHAR(100)',
    @u = @username;

-- SAFE 2: stored procedure (parameters are always data, never code)
CREATE PROCEDURE usp_GetUser @Username NVARCHAR(100)
AS
BEGIN
    SELECT UserID, Username, Email FROM Users WHERE Username = @Username;
END;

EXEC usp_GetUser @Username = N'alice';

-- SAFE 3: least privilege — app role can only EXECUTE procs, not access tables directly
GRANT EXECUTE ON usp_GetUser TO [AppRole];
```

<div align="right">
    <b><a href="#table-of-contents">↥ back to top</a></b>
</div>

## Q. What are the large text storage types in SQL Server?

> `TEXT` and `NTEXT` are **deprecated** in SQL Server 2022. Use `VARCHAR(MAX)` / `NVARCHAR(MAX)`.

| Type | Max Storage | Use Case |
|------|-------------|----------|
| `VARCHAR(MAX)` | 2 GB | Large non-Unicode text |
| `NVARCHAR(MAX)` | 2 GB | Large Unicode text |
| `VARBINARY(MAX)` | 2 GB | Binary large objects |

**Example:**

```sql
CREATE TABLE Documents (
    DocID      INT           IDENTITY PRIMARY KEY,
    Title      NVARCHAR(200) NOT NULL,
    Body       NVARCHAR(MAX) NOT NULL,
    Attachment VARBINARY(MAX) NULL
);
```

<div align="right">
    <b><a href="#table-of-contents">↥ back to top</a></b>
</div>

## # 2. SQL Data Types

<br/>

## Q. What is the difference between CHAR and VARCHAR?

| Feature | `CHAR(n)` | `VARCHAR(n)` |
|---------|-----------|--------------|
| Length | Fixed – always n bytes | Variable – actual data length + 2 bytes |
| Padding | Padded with spaces | No padding |
| Max length | 8,000 bytes | 8,000 bytes or `MAX` (2 GB) |
| Best for | Fixed-length codes (e.g. ISO country codes) | Names, descriptions |

**Example:**

```sql
CREATE TABLE Demo (Code CHAR(10), Username VARCHAR(100));
INSERT INTO Demo VALUES ('ABC', 'alice');

SELECT DATALENGTH(Code)     AS CharLen,     -- 10
       DATALENGTH(Username) AS VarcharLen   -- 5
FROM   Demo;
```

<div align="right">
    <b><a href="#table-of-contents">↥ back to top</a></b>
</div>

## Q. What are the string data types in SQL Server 2022?

| Data Type | Max Length | Unicode | Description |
|-----------|-----------|---------|-------------|
| `CHAR(n)` | 8,000 | No | Fixed-length non-Unicode |
| `VARCHAR(n\|MAX)` | 8,000 / 2 GB | No | Variable-length non-Unicode |
| `NCHAR(n)` | 4,000 | Yes | Fixed-length Unicode (UTF-16) |
| `NVARCHAR(n\|MAX)` | 4,000 / 2 GB | Yes | Variable-length Unicode |
| `BINARY(n)` | 8,000 | — | Fixed-length binary |
| `VARBINARY(n\|MAX)` | 8,000 / 2 GB | — | Variable-length binary |

**Example:**

```sql
CREATE TABLE Products (
    ProductID   INT           IDENTITY PRIMARY KEY,
    SKU         CHAR(8)       NOT NULL,
    Name        NVARCHAR(200) NOT NULL,
    Description NVARCHAR(MAX) NULL,
    ImageData   VARBINARY(MAX) NULL
);

INSERT INTO Products (SKU, Name, Description)
VALUES ('SKU-0001', N'Laptop Pro', N'High-performance laptop');

SELECT SKU, Name FROM Products;
```

<div align="right">
    <b><a href="#table-of-contents">↥ back to top</a></b>
</div>

## # 3. SQL Database

<br/>

## Q. How to create a database in SQL Server?

```sql
-- Simple
CREATE DATABASE CompanyDB;
GO

-- With explicit file placement (SQL Server 2022)
CREATE DATABASE InventoryDB
ON PRIMARY (
    NAME = InventoryDB_Data,
    FILENAME = 'C:\SQLData\InventoryDB.mdf',
    SIZE = 256MB, MAXSIZE = UNLIMITED, FILEGROWTH = 64MB
)
LOG ON (
    NAME = InventoryDB_Log,
    FILENAME = 'C:\SQLData\InventoryDB_log.ldf',
    SIZE = 64MB, MAXSIZE = 2GB, FILEGROWTH = 32MB
);
GO

-- List all databases
SELECT name, state_desc, recovery_model_desc
FROM   sys.databases ORDER BY name;
```

<div align="right">
    <b><a href="#table-of-contents">↥ back to top</a></b>
</div>

## # 4. SQL Table

<br/>

## Q. How to create a table in SQL Server?

```sql
CREATE TABLE Employees (
    EmployeeID   INT            IDENTITY(1,1)   NOT NULL,
    FirstName    NVARCHAR(50)                   NOT NULL,
    LastName     NVARCHAR(50)                   NOT NULL,
    Email        NVARCHAR(150)                  NOT NULL,
    HireDate     DATE                           NOT NULL DEFAULT CAST(GETDATE() AS DATE),
    Salary       DECIMAL(12,2)                  NOT NULL,
    DeptID       INT                            NULL,
    IsActive     BIT                            NOT NULL DEFAULT 1,
    CONSTRAINT pk_Employees  PRIMARY KEY CLUSTERED (EmployeeID),
    CONSTRAINT uq_Email      UNIQUE (Email),
    CONSTRAINT chk_Salary    CHECK (Salary >= 0),
    CONSTRAINT fk_Dept       FOREIGN KEY (DeptID) REFERENCES Departments(DeptID)
);
GO
```

<div align="right">
    <b><a href="#table-of-contents">↥ back to top</a></b>
</div>

## Q. What are tables and fields?

- **Table**: a collection of data in rows (records) and columns (fields), representing an entity.
- **Field (column)**: a named unit of data with a specific data type and optional constraints.

```sql
CREATE TABLE Customers (
    CustomerID INT           IDENTITY(1,1) PRIMARY KEY,
    Name       NVARCHAR(100) NOT NULL,
    Email      NVARCHAR(150) UNIQUE,
    Phone      NVARCHAR(20)
);

-- Inspect columns (fields) of a table
SELECT COLUMN_NAME, DATA_TYPE, IS_NULLABLE, COLUMN_DEFAULT
FROM   INFORMATION_SCHEMA.COLUMNS
WHERE  TABLE_NAME = 'Customers';
```

<div align="right">
    <b><a href="#table-of-contents">↥ back to top</a></b>
</div>

## Q. How to delete a table in SQL Server?

```sql
-- Drop table (removes all data, indexes, constraints)
DROP TABLE Customers;

-- Safe drop (SQL Server 2016+)
DROP TABLE IF EXISTS Customers;
```

<div align="right">
    <b><a href="#table-of-contents">↥ back to top</a></b>
</div>

## Q. What is the difference between DELETE and TRUNCATE?

| Feature | `DELETE` | `TRUNCATE` |
|---------|----------|------------|
| Category | DML | DDL |
| WHERE clause | Yes | No |
| Logging | Row-by-row (fully logged) | Minimally logged |
| Fires triggers | Yes | No |
| Resets IDENTITY | No | Yes |
| Rollback inside txn | Yes | Yes |

```sql
CREATE TABLE Logs (LogID INT IDENTITY PRIMARY KEY, Msg NVARCHAR(100));
INSERT INTO Logs VALUES ('A'),('B'),('C');

DELETE FROM Logs WHERE Msg = 'A';  -- 2 rows remain, identity unchanged
TRUNCATE TABLE Logs;               -- 0 rows, IDENTITY resets to 1
```

<div align="right">
    <b><a href="#table-of-contents">↥ back to top</a></b>
</div>

## Q. What is the difference between TRUNCATE and DROP?

| Feature | `TRUNCATE` | `DROP` |
|---------|------------|--------|
| Structure | Kept | Removed |
| Data | Removed | Removed |
| Indexes/Constraints | Kept | Removed |

```sql
TRUNCATE TABLE Logs;      -- table exists, empty
DROP TABLE IF EXISTS Logs; -- table no longer exists
```

<div align="right">
    <b><a href="#table-of-contents">↥ back to top</a></b>
</div>

## Q. How to alter a table schema in SQL Server?

```sql
-- Add column
ALTER TABLE Employees ADD MiddleName NVARCHAR(50) NULL;

-- Modify column type
ALTER TABLE Employees ALTER COLUMN Phone NVARCHAR(30) NULL;

-- Drop column
ALTER TABLE Employees DROP COLUMN MiddleName;

-- Add CHECK constraint
ALTER TABLE Employees ADD CONSTRAINT chk_HireDate CHECK (HireDate >= '2000-01-01');

-- Drop constraint
ALTER TABLE Employees DROP CONSTRAINT chk_HireDate;

-- Rename column (SQL Server 2022)
EXEC sp_rename 'Employees.Phone', 'PhoneNumber', 'COLUMN';
```

<div align="right">
    <b><a href="#table-of-contents">↥ back to top</a></b>
</div>

## Q. What are heap tables in SQL Server?

A **heap** is a table stored without a clustered index. Data has no inherent order and SQL Server uses an IAM (Index Allocation Map) to track pages.

```sql
-- Heap: no primary key / clustered index
CREATE TABLE StagingOrders (
    OrderID  INT,
    Amount   DECIMAL(10,2),
    LoadedAt DATETIME2 DEFAULT SYSDATETIME()
);

-- Verify it is a heap
SELECT name, type_desc
FROM   sys.indexes
WHERE  object_id = OBJECT_ID('StagingOrders')
  AND  type = 0;   -- 0 = HEAP
```

<div align="right">
    <b><a href="#table-of-contents">↥ back to top</a></b>
</div>

## # 5. SQL Select

<br/>

## Q. What are the query types in a database?

```sql
-- SELECT
SELECT EmployeeID, FirstName, Salary FROM Employees WHERE IsActive = 1;

-- INSERT
INSERT INTO Employees (FirstName, LastName, Email, Salary, DeptID)
VALUES (N'John', N'Smith', N'john@example.com', 75000, 2);

-- UPDATE
UPDATE Employees SET Salary = Salary * 1.10 WHERE DeptID = 2;

-- DELETE
DELETE FROM Employees WHERE IsActive = 0;
```

<div align="right">
    <b><a href="#table-of-contents">↥ back to top</a></b>
</div>

## Q. What is the difference between UNION and UNION ALL?

| Feature | `UNION` | `UNION ALL` |
|---------|---------|-------------|
| Duplicates | Removed | Kept |
| Performance | Slower (requires dedup) | Faster |

```sql
CREATE TABLE #S1 (Region NVARCHAR(50), Amount DECIMAL(10,2));
CREATE TABLE #S2 (Region NVARCHAR(50), Amount DECIMAL(10,2));
INSERT INTO #S1 VALUES ('North',1000),('South',2000);
INSERT INTO #S2 VALUES ('South',2000),('East',1500);

SELECT Region, Amount FROM #S1 UNION     SELECT Region, Amount FROM #S2; -- 3 rows
SELECT Region, Amount FROM #S1 UNION ALL SELECT Region, Amount FROM #S2; -- 4 rows
```

<div align="right">
    <b><a href="#table-of-contents">↥ back to top</a></b>
</div>

## Q. What is the difference between a correlated subquery and a nested subquery?

**Nested (non-correlated)** – inner query executes once.

```sql
SELECT EmployeeID, FirstName, Salary
FROM   Employees
WHERE  Salary > (SELECT AVG(Salary) FROM Employees);
```

**Correlated** – inner query references the outer query\'s row, executes once per outer row.

```sql
SELECT e.EmployeeID, e.FirstName, e.Salary
FROM   Employees e
WHERE  e.Salary = (
    SELECT MAX(e2.Salary) FROM Employees e2 WHERE e2.DeptID = e.DeptID
);
```

> **Tip:** Rewrite correlated subqueries with window functions for better performance.

```sql
WITH Ranked AS (
    SELECT EmployeeID, FirstName, Salary,
           ROW_NUMBER() OVER (PARTITION BY DeptID ORDER BY Salary DESC) AS rn
    FROM   Employees
)
SELECT EmployeeID, FirstName, Salary FROM Ranked WHERE rn = 1;
```

<div align="right">
    <b><a href="#table-of-contents">↥ back to top</a></b>
</div>

## Q. Explain SQL Operators in SQL Server

| Sl.No | Query | Description |
|-------|-------|-------------|
| 01. | `SELECT c1 FROM t1 UNION [ALL] SELECT c1 FROM t2` | Combine rows from two queries |
| 02. | `SELECT c1 FROM t1 INTERSECT SELECT c1 FROM t2` | Rows common to both queries |
| 03. | `SELECT c1 FROM t1 EXCEPT SELECT c1 FROM t2` | Rows in first not in second |
| 04. | `SELECT c1 FROM t WHERE c1 [NOT] LIKE pattern` | Pattern match (`%`, `_`) |
| 05. | `SELECT c1 FROM t WHERE c1 [NOT] IN (list)` | Match a list of values |
| 06. | `SELECT c1 FROM t WHERE c1 BETWEEN min AND max` | Inclusive range filter |
| 07. | `SELECT c1 FROM t WHERE c1 IS [NOT] NULL` | NULL check |

```sql
SELECT * FROM Orders    WHERE OrderDate BETWEEN '2024-01-01' AND '2024-12-31';
SELECT * FROM Employees WHERE DeptID IN (1, 3, 5);
SELECT * FROM Employees WHERE LastName LIKE 'Sm%';
SELECT * FROM Employees WHERE DeptID IS NULL;
```

<div align="right">
    <b><a href="#table-of-contents">↥ back to top</a></b>
</div>

## Q. How does a correlated query work?

A correlated subquery references columns from the outer query. SQL Server evaluates it once per outer row.

```sql
-- Employees who have placed an order in the last 90 days
SELECT e.EmployeeID, e.FirstName
FROM   Employees e
WHERE  EXISTS (
    SELECT 1 FROM Orders o
    WHERE  o.SalesRepID = e.EmployeeID
      AND  o.OrderDate >= DATEADD(DAY, -90, GETDATE())
);
```

<div align="right">
    <b><a href="#table-of-contents">↥ back to top</a></b>
</div>

## Q. What is the SQL CASE statement used for?

`CASE` evaluates conditions and returns a value (if-else logic).

```sql
-- Simple CASE
SELECT EmployeeID,
       CASE DeptID
           WHEN 1 THEN 'Engineering'
           WHEN 2 THEN 'Sales'
           WHEN 3 THEN 'HR'
           ELSE        'Other'
       END AS Department
FROM   Employees;

-- Searched CASE
SELECT EmployeeID, Salary,
       CASE
           WHEN Salary < 40000  THEN 'Junior'
           WHEN Salary < 80000  THEN 'Mid-level'
           WHEN Salary < 150000 THEN 'Senior'
           ELSE                      'Executive'
       END AS SalaryBand
FROM   Employees;
```

<div align="right">
    <b><a href="#table-of-contents">↥ back to top</a></b>
</div>

## Q. What is the logical order of SQL clause execution?

SQL Server processes clauses in this order — **not** the written order:

| Step | Clause | Description |
|------|--------|-------------|
| 1 | `FROM` / `JOIN` | Build working set from source tables |
| 2 | `WHERE` | Filter individual rows |
| 3 | `GROUP BY` | Group rows into aggregates |
| 4 | `HAVING` | Filter groups |
| 5 | `SELECT` | Compute expressions; assign aliases |
| 6 | `DISTINCT` | Remove duplicate rows |
| 7 | `ORDER BY` | Sort result set |
| 8 | `TOP` / `OFFSET-FETCH` | Limit rows returned |

> **Key implication:** `WHERE` runs before `SELECT`, so you **cannot** reference a `SELECT` alias in a `WHERE` clause. Wrap in a CTE or subquery instead.

```sql
-- Cannot do: WHERE HeadCount > 3 (alias defined in SELECT step)
-- Must wrap:
WITH DeptCounts AS (
    SELECT DeptID, COUNT(*) AS HeadCount
    FROM   Employees
    WHERE  IsActive = 1
    GROUP  BY DeptID
)
SELECT DeptID, HeadCount FROM DeptCounts WHERE HeadCount > 3 ORDER BY HeadCount DESC;
```

<div align="right">
    <b><a href="#table-of-contents">↥ back to top</a></b>
</div>

## Q. How to use GROUP BY in SQL Server?

`GROUP BY` collapses rows with the same column values into a single summary row. Every non-aggregated column in SELECT must appear in GROUP BY.

```sql
-- Headcount and salary stats per department
SELECT DeptID,
       COUNT(*)    AS Headcount,
       SUM(Salary) AS TotalSalary,
       AVG(Salary) AS AvgSalary,
       MAX(Salary) AS MaxSalary,
       MIN(Salary) AS MinSalary
FROM   Employees
WHERE  IsActive = 1
GROUP  BY DeptID
ORDER  BY TotalSalary DESC;

-- Multiple columns
SELECT DeptID, YEAR(HireDate) AS HireYear, COUNT(*) AS Hires
FROM   Employees
GROUP  BY DeptID, YEAR(HireDate)
ORDER  BY DeptID, HireYear;

-- GROUPING SETS: multiple groupings in a single pass
SELECT DeptID, YEAR(HireDate) AS HireYear, COUNT(*) AS Cnt
FROM   Employees
GROUP  BY GROUPING SETS ((DeptID), (YEAR(HireDate)), ());
-- () = grand-total row
```

<div align="right">
    <b><a href="#table-of-contents">↥ back to top</a></b>
</div>

## Q. How to use TOP and DISTINCT in SQL Server?

**`TOP`** limits rows returned. **`DISTINCT`** eliminates duplicate rows.

```sql
-- TOP N rows
SELECT TOP (5) EmployeeID, FirstName, Salary
FROM   Employees ORDER BY Salary DESC;

-- TOP PERCENT
SELECT TOP (10) PERCENT EmployeeID, FirstName, Salary
FROM   Employees ORDER BY Salary DESC;

-- TOP WITH TIES: include all rows that tie on the last value
SELECT TOP (3) WITH TIES EmployeeID, FirstName, Salary
FROM   Employees ORDER BY Salary DESC;

-- DISTINCT: unique department IDs
SELECT DISTINCT DeptID FROM Employees ORDER BY DeptID;

-- DISTINCT on multiple columns (unique combinations)
SELECT DISTINCT DeptID, YEAR(HireDate) AS HireYear
FROM   Employees ORDER BY DeptID, HireYear;

-- COUNT(DISTINCT col) in aggregate
SELECT COUNT(DISTINCT DeptID) AS UniqueDepts FROM Employees;
```

<div align="right">
    <b><a href="#table-of-contents">↥ back to top</a></b>
</div>

## Q. What is a CTE (Common Table Expression) in SQL Server?

A CTE is a named temporary result set defined with `WITH` that exists only for the duration of the query. It improves readability and avoids repeating complex subqueries.

```sql
-- Basic CTE
WITH HighEarners AS (
    SELECT EmployeeID, FirstName, LastName, Salary, DeptID
    FROM   Employees
    WHERE  Salary > 80000
)
SELECT h.FirstName, h.LastName, h.Salary, d.DeptName
FROM   HighEarners h
JOIN   Departments d ON d.DeptID = h.DeptID
ORDER  BY h.Salary DESC;

-- Multiple CTEs in one query
WITH
DeptStats AS (
    SELECT DeptID, AVG(Salary) AS AvgSalary FROM Employees GROUP BY DeptID
),
AboveAvg AS (
    SELECT e.EmployeeID, e.FirstName, e.Salary, e.DeptID
    FROM   Employees e
    JOIN   DeptStats d ON d.DeptID = e.DeptID
    WHERE  e.Salary > d.AvgSalary
)
SELECT FirstName, Salary FROM AboveAvg ORDER BY Salary DESC;
```

<div align="right">
    <b><a href="#table-of-contents">↥ back to top</a></b>
</div>

## Q. What is a recursive CTE in SQL Server?

A recursive CTE calls itself. It has an **anchor member** (base case) and a **recursive member** joined with `UNION ALL`. Used for hierarchies, trees, and date series.

```sql
-- Employee hierarchy (manager → direct reports)
WITH OrgChart AS (
    -- Anchor: employees with no manager (top level)
    SELECT EmployeeID, FirstName, ManagerID, 0 AS Level
    FROM   Employees WHERE ManagerID IS NULL

    UNION ALL

    -- Recursive: employees whose manager is in OrgChart
    SELECT e.EmployeeID, e.FirstName, e.ManagerID, oc.Level + 1
    FROM   Employees  e
    JOIN   OrgChart  oc ON oc.EmployeeID = e.ManagerID
)
SELECT EmployeeID, FirstName, ManagerID, Level
FROM   OrgChart
ORDER  BY Level, EmployeeID;

-- Generate a date series (today + 30 days)
WITH Dates AS (
    SELECT CAST(GETDATE() AS DATE) AS dt
    UNION ALL
    SELECT DATEADD(DAY, 1, dt) FROM Dates WHERE dt < DATEADD(DAY, 30, GETDATE())
)
SELECT dt FROM Dates OPTION (MAXRECURSION 100);  -- default limit = 100 recursions
```

<div align="right">
    <b><a href="#table-of-contents">↥ back to top</a></b>
</div>

## # 6. SQL Clause

<br/>

## Q. What is the difference between HAVING and WHERE?

| Feature | `WHERE` | `HAVING` |
|---------|---------|----------|
| Filters | Individual rows | Groups (after GROUP BY) |
| Aggregate functions | No | Yes |
| Execution order | Before GROUP BY | After GROUP BY |

```sql
SELECT DeptID, COUNT(*) AS HeadCount, AVG(Salary) AS AvgSalary
FROM   Employees
WHERE  IsActive = 1          -- filter rows first
GROUP  BY DeptID
HAVING COUNT(*) > 5          -- then filter groups
   AND AVG(Salary) > 60000;
```

<div align="right">
    <b><a href="#table-of-contents">↥ back to top</a></b>
</div>

## Q. What are arithmetic and logical operators in SQL Server?

**Arithmetic Operators:**

| Operator | Description | Example |
|----------|-------------|---------|
| `+` | Addition | `Salary + Bonus` |
| `-` | Subtraction | `Price - Discount` |
| `*` | Multiplication | `Qty * UnitPrice` |
| `/` | Division | `Total / Count` |
| `%` | Modulo (remainder) | `ID % 2` |

**Comparison Operators:**

| Operator | Description |
|----------|-------------|
| `=` | Equal to |
| `<>` / `!=` | Not equal |
| `>`, `<` | Greater / Less than |
| `>=`, `<=` | Greater / Less than or equal |
| `BETWEEN` | Inclusive range |
| `IN` | Match a list of values |
| `LIKE` | Pattern match |
| `IS NULL` / `IS NOT NULL` | NULL check |

**Logical Operators:**

| Operator | Description |
|----------|-------------|
| `AND` | Both conditions must be true |
| `OR` | Either condition must be true |
| `NOT` | Negates a condition |
| `EXISTS` | True if subquery returns at least one row |
| `ALL` | True if all subquery values satisfy the condition |
| `ANY` / `SOME` | True if any subquery value satisfies the condition |

```sql
-- Arithmetic
SELECT EmployeeID, Salary, Salary * 1.10 AS Raised, Salary % 12 AS Remainder
FROM   Employees;

-- IN / NOT IN
SELECT * FROM Employees WHERE DeptID IN (1, 2, 3);
SELECT * FROM Employees WHERE DeptID NOT IN (4, 5);

-- BETWEEN (inclusive on both ends)
SELECT * FROM Employees WHERE Salary      BETWEEN 50000 AND 100000;
SELECT * FROM Orders    WHERE OrderDate   BETWEEN '2024-01-01' AND '2024-12-31';

-- IS NULL / IS NOT NULL
SELECT * FROM Employees WHERE ManagerID IS NULL;      -- top-level managers
SELECT * FROM Employees WHERE ManagerID IS NOT NULL;  -- has a manager

-- Logical AND / OR / NOT
SELECT * FROM Employees WHERE IsActive = 1 AND (DeptID = 1 OR DeptID = 3);
SELECT * FROM Employees WHERE NOT (Salary < 50000 OR IsActive = 0);

-- EXISTS
SELECT DeptID, DeptName FROM Departments d
WHERE  EXISTS (
    SELECT 1 FROM Employees e WHERE e.DeptID = d.DeptID AND e.IsActive = 1
);
```

<div align="right">
    <b><a href="#table-of-contents">↥ back to top</a></b>
</div>

## # 7. SQL Order By

<br/>

## Q. How does ORDER BY work in SQL Server?

`ORDER BY` is the only clause that guarantees row ordering. SQL Server 2022 supports `OFFSET-FETCH` for pagination.

```sql
-- Sort descending
SELECT EmployeeID, LastName, Salary
FROM   Employees
ORDER  BY Salary DESC;

-- Multi-column sort
SELECT EmployeeID, DeptID, LastName, Salary
FROM   Employees
ORDER  BY DeptID ASC, Salary DESC;

-- TOP N (SQL Server)
SELECT TOP (10) EmployeeID, LastName, Salary
FROM   Employees
ORDER  BY Salary DESC;

-- OFFSET-FETCH pagination (page 2, 10 rows per page)
SELECT EmployeeID, LastName, Salary
FROM   Employees
ORDER  BY Salary DESC
OFFSET 10 ROWS FETCH NEXT 10 ROWS ONLY;
```

<div align="right">
    <b><a href="#table-of-contents">↥ back to top</a></b>
</div>

## # 8. SQL Insert

<br/>

## Q. How to insert data in SQL Server?

```sql
-- Single row
INSERT INTO Employees (FirstName, LastName, Email, Salary, DeptID)
VALUES (N'Alice', N'Johnson', N'alice@example.com', 85000, 1);

-- Multiple rows
INSERT INTO Employees (FirstName, LastName, Email, Salary, DeptID)
VALUES
    (N'Bob',   N'Lee',   N'bob@example.com',   72000, 2),
    (N'Carol', N'White', N'carol@example.com', 91000, 1);

-- INSERT ... SELECT
INSERT INTO EmployeesArchive (EmployeeID, FirstName, LastName, Salary)
SELECT EmployeeID, FirstName, LastName, Salary
FROM   Employees WHERE IsActive = 0;

-- Capture generated IDENTITY value
DECLARE @NewID INT;
INSERT INTO Employees (FirstName, LastName, Email, Salary)
VALUES (N'Eve', N'Davis', N'eve@example.com', 78000);
SET @NewID = SCOPE_IDENTITY();
SELECT @NewID AS NewEmployeeID;
```

<div align="right">
    <b><a href="#table-of-contents">↥ back to top</a></b>
</div>

## # 9. SQL Update

<br/>

## Q. How to update data in SQL Server?

```sql
-- Single column
UPDATE Employees SET Salary = 90000 WHERE EmployeeID = 5;

-- Multiple columns
UPDATE Employees SET Salary = Salary * 1.05, IsActive = 1 WHERE DeptID = 2;

-- UPDATE with JOIN
UPDATE e
SET    e.DeptID = d.NewDeptID
FROM   Employees e
JOIN   DeptMapping d ON d.OldDeptID = e.DeptID;

-- UPDATE with OUTPUT clause (capture old and new values)
UPDATE Employees
SET    Salary = Salary * 1.10
OUTPUT deleted.EmployeeID, deleted.Salary AS OldSalary, inserted.Salary AS NewSalary
WHERE  DeptID = 1;
```

<div align="right">
    <b><a href="#table-of-contents">↥ back to top</a></b>
</div>

## Q. What are COMMIT and ROLLBACK in SQL Server?

```sql
-- Best practice: TRY-CATCH with explicit transaction
BEGIN TRANSACTION;
BEGIN TRY
    UPDATE Accounts SET Balance = Balance - 500 WHERE AccountID = 1;
    UPDATE Accounts SET Balance = Balance + 500 WHERE AccountID = 2;
    COMMIT TRANSACTION;
    PRINT 'Transfer successful.';
END TRY
BEGIN CATCH
    ROLLBACK TRANSACTION;
    THROW;   -- re-raise the original error
END CATCH;
```

<div align="right">
    <b><a href="#table-of-contents">↥ back to top</a></b>
</div>

## Q. Explain data modification commands in SQL Server

```sql
INSERT INTO Products (Name, Price) VALUES (N'Widget', 9.99);

INSERT INTO Products (Name, Price) VALUES (N'Gadget', 19.99),(N'Doohickey', 4.99);

INSERT INTO ProductsBackup SELECT * FROM Products;

UPDATE Products SET Price = Price * 1.05;

UPDATE Products SET Price = 0 WHERE IsDiscontinued = 1;

DELETE FROM Products WHERE IsDiscontinued = 1;

-- MERGE (upsert) – SQL Server 2008+
MERGE INTO Products AS target
USING ProductsStaging AS source ON target.ProductID = source.ProductID
WHEN MATCHED     THEN UPDATE SET target.Price = source.Price
WHEN NOT MATCHED THEN INSERT (Name, Price) VALUES (source.Name, source.Price);
```

<div align="right">
    <b><a href="#table-of-contents">↥ back to top</a></b>
</div>

## # 10. SQL Delete

<br/>

## Q. What is the difference between TRUNCATE and DELETE in SQL Server?

| Feature | `DELETE` | `TRUNCATE` |
|---------|----------|------------|
| Type | DML | DDL |
| WHERE clause | Yes | No |
| Logging | Fully logged | Minimally logged |
| Triggers | Fires | Does not fire |
| Resets IDENTITY | No | Yes |

```sql
DELETE FROM Orders WHERE OrderDate < '2020-01-01';  -- conditional, triggers fire

TRUNCATE TABLE StagingOrders;                        -- all rows, IDENTITY resets
```

<div align="right">
    <b><a href="#table-of-contents">↥ back to top</a></b>
</div>

## # 11. SQL Keys

<br/>

## Q. What is the difference between primary and foreign key?

| Feature | Primary Key | Foreign Key |
|---------|-------------|-------------|
| Purpose | Uniquely identifies each row | References PK in another table |
| Uniqueness | Must be unique | Can repeat |
| NULL | Not allowed | Allowed (optional reference) |
| Count per table | One | Many |

```sql
CREATE TABLE Departments (DeptID INT NOT NULL CONSTRAINT pk_Dept PRIMARY KEY, DeptName NVARCHAR(100) NOT NULL);

CREATE TABLE Employees (
    EmployeeID INT NOT NULL CONSTRAINT pk_Emp PRIMARY KEY,
    FirstName  NVARCHAR(50) NOT NULL,
    DeptID     INT NULL CONSTRAINT fk_EmpDept FOREIGN KEY REFERENCES Departments(DeptID)
        ON DELETE SET NULL ON UPDATE CASCADE
);
```

<div align="right">
    <b><a href="#table-of-contents">↥ back to top</a></b>
</div>

## Q. What is a unique key?

A `UNIQUE` constraint ensures all values in a column are distinct. Unlike PK, a UNIQUE column can contain one NULL.

```sql
CREATE TABLE Users (
    UserID   INT           IDENTITY PRIMARY KEY,
    Username NVARCHAR(50)  NOT NULL CONSTRAINT uq_Username UNIQUE,
    Email    NVARCHAR(150) NOT NULL CONSTRAINT uq_Email    UNIQUE
);

-- Composite unique key
ALTER TABLE Products ADD CONSTRAINT uq_SupplierSKU UNIQUE (SupplierID, SKU);
```

<div align="right">
    <b><a href="#table-of-contents">↥ back to top</a></b>
</div>

## Q. What is a foreign key?

A `FOREIGN KEY` enforces referential integrity: every FK value must exist as a PK/UNIQUE value in the referenced table, or be NULL.

```sql
CREATE TABLE Orders (
    OrderID    INT  IDENTITY PRIMARY KEY,
    CustomerID INT  NOT NULL
        CONSTRAINT fk_Order_Customer FOREIGN KEY REFERENCES Customers(CustomerID)
        ON DELETE CASCADE ON UPDATE CASCADE,
    OrderDate  DATE NOT NULL DEFAULT CAST(GETDATE() AS DATE)
);
```

<div align="right">
    <b><a href="#table-of-contents">↥ back to top</a></b>
</div>

## Q. What is a constraint in SQL Server?

| Constraint | Purpose |
|------------|---------|
| `PRIMARY KEY` | Unique, non-null row identifier |
| `UNIQUE` | No duplicate values |
| `FOREIGN KEY` | Referential integrity |
| `CHECK` | Values satisfy a Boolean expression |
| `DEFAULT` | Value when none is provided |
| `NOT NULL` | Column cannot be NULL |

```sql
CREATE TABLE Invoices (
    InvoiceID  INT           IDENTITY PRIMARY KEY,
    Amount     DECIMAL(12,2) NOT NULL CHECK (Amount > 0),
    DueDate    DATE          NOT NULL DEFAULT DATEADD(DAY, 30, GETDATE()),
    Status     NVARCHAR(20)  NOT NULL CHECK (Status IN ('Draft','Sent','Paid','Overdue')),
    CustomerID INT           NOT NULL FOREIGN KEY REFERENCES Customers(CustomerID)
);
```

<div align="right">
    <b><a href="#table-of-contents">↥ back to top</a></b>
</div>

## Q. How do I define constraints in SQL Server?

```sql
-- Inline (column-level)
CREATE TABLE Orders (
    OrderID   INT           NOT NULL PRIMARY KEY,
    OrderDate DATE          NOT NULL DEFAULT GETDATE(),
    Amount    DECIMAL(10,2) NOT NULL CHECK (Amount >= 0)
);

-- Table-level (required for composite keys)
CREATE TABLE OrderItems (
    OrderID   INT NOT NULL,
    ProductID INT NOT NULL,
    Quantity  INT NOT NULL CHECK (Quantity > 0),
    CONSTRAINT pk_OrderItems PRIMARY KEY (OrderID, ProductID),
    CONSTRAINT fk_OI_Order   FOREIGN KEY (OrderID)   REFERENCES Orders(OrderID),
    CONSTRAINT fk_OI_Product FOREIGN KEY (ProductID) REFERENCES Products(ProductID)
);

-- Add to existing table
ALTER TABLE Employees ADD CONSTRAINT chk_HireYear CHECK (YEAR(HireDate) >= 1990);
```

<div align="right">
    <b><a href="#table-of-contents">↥ back to top</a></b>
</div>

## Q. What is a candidate key?

A **candidate key** is any column(s) that could serve as the primary key — unique and NOT NULL. One is chosen as the PK; others are enforced as UNIQUE NOT NULL.

```sql
CREATE TABLE Employees (
    EmployeeID INT           IDENTITY PRIMARY KEY,  -- chosen PK
    Email      NVARCHAR(150) NOT NULL UNIQUE,        -- candidate key 1
    SSN        CHAR(11)      NOT NULL UNIQUE,        -- candidate key 2
    FirstName  NVARCHAR(50)  NOT NULL
);
```

<div align="right">
    <b><a href="#table-of-contents">↥ back to top</a></b>
</div>

## Q. What is the default index created on a primary key in SQL Server?

By default, SQL Server creates a **clustered index** on the PRIMARY KEY. The clustered index physically sorts table data in key order — only one is allowed per table.

```sql
CREATE TABLE Orders (
    OrderID   INT  IDENTITY PRIMARY KEY,  -- creates CLUSTERED index
    OrderDate DATE NOT NULL
);

-- Verify
SELECT i.name, i.type_desc, i.is_primary_key
FROM   sys.indexes i
WHERE  i.object_id = OBJECT_ID('Orders');
-- type_desc = 'CLUSTERED', is_primary_key = 1
```

<div align="right">
    <b><a href="#table-of-contents">↥ back to top</a></b>
</div>

## Q. What is a composite key?

A **composite key** is a primary key made of two or more columns whose **combination** is unique. Neither column alone needs to be unique.

```sql
-- OrderItems: (OrderID + ProductID) is unique; neither column alone is
CREATE TABLE OrderItems (
    OrderID   INT           NOT NULL,
    ProductID INT           NOT NULL,
    Quantity  INT           NOT NULL CHECK (Quantity > 0),
    UnitPrice DECIMAL(10,2) NOT NULL,
    CONSTRAINT pk_OrderItems PRIMARY KEY (OrderID, ProductID),   -- composite PK
    CONSTRAINT fk_OI_Order   FOREIGN KEY (OrderID)   REFERENCES Orders(OrderID),
    CONSTRAINT fk_OI_Product FOREIGN KEY (ProductID) REFERENCES Products(ProductID)
);

-- Query using composite key
SELECT * FROM OrderItems WHERE OrderID = 1001 AND ProductID = 5;

-- Inspect composite key columns
SELECT COLUMN_NAME, ORDINAL_POSITION
FROM   INFORMATION_SCHEMA.KEY_COLUMN_USAGE
WHERE  TABLE_NAME = 'OrderItems' AND CONSTRAINT_NAME = 'pk_OrderItems';
```

<div align="right">
    <b><a href="#table-of-contents">↥ back to top</a></b>
</div>

## Q. What are CASCADE rules (ON DELETE / ON UPDATE) in SQL Server?

| Rule | ON DELETE behaviour | ON UPDATE behaviour |
|------|---------------------|----------------------|
| `CASCADE` | Delete child rows | Update child FK values |
| `SET NULL` | Set child FK to NULL | Set child FK to NULL |
| `SET DEFAULT` | Set child FK to default | Set child FK to default |
| `NO ACTION` (default) | Raise error; reject delete | Raise error; reject update |

```sql
CREATE TABLE Departments (DeptID INT PRIMARY KEY, DeptName NVARCHAR(100) NOT NULL);

CREATE TABLE Employees (
    EmployeeID INT  IDENTITY PRIMARY KEY,
    FirstName  NVARCHAR(50) NOT NULL,
    DeptID     INT  NULL,
    CONSTRAINT fk_Emp_Dept FOREIGN KEY (DeptID) REFERENCES Departments(DeptID)
        ON DELETE SET NULL   -- if dept deleted → employee DeptID becomes NULL
        ON UPDATE CASCADE    -- if dept PK changes → employee FK updated
);

-- Test ON DELETE SET NULL
DELETE FROM Departments WHERE DeptID = 3;
SELECT * FROM Employees WHERE DeptID IS NULL;  -- affected employees

-- Disable / re-enable a FK constraint
ALTER TABLE Employees NOCHECK CONSTRAINT fk_Emp_Dept;  -- disable
ALTER TABLE Employees CHECK   CONSTRAINT fk_Emp_Dept;  -- re-enable
```

<div align="right">
    <b><a href="#table-of-contents">↥ back to top</a></b>
</div>

## # 12. SQL Join

<br/>

## Q. Explain JOIN queries in SQL Server

```sql
-- Setup
CREATE TABLE Customers (CustomerID INT PRIMARY KEY, Name NVARCHAR(100));
CREATE TABLE Orders    (OrderID INT PRIMARY KEY, CustomerID INT, Amount DECIMAL(10,2));

INSERT INTO Customers VALUES (1,'Alice'),(2,'Bob'),(3,'Carol');
INSERT INTO Orders    VALUES (1,1,500),(2,1,300),(3,2,750);

-- INNER JOIN: matched rows only
SELECT c.Name, o.OrderID, o.Amount
FROM   Customers c INNER JOIN Orders o ON o.CustomerID = c.CustomerID;

-- LEFT JOIN: all customers, NULL if no orders (Carol appears)
SELECT c.Name, o.OrderID, o.Amount
FROM   Customers c LEFT JOIN Orders o ON o.CustomerID = c.CustomerID;

-- RIGHT JOIN: all orders
SELECT c.Name, o.OrderID, o.Amount
FROM   Customers c RIGHT JOIN Orders o ON o.CustomerID = c.CustomerID;

-- FULL OUTER JOIN: all rows from both tables
SELECT c.Name, o.OrderID, o.Amount
FROM   Customers c FULL OUTER JOIN Orders o ON o.CustomerID = c.CustomerID;

-- CROSS JOIN: every customer × every order
SELECT c.Name, o.OrderID FROM Customers c CROSS JOIN Orders o;
```

<div align="right">
    <b><a href="#table-of-contents">↥ back to top</a></b>
</div>

## Q. Explain the different types of joins

| Join Type | Returns |
|-----------|---------|
| `INNER JOIN` | Only rows with a match in both tables |
| `LEFT [OUTER] JOIN` | All from left; NULL for unmatched right rows |
| `RIGHT [OUTER] JOIN` | All from right; NULL for unmatched left rows |
| `FULL [OUTER] JOIN` | All rows from both; NULL where no match |
| `CROSS JOIN` | Cartesian product |
| `SELF JOIN` | Table joined to itself |

<div align="right">
    <b><a href="#table-of-contents">↥ back to top</a></b>
</div>

## Q. What are Self Join and Cross Join?

**Self Join** – join a table to itself; useful for hierarchical data.

```sql
SELECT e.EmployeeID,
       e.FirstName + ' ' + e.LastName AS Employee,
       m.FirstName + ' ' + m.LastName AS Manager
FROM   Employees e
LEFT   JOIN Employees m ON e.ManagerID = m.EmployeeID;
```

**Cross Join** – Cartesian product (m × n rows).

```sql
SELECT s.SizeName, c.ColorName
FROM   Sizes s CROSS JOIN Colors c;
-- 4 sizes × 5 colors = 20 combinations
```

<div align="right">
    <b><a href="#table-of-contents">↥ back to top</a></b>
</div>

## Q. How to query data from multiple tables?

| Sl.No | Query | Description |
|-------|-------|-------------|
| 01. | `SELECT c1 FROM t1 INNER JOIN t2 ON …` | Matched rows only |
| 02. | `SELECT c1 FROM t1 LEFT  JOIN t2 ON …` | All from t1 |
| 03. | `SELECT c1 FROM t1 RIGHT JOIN t2 ON …` | All from t2 |
| 04. | `SELECT c1 FROM t1 FULL OUTER JOIN t2 ON …` | All rows from both |
| 05. | `SELECT c1 FROM t1 CROSS JOIN t2` | Cartesian product |
| 06. | `SELECT c1 FROM t1 A INNER JOIN t1 B ON …` | Self join |

<div align="right">
    <b><a href="#table-of-contents">↥ back to top</a></b>
</div>

## Q. What is a FULL OUTER JOIN?

Returns all rows from both tables; NULL where no match.

```sql
SELECT c.Name, o.OrderID, o.Amount
FROM   Customers c FULL OUTER JOIN Orders o ON o.CustomerID = c.CustomerID;
```

<div align="right">
    <b><a href="#table-of-contents">↥ back to top</a></b>
</div>

## Q. What is an INNER JOIN?

Returns only rows where the join condition is met in both tables.

```sql
SELECT c.Name, o.OrderID, o.Amount
FROM   Customers c INNER JOIN Orders o ON o.CustomerID = c.CustomerID;
```

<div align="right">
    <b><a href="#table-of-contents">↥ back to top</a></b>
</div>

## Q. What is a LEFT JOIN?

Returns all rows from the left table; NULL for unmatched right-table columns.

```sql
SELECT c.Name, o.OrderID, o.Amount
FROM   Customers c LEFT JOIN Orders o ON o.CustomerID = c.CustomerID;
-- Carol has no orders → NULL OrderID, NULL Amount
```

<div align="right">
    <b><a href="#table-of-contents">↥ back to top</a></b>
</div>

## Q. What is a RIGHT JOIN?

Returns all rows from the right table; NULL for unmatched left-table columns.

```sql
SELECT c.Name, o.OrderID, o.Amount
FROM   Customers c RIGHT JOIN Orders o ON o.CustomerID = c.CustomerID;
```

<div align="right">
    <b><a href="#table-of-contents">↥ back to top</a></b>
</div>

## Q. What is the default join type in SQL Server?

`JOIN` without a qualifier is `INNER JOIN`.

```sql
-- Identical queries:
SELECT c.Name, o.Amount FROM Customers c JOIN       Orders o ON o.CustomerID = c.CustomerID;
SELECT c.Name, o.Amount FROM Customers c INNER JOIN Orders o ON o.CustomerID = c.CustomerID;
```

<div align="right">
    <b><a href="#table-of-contents">↥ back to top</a></b>
</div>

## Q. When should you use a JOIN vs a Subquery?

| Aspect | JOIN | Subquery |
|--------|------|----------|
| Performance | Generally faster — optimiser uses indexes on both sides | Correlated subquery runs once per outer row (slow) |
| Readability | Shows relationships explicitly | Encapsulates logic in one place |
| Duplicates | May need `DISTINCT` if join multiplies rows | Naturally returns one row per outer row |
| Use case | Combine columns from multiple tables | Filter or compute a scalar from another table |

```sql
-- Three equivalent ways — JOIN is typically fastest

-- 1. JOIN
SELECT DISTINCT c.CustomerID, c.Name
FROM   Customers c
JOIN   Orders o ON o.CustomerID = c.CustomerID
WHERE  o.OrderDate >= '2024-01-01';

-- 2. Subquery with IN
SELECT CustomerID, Name FROM Customers
WHERE  CustomerID IN (
    SELECT CustomerID FROM Orders WHERE OrderDate >= '2024-01-01'
);

-- 3. EXISTS (often same plan as JOIN; stops at first match)
SELECT CustomerID, Name FROM Customers c
WHERE  EXISTS (
    SELECT 1 FROM Orders o
    WHERE  o.CustomerID = c.CustomerID AND o.OrderDate >= '2024-01-01'
);

-- Subquery in FROM (derived table) for aggregated filtering
SELECT d.DeptID, d.AvgSalary
FROM  (SELECT DeptID, AVG(Salary) AS AvgSalary
       FROM Employees GROUP BY DeptID) AS d
WHERE  d.AvgSalary > 70000;
```

<div align="right">
    <b><a href="#table-of-contents">↥ back to top</a></b>
</div>

## # 13. SQL RegEx

<br/>

## Q. How to use pattern matching in SQL Server?

SQL Server uses `LIKE` and `PATINDEX()` for pattern matching (no native REGEXP operator).

| Wildcard | Meaning |
|----------|---------|
| `%` | Zero or more characters |
| `_` | Exactly one character |
| `[list]` | Any single char in the list |
| `[^list]` | Any single char NOT in the list |

```sql
SELECT * FROM Employees WHERE LastName LIKE 'S%';             -- starts with S
SELECT * FROM Employees WHERE LastName LIKE '%son';           -- ends with son
SELECT * FROM Employees WHERE Phone    LIKE '[0-9][0-9][0-9]-[0-9][0-9][0-9][0-9]';
SELECT * FROM Products  WHERE SKU      LIKE '[A-Z][A-Z][0-9][0-9][0-9]'; -- e.g. AB012

-- Escape a literal % sign
SELECT * FROM Products WHERE Description LIKE '%50\%%' ESCAPE '\';

-- PATINDEX: returns position of first match (0 if not found)
SELECT PATINDEX('%[0-9]%', 'abc123');   -- returns 4
```

<div align="right">
    <b><a href="#table-of-contents">↥ back to top</a></b>
</div>

## # 14. SQL Indexes

<br/>

## Q. What are indexes in SQL Server?

An index is a data structure that speeds up data retrieval at the cost of additional storage and slower writes.

```sql
-- Create non-clustered index
CREATE INDEX ix_Employees_LastName ON Employees (LastName ASC);

-- Composite index
CREATE INDEX ix_Orders_CustomerDate ON Orders (CustomerID, OrderDate DESC);

-- Unique index
CREATE UNIQUE INDEX uix_Users_Email ON Users (Email);

-- Filtered index (index only active employees)
CREATE INDEX ix_ActiveEmployees ON Employees (DeptID, Salary) WHERE IsActive = 1;

-- Drop index
DROP INDEX ix_Employees_LastName ON Employees;

-- List indexes
SELECT i.name, i.type_desc, i.is_unique
FROM   sys.indexes i
WHERE  i.object_id = OBJECT_ID('Employees') AND i.type > 0;
```

<div align="right">
    <b><a href="#table-of-contents">↥ back to top</a></b>
</div>

## Q. What does an index represent in the relational database model?

An index maintains a sorted copy of one or more columns and stores pointers to the corresponding data rows, allowing the engine to find rows without scanning the entire table — similar to a book\'s index that lets you jump directly to a page.

<div align="right">
    <b><a href="#table-of-contents">↥ back to top</a></b>
</div>

## Q. What is the difference between Clustered and Non-Clustered Index?

| Feature | Clustered Index | Non-Clustered Index |
|---------|-----------------|---------------------|
| Storage | Physically orders table rows | Separate B-tree; points to data rows |
| Count per table | **One** | Up to 999 (SQL Server 2022) |
| Default on PK | Yes | No |
| Best for | Range scans, PK lookups | Specific column lookups |

```sql
-- Clustered (created by PK by default)
CREATE TABLE Sales (SaleID INT IDENTITY CONSTRAINT pk_Sales PRIMARY KEY CLUSTERED, Amount DECIMAL(10,2));

-- Non-clustered covering index (INCLUDE avoids key lookup)
CREATE NONCLUSTERED INDEX ix_Sales_Date
ON Sales (SaleDate)
INCLUDE (Amount);
```

<div align="right">
    <b><a href="#table-of-contents">↥ back to top</a></b>
</div>

## Q. How to create an index in SQL Server?

```sql
CREATE INDEX ix_LastName  ON Employees (LastName);
CREATE UNIQUE INDEX uix_Email ON Employees (Email);
CREATE CLUSTERED INDEX cx_OrderDate ON Orders (OrderDate);

-- Filtered index
CREATE NONCLUSTERED INDEX ix_RecentOrders ON Orders (CustomerID, OrderDate)
WHERE OrderDate >= '2024-01-01';

-- Columnstore index (for analytics — SQL Server 2012+)
CREATE NONCLUSTERED COLUMNSTORE INDEX ncci_Sales ON Sales (SaleDate, Amount, ProductID);

-- Maintenance
ALTER INDEX ix_LastName ON Employees REBUILD;        -- fix fragmentation
ALTER INDEX ix_LastName ON Employees REORGANIZE;     -- online, low overhead

-- Check fragmentation
SELECT i.name, s.avg_fragmentation_in_percent
FROM   sys.dm_db_index_physical_stats(DB_ID(), OBJECT_ID('Employees'), NULL, NULL, 'LIMITED') s
JOIN   sys.indexes i ON s.object_id = i.object_id AND s.index_id = i.index_id;
```

<div align="right">
    <b><a href="#table-of-contents">↥ back to top</a></b>
</div>

## Q. What are the types of indexes in SQL Server?

| Index Type | Description |
|------------|-------------|
| Clustered | Physically sorts table data; one per table |
| Non-Clustered | Separate B-tree with row locators; up to 999 per table |
| Unique | Enforces uniqueness; clustered or non-clustered |
| Filtered | Partial index on a row subset (WHERE clause) |
| Columnstore | Column-oriented; optimized for analytics (batch mode) |
| Full-Text | Linguistic text searches (`CONTAINS`, `FREETEXT`) |
| Spatial | Indexes `geometry`/`geography` columns |
| XML | Indexes XML columns |

<div align="right">
    <b><a href="#table-of-contents">↥ back to top</a></b>
</div>

## Q. What is the difference between an Index Seek and an Index Scan?

| Operation | Description | When it occurs |
|-----------|-------------|----------------|
| **Index Seek** | B-tree navigation directly to matching rows | Highly selective predicate; small % of rows returned |
| **Index Scan** | Reads all pages in the index | Low selectivity; predicate on non-indexed column |
| **Table Scan** | Reads all data pages (heap) | No usable index at all |

> **Goal**: write **SARGable** predicates so the optimiser can use Index Seeks.

```sql
-- SARGable → Index Seek
SELECT * FROM Employees WHERE EmployeeID = 42;          -- equality on PK
SELECT * FROM Orders    WHERE OrderDate >= '2024-01-01'; -- range on indexed col

-- NOT SARGable → forces Index Scan or Table Scan (avoid these)
SELECT * FROM Employees WHERE YEAR(HireDate) = 2023;     -- function on column
SELECT * FROM Employees WHERE Salary + 0 = 75000;        -- arithmetic on column

-- Fix: rewrite to be SARGable
SELECT * FROM Employees WHERE HireDate >= '2023-01-01' AND HireDate < '2024-01-01';
SELECT * FROM Employees WHERE Salary = 75000;

-- Check index usage (seek vs scan counts)
SELECT i.name, s.user_seeks, s.user_scans, s.user_lookups
FROM   sys.dm_db_index_usage_stats s
JOIN   sys.indexes i ON s.object_id = i.object_id AND s.index_id = i.index_id
WHERE  s.database_id = DB_ID() AND i.object_id = OBJECT_ID('Employees');
```

<div align="right">
    <b><a href="#table-of-contents">↥ back to top</a></b>
</div>

## Q. Can a table have multiple clustered indexes?

**No.** A table can have only **one** clustered index because the clustered index defines the physical sort order of the table\'s rows. It can have up to **999 non-clustered indexes**.

```sql
-- A table already has a clustered index (PK default)
CREATE TABLE Orders (
    OrderID   INT  IDENTITY CONSTRAINT pk_Orders PRIMARY KEY CLUSTERED,  -- CI #1
    OrderDate DATE NOT NULL
);

-- Attempting to add a second clustered index will FAIL:
-- CREATE CLUSTERED INDEX cx_OrderDate ON Orders (OrderDate);
-- Msg 1902: Cannot create more than one clustered index on table 'Orders'.

-- Solution 1: create a non-clustered index instead
CREATE NONCLUSTERED INDEX ix_OrderDate ON Orders (OrderDate);

-- Solution 2: move the clustered index off the PK
CREATE TABLE Events (
    EventID   INT           IDENTITY NOT NULL,
    EventDate DATE          NOT NULL,
    EventName NVARCHAR(100) NOT NULL,
    CONSTRAINT pk_Events PRIMARY KEY NONCLUSTERED (EventID)  -- PK = non-clustered
);
CREATE CLUSTERED INDEX cx_EventDate ON Events (EventDate);   -- CI on EventDate
```

<div align="right">
    <b><a href="#table-of-contents">↥ back to top</a></b>
</div>

## Q. What is a covering index in SQL Server?

A **covering index** includes all columns required by a query (seek key + SELECT list) so SQL Server can satisfy the query from the index alone — eliminating the need for a key lookup back to the base table.

```sql
-- Query needs: filter on IsActive, return LastName, Salary, DeptID
SELECT LastName, Salary, DeptID FROM Employees WHERE IsActive = 1;

-- Non-covering: index seek + key lookup (extra cost)
CREATE INDEX ix_Active ON Employees (IsActive);

-- Covering: index seek only (no key lookup)
CREATE NONCLUSTERED INDEX ix_Active_Covering
ON Employees (IsActive)
INCLUDE (LastName, Salary, DeptID);   -- INCLUDE = non-key covering columns

-- Multi-column seek + covering
CREATE NONCLUSTERED INDEX ix_Dept_Active_Covering
ON Employees (DeptID, IsActive)       -- seek columns (order matters)
INCLUDE (LastName, Salary);           -- cover SELECT columns

-- Verify in execution plan: look for "Index Seek" with NO "Key Lookup"
```

<div align="right">
    <b><a href="#table-of-contents">↥ back to top</a></b>
</div>

## # 15. SQL Wildcards

<br/>

## Q. How to use wildcards in SQL Server?

```sql
SELECT * FROM Employees WHERE LastName LIKE 'Mc%';           -- starts with Mc
SELECT * FROM Employees WHERE LastName LIKE '_mith';          -- one char then mith
SELECT * FROM Contacts  WHERE Phone    LIKE '[0-9][0-9][0-9]-[0-9][0-9][0-9][0-9]';
SELECT * FROM Products  WHERE SKU      LIKE '[^0-9]%';        -- does not start with digit

-- Escape literal %
SELECT * FROM Products WHERE Description LIKE '%50\%%' ESCAPE '\';

-- 5-character SKU exactly
SELECT * FROM Products WHERE SKU LIKE '_____';
```

<div align="right">
    <b><a href="#table-of-contents">↥ back to top</a></b>
</div>

## # 16. SQL Date Format

<br/>

## Q. What is the difference between DATETIME and DATETIME2 in SQL Server?

| Feature | `DATETIME` | `DATETIME2` |
|---------|------------|-------------|
| Range | 1753-01-01 to 9999-12-31 | 0001-01-01 to 9999-12-31 |
| Precision | ~3.33 ms | 100 ns (0–7 configurable) |
| Storage | 8 bytes | 6–8 bytes |
| ANSI compliant | No | Yes |
| Recommendation | Legacy only | **Preferred (SQL Server 2022)** |

**Common date functions:**

```sql
SELECT SYSDATETIME()          AS Now_DT2,          -- DATETIME2(7), high precision
       GETDATE()               AS Now_DT,           -- DATETIME
       SYSDATETIMEOFFSET()     AS Now_DTO,          -- with time zone
       FORMAT(SYSDATETIME(), 'yyyy-MM-dd HH:mm:ss') AS Formatted;

SELECT YEAR(GETDATE())  AS Yr, MONTH(GETDATE()) AS Mo, DAY(GETDATE()) AS Dy;

SELECT DATEADD(DAY,   30, GETDATE()) AS In30Days,
       DATEADD(MONTH, -1, GETDATE()) AS OneMonthAgo,
       DATEDIFF(DAY, HireDate, GETDATE()) AS DaysEmployed
FROM   Employees;

-- Safe string-to-date conversion (returns NULL on failure)
SELECT TRY_CAST('2024-06-15' AS DATE);
SELECT CONVERT(DATE, '2024-06-15', 23);  -- style 23 = yyyy-mm-dd
```

<div align="right">
    <b><a href="#table-of-contents">↥ back to top</a></b>
</div>

## # 17. SQL Transactions

<br/>

## Q. What are transactions in SQL Server?

A transaction is a unit of work that is either fully committed or fully rolled back, governed by ACID properties.

| Property | Meaning | SQL Server Mechanism |
|----------|---------|---------------------|
| Atomicity | All or nothing | `BEGIN`/`COMMIT`/`ROLLBACK` |
| Consistency | DB stays valid | Constraints, triggers |
| Isolation | Concurrent txns don\'t interfere | Locking, row versioning |
| Durability | Committed data survives failure | Write-Ahead Logging |

**Example – TRY/CATCH transaction (recommended pattern):**

```sql
BEGIN TRANSACTION;
BEGIN TRY
    UPDATE BankAccounts SET Balance = Balance - 500 WHERE AccountID = 1;
    UPDATE BankAccounts SET Balance = Balance + 500 WHERE AccountID = 2;

    IF EXISTS (SELECT 1 FROM BankAccounts WHERE Balance < 0)
        THROW 50001, 'Insufficient funds.', 1;

    COMMIT TRANSACTION;
END TRY
BEGIN CATCH
    ROLLBACK TRANSACTION;
    THROW;
END CATCH;
```

<div align="right">
    <b><a href="#table-of-contents">↥ back to top</a></b>
</div>

## Q. What is the purpose of ACID properties?

ACID ensures transactions are processed reliably. Without these properties, concurrent transactions could corrupt data (dirty reads, lost updates, phantom reads).

```sql
-- Enable READ_COMMITTED_SNAPSHOT isolation (removes reader/writer blocking)
ALTER DATABASE CompanyDB SET READ_COMMITTED_SNAPSHOT ON;

SELECT name, is_read_committed_snapshot_on
FROM   sys.databases WHERE name = 'CompanyDB';
```

<div align="right">
    <b><a href="#table-of-contents">↥ back to top</a></b>
</div>

## Q. What are the different transaction isolation levels in SQL Server?

| Level | Dirty Read | Non-Rep. Read | Phantom |
|-------|-----------|--------------|---------|
| `READ UNCOMMITTED` | Yes | Yes | Yes |
| `READ COMMITTED` (default) | No | Yes | Yes |
| `REPEATABLE READ` | No | No | Yes |
| `SNAPSHOT` | No | No | No |
| `SERIALIZABLE` | No | No | No |

```sql
SET TRANSACTION ISOLATION LEVEL READ COMMITTED;  -- default

SET TRANSACTION ISOLATION LEVEL SNAPSHOT;         -- for reporting (no blocking)
SELECT * FROM Orders WHERE OrderDate >= '2024-01-01';
```

<div align="right">
    <b><a href="#table-of-contents">↥ back to top</a></b>
</div>

## Q. What are the different lock types in SQL Server?

| Lock | Description |
|------|-------------|
| Shared (S) | Read; compatible with other S locks |
| Exclusive (X) | Write; incompatible with all other locks |
| Update (U) | Prevents deadlocks in read-then-update pattern |
| Intent (IS/IX) | Hierarchical — signals row locks exist below |
| Schema (Sch-M) | Held during DDL operations |

```sql
-- Monitor current locks
SELECT request_session_id, resource_type, resource_description, request_mode
FROM   sys.dm_tran_locks
WHERE  request_session_id > 50;
```

<div align="right">
    <b><a href="#table-of-contents">↥ back to top</a></b>
</div>

## Q. What is SAVE TRANSACTION (Savepoint) in SQL Server?

`SAVE TRANSACTION` marks a named point inside a transaction. You can `ROLLBACK TRANSACTION savepoint_name` to undo only the work done after the savepoint — without discarding the entire transaction.

```sql
BEGIN TRANSACTION;
BEGIN TRY
    -- Step 1: insert order header
    INSERT INTO Orders (CustomerID, OrderDate) VALUES (1, GETDATE());
    DECLARE @OrderID INT = SCOPE_IDENTITY();

    SAVE TRANSACTION after_header;   -- savepoint

    -- Step 2: insert order lines
    INSERT INTO OrderItems (OrderID, ProductID, Quantity) VALUES (@OrderID, 5, 2);
    INSERT INTO OrderItems (OrderID, ProductID, Quantity) VALUES (@OrderID, 8, 1);

    -- Partial rollback: undo lines only, keep header
    -- ROLLBACK TRANSACTION after_header;

    COMMIT TRANSACTION;
END TRY
BEGIN CATCH
    IF XACT_STATE() <> 0 ROLLBACK TRANSACTION;
    THROW;
END CATCH;
```

> Rolling back to a savepoint **does not end** the transaction. You must still `COMMIT` or `ROLLBACK` the outer transaction.

<div align="right">
    <b><a href="#table-of-contents">↥ back to top</a></b>
</div>

## Q. What is a deadlock in SQL Server and how do you handle it?

A **deadlock** occurs when two sessions each hold a lock the other session needs, creating a circular wait. SQL Server\'s deadlock monitor detects this and kills one session (the **deadlock victim**) with error 1205.

```
Session A holds lock on Table1, waits for Table2
Session B holds lock on Table2, waits for Table1  → circular wait → deadlock
```

**Prevention strategies:**

```sql
-- 1. Access tables in a consistent order across all transactions

-- 2. Keep transactions short — commit as soon as possible
BEGIN TRANSACTION;
    UPDATE Orders SET Status = 'Processing' WHERE OrderID = @ID;
COMMIT;  -- commit immediately; don\'t hold open during application logic

-- 3. Use READ_COMMITTED_SNAPSHOT isolation (readers don\'t block writers)
ALTER DATABASE CompanyDB SET READ_COMMITTED_SNAPSHOT ON;

-- 4. Add indexes to reduce lock duration
CREATE INDEX ix_OrderStatus ON Orders (Status) INCLUDE (OrderID);

-- 5. Detect deadlocks via Extended Events / System Health session
SELECT xdr.value('@timestamp', 'datetime2') AS DeadlockTime,
       xdr.query('.')                        AS DeadlockGraph
FROM (
    SELECT CAST(target_data AS XML) AS target_data
    FROM   sys.dm_xe_session_targets t
    JOIN   sys.dm_xe_sessions s ON s.address = t.event_session_address
    WHERE  s.name = 'system_health' AND t.target_name = 'ring_buffer'
) AS data
CROSS APPLY target_data.nodes('//RingBufferTarget/event[@name="xml_deadlock_report"]') AS XEventData(xdr);
```

<div align="right">
    <b><a href="#table-of-contents">↥ back to top</a></b>
</div>

## # 18. SQL Functions

<br/>

## Q. What is a function in SQL Server?

A function accepts parameters, performs an operation, and returns a result. There are scalar and table-valued variants.

```sql
-- Scalar UDF
CREATE FUNCTION dbo.fn_FullName (@First NVARCHAR(50), @Last NVARCHAR(50))
RETURNS NVARCHAR(101)
WITH SCHEMABINDING
AS
BEGIN
    RETURN LTRIM(RTRIM(@First)) + N' ' + LTRIM(RTRIM(@Last));
END;
GO

SELECT dbo.fn_FullName(FirstName, LastName) AS FullName FROM Employees;

-- Inline table-valued function (best performance — inlined by optimiser)
CREATE FUNCTION dbo.fn_EmployeesByDept (@DeptID INT)
RETURNS TABLE WITH SCHEMABINDING
AS
    RETURN SELECT EmployeeID, FirstName, LastName, Salary
           FROM   dbo.Employees WHERE DeptID = @DeptID;
GO

SELECT * FROM dbo.fn_EmployeesByDept(2);
```

<div align="right">
    <b><a href="#table-of-contents">↥ back to top</a></b>
</div>

## Q. What are the different types of functions in SQL Server?

| Category | Type | Example Functions |
|----------|------|------------------|
| User-Defined | Scalar UDF | Custom single-value function |
| User-Defined | Inline TVF | Returns a table (single SELECT) |
| User-Defined | Multi-statement TVF | Returns table built by multiple statements |
| System – Aggregate | Aggregate | `COUNT`, `SUM`, `AVG`, `MIN`, `MAX` |
| System – String | Scalar | `LEN`, `UPPER`, `TRIM`, `REPLACE`, `CONCAT`, `FORMAT`, `STRING_AGG` |
| System – Date | Scalar | `GETDATE`, `SYSDATETIME`, `DATEADD`, `DATEDIFF`, `FORMAT` |
| System – Math | Scalar | `ABS`, `ROUND`, `FLOOR`, `CEILING`, `POWER`, `SQRT` |
| System – Window | Window | `ROW_NUMBER`, `RANK`, `DENSE_RANK`, `LAG`, `LEAD`, `NTILE` |
| System – Conversion | Scalar | `CAST`, `CONVERT`, `TRY_CAST`, `TRY_CONVERT`, `PARSE` |

<div align="right">
    <b><a href="#table-of-contents">↥ back to top</a></b>
</div>

## Q. What are the reporting aggregate functions in SQL Server?

```sql
SELECT
    COUNT(*)               AS TotalRows,
    COUNT(DISTINCT Region) AS UniqueRegions,
    SUM(Amount)            AS TotalRevenue,
    AVG(Amount)            AS AvgSale,
    MIN(Amount)            AS MinSale,
    MAX(Amount)            AS MaxSale,
    STDEV(Amount)          AS StdDev
FROM Sales;

-- Grouped aggregates
SELECT Region, COUNT(*) AS Cnt, SUM(Amount) AS Total, AVG(Amount) AS Avg
FROM   Sales
GROUP  BY Region
HAVING SUM(Amount) > 2000
ORDER  BY Total DESC;

-- STRING_AGG (SQL Server 2017+)
SELECT DeptID,
       STRING_AGG(FirstName, ', ') WITHIN GROUP (ORDER BY FirstName) AS Team
FROM   Employees
GROUP  BY DeptID;
```

<div align="right">
    <b><a href="#table-of-contents">↥ back to top</a></b>
</div>

## Q. What are aggregate and scalar functions?

- **Aggregate**: operates on multiple rows, returns one result per group.
- **Scalar**: operates on one value per row.

```sql
-- Scalar functions
SELECT
    LEN(N'Hello World')                 AS Len,          -- 11
    UPPER(N'hello')                     AS Upper,        -- HELLO
    TRIM(N'  spaces  ')                 AS Trimmed,      -- spaces
    REPLACE(N'foo bar', N'bar', N'baz') AS Replaced,     -- foo baz
    CONCAT(N'SQL', N' ', N'Server')     AS Concat,       -- SQL Server
    ROUND(3.14159, 2)                   AS Rounded,      -- 3.14
    ABS(-42)                            AS AbsVal,       -- 42
    ISNULL(NULL, N'default')            AS NullCheck,    -- default
    COALESCE(NULL, NULL, N'first')      AS Coalesced;    -- first
```

<div align="right">
    <b><a href="#table-of-contents">↥ back to top</a></b>
</div>

## Q. What is the difference between ISNULL() and COALESCE()?

| Feature | `ISNULL(expr, replacement)` | `COALESCE(expr1, expr2, …)` |
|---------|-----------------------------|-----------------------------|
| Arguments | 2 | 2 or more |
| Standard | T-SQL only | ANSI SQL |
| Return type | Type of first argument | Highest-precedence arg type |
| Best for | Simple NULL-to-default swap | First non-NULL from many options |

```sql
SELECT ISNULL(NULL, 'default');           -- 'default'
SELECT COALESCE(NULL, NULL, 'first');     -- 'first'

-- COALESCE with multiple fallbacks
SELECT EmployeeID,
       COALESCE(PreferredName, NickName, FirstName, 'Unknown') AS DisplayName
FROM   Employees;

-- ISNULL in aggregates (treats NULL as 0)
SELECT AVG(ISNULL(Bonus, 0)) AS AvgBonusInclNull FROM Employees;
SELECT AVG(Bonus)            AS AvgBonusExclNull FROM Employees;  -- skips NULLs

-- COALESCE in UPDATE
UPDATE Employees
SET    Phone = COALESCE(MobilePhone, OfficePhone, 'N/A')
WHERE  Phone IS NULL;
```

<div align="right">
    <b><a href="#table-of-contents">↥ back to top</a></b>
</div>

## Q. How to use SUBSTRING, CHARINDEX, and LEN in SQL Server?

```sql
-- LEN: character count (excludes trailing spaces; use DATALENGTH for bytes)
SELECT LEN('Hello World');                   -- 11
SELECT DATALENGTH(N'Hello');                 -- 10 bytes (Unicode, 2 bytes/char)

-- SUBSTRING(string, start, length)  -- 1-based index
SELECT SUBSTRING('SQL Server 2022', 5, 6);  -- 'Server'

-- Extract username from email
SELECT SUBSTRING(Email, 1, CHARINDEX('@', Email) - 1) AS Username
FROM   Employees;

-- CHARINDEX(find, string [, startPos])  -- returns 0 if not found
SELECT CHARINDEX('Server', 'SQL Server 2022');  -- 5
SELECT CHARINDEX('@', 'alice@example.com');      -- 6

-- Extract domain from email
SELECT Email,
       SUBSTRING(Email,
                 CHARINDEX('@', Email) + 1,
                 LEN(Email) - CHARINDEX('@', Email)) AS Domain
FROM   Employees;

-- LEFT / RIGHT shortcuts
SELECT LEFT('SQL Server', 3);   -- 'SQL'
SELECT RIGHT('SQL Server', 6);  -- 'Server'

-- PATINDEX: find position of a pattern (0 = not found)
SELECT PATINDEX('%[0-9]%', 'abc123');  -- 4
```

<div align="right">
    <b><a href="#table-of-contents">↥ back to top</a></b>
</div>

## Q. What is the difference between CAST and CONVERT in SQL Server?

| Feature | `CAST(expr AS type)` | `CONVERT(type, expr [, style])` |
|---------|----------------------|----------------------------------|
| Standard | ANSI SQL | T-SQL only |
| Style parameter | No | Yes (dates, binary) |
| Portability | More portable | More formatting options |

```sql
-- CAST
SELECT CAST(12345   AS NVARCHAR(10));   -- '12345'
SELECT CAST('2024-06-15' AS DATE);      -- 2024-06-15
SELECT CAST(3.14159 AS DECIMAL(5,2));   -- 3.14

-- CONVERT with date styles
SELECT CONVERT(NVARCHAR(20), GETDATE(), 103);  -- dd/mm/yyyy
SELECT CONVERT(NVARCHAR(20), GETDATE(), 23);   -- yyyy-mm-dd
SELECT CONVERT(NVARCHAR(20), GETDATE(), 108);  -- hh:mm:ss

-- TRY_CAST / TRY_CONVERT – return NULL on failure instead of error
SELECT TRY_CAST('abc'        AS INT);   -- NULL (no error)
SELECT TRY_CONVERT(INT, 'abc');         -- NULL
SELECT TRY_CAST('2024-06-15' AS DATE);  -- 2024-06-15
```

<div align="right">
    <b><a href="#table-of-contents">↥ back to top</a></b>
</div>

## Q. What is the difference between deterministic and non-deterministic functions?

| Type | Definition | Examples |
|------|-----------|---------|
| **Deterministic** | Same inputs → same output every time | `LEN()`, `UPPER()`, `DATEADD()`, `CAST()`, `ABS()` |
| **Non-deterministic** | Output can differ per call | `GETDATE()`, `NEWID()`, `RAND()`, `SYSDATETIME()` |

> Only **deterministic** functions are allowed in indexed views, computed column indexes, and `WITH SCHEMABINDING` scalar UDFs.

```sql
-- Deterministic (safe in persisted columns / indexed views)
SELECT LEN('hello');                        -- always 5
SELECT UPPER('sql');                        -- always 'SQL'
SELECT DATEADD(DAY, 7, '2024-01-01');       -- always '2024-01-08'

-- Non-deterministic (avoid in indexed views / persisted columns)
SELECT GETDATE();   -- current timestamp, changes every call
SELECT NEWID();     -- new GUID every call
SELECT RAND();      -- random float every call

-- Persisted computed column requires deterministic expression
ALTER TABLE Employees
ADD FullName AS (FirstName + ' ' + LastName) PERSISTED;  -- deterministic ✔

-- This would FAIL (GETDATE() is non-deterministic):
-- ADD LoadedAt AS (GETDATE()) PERSISTED;
```

<div align="right">
    <b><a href="#table-of-contents">↥ back to top</a></b>
</div>

## # 19. SQL View

<br/>

## Q. What is a View in SQL Server?

A view is a saved SELECT query exposed as a virtual table. It does not store data (unless indexed).

```sql
-- Create view
CREATE VIEW vw_ActiveEmployees AS
SELECT e.EmployeeID,
       e.FirstName + ' ' + e.LastName AS FullName,
       d.DeptName, e.Salary
FROM   Employees e
JOIN   Departments d ON d.DeptID = e.DeptID
WHERE  e.IsActive = 1;
GO

SELECT FullName, DeptName, Salary FROM vw_ActiveEmployees WHERE Salary > 80000;

-- Indexed (materialized) view — stores result physically
CREATE VIEW vw_SalesByRegion WITH SCHEMABINDING AS
SELECT Region, COUNT_BIG(*) AS SaleCount, SUM(Amount) AS TotalAmount
FROM   dbo.Sales GROUP BY Region;
GO

CREATE UNIQUE CLUSTERED INDEX ucx_SalesByRegion ON vw_SalesByRegion (Region);

-- Drop view
DROP VIEW IF EXISTS vw_ActiveEmployees;
```

<div align="right">
    <b><a href="#table-of-contents">↥ back to top</a></b>
</div>

## Q. What is the difference between an updatable and a non-updatable view?

A view is **updatable** when DML (INSERT/UPDATE/DELETE) on the view can be translated unambiguously to the base table.

| Makes view non-updatable | Reason |
|--------------------------|--------|
| `GROUP BY` / `HAVING` / aggregate functions | Rows don\'t map 1-to-1 with base rows |
| `DISTINCT` | Row identity ambiguous |
| `UNION` / `EXCEPT` / `INTERSECT` | Multiple source tables |
| Calculated SELECT columns | No target column to write back |
| Subqueries in SELECT | Cannot resolve target |

```sql
-- UPDATABLE view (single table, no aggregates)
CREATE VIEW vw_SalesEmployees AS
SELECT EmployeeID, FirstName, LastName, Salary
FROM   Employees WHERE DeptID = 2;
GO

UPDATE vw_SalesEmployees SET Salary = 85000 WHERE EmployeeID = 10;  -- works
INSERT INTO vw_SalesEmployees (FirstName, LastName, Salary)
VALUES (N'Tom', N'Hardy', 70000);                                   -- works

-- NON-UPDATABLE view (GROUP BY)
CREATE VIEW vw_DeptSalary AS
SELECT DeptID, COUNT(*) AS Headcount, AVG(Salary) AS AvgSalary
FROM   Employees GROUP BY DeptID;
GO
-- UPDATE vw_DeptSalary SET AvgSalary = 90000 WHERE DeptID = 1;  -- ERROR

-- WITH CHECK OPTION: reject rows that the view\'s WHERE would not see
CREATE VIEW vw_HighSalary AS
SELECT EmployeeID, FirstName, Salary FROM Employees WHERE Salary > 100000
WITH CHECK OPTION;
GO
-- INSERT INTO vw_HighSalary (FirstName, Salary) VALUES ('Test', 50000); -- FAILS
```

<div align="right">
    <b><a href="#table-of-contents">↥ back to top</a></b>
</div>

## # 20. SQL Triggers

<br/>

## Q. What are triggers in SQL Server?

A trigger is a stored procedure that executes automatically in response to a DML or DDL event.

```sql
-- AFTER INSERT: log new employee
CREATE TRIGGER trg_LogEmployeeInsert
ON Employees AFTER INSERT
AS
BEGIN
    SET NOCOUNT ON;
    INSERT INTO AuditLog (TableName, Action, RecordID, ChangedAt)
    SELECT 'Employees', 'INSERT', EmployeeID, SYSDATETIME() FROM inserted;
END;
GO

-- AFTER UPDATE: track salary changes
CREATE TRIGGER trg_TrackSalaryChange
ON Employees AFTER UPDATE
AS
BEGIN
    SET NOCOUNT ON;
    IF UPDATE(Salary)
        INSERT INTO SalaryAudit (EmployeeID, OldSalary, NewSalary, ChangedAt)
        SELECT d.EmployeeID, d.Salary, i.Salary, SYSDATETIME()
        FROM   deleted d JOIN inserted i ON i.EmployeeID = d.EmployeeID
        WHERE  d.Salary <> i.Salary;
END;
GO
```

<div align="right">
    <b><a href="#table-of-contents">↥ back to top</a></b>
</div>

## Q. Why and when to use a trigger?

Use triggers for: auditing, enforcing business rules that constraints can\'t express, maintaining summary tables.

```sql
-- DDL trigger: prevent accidental DROP TABLE
CREATE TRIGGER trg_PreventDrop
ON DATABASE FOR DROP_TABLE
AS
BEGIN
    PRINT 'DROP TABLE is not allowed. Contact the DBA.';
    ROLLBACK;
END;
GO
```

<div align="right">
    <b><a href="#table-of-contents">↥ back to top</a></b>
</div>

## Q. What are the different types of triggers in SQL Server?

| Type | Fires On | Scope |
|------|----------|-------|
| `AFTER INSERT/UPDATE/DELETE` | After DML statement | Table |
| `INSTEAD OF INSERT/UPDATE/DELETE` | In place of DML | Table or View |
| DDL Trigger (`FOR CREATE/ALTER/DROP`) | DDL statements | Database or Server |
| Logon Trigger | User login | Server |

```sql
-- List all triggers
SELECT name, type_desc, parent_class_desc, is_disabled
FROM   sys.triggers ORDER BY name;
```

<div align="right">
    <b><a href="#table-of-contents">↥ back to top</a></b>
</div>

## Q. What are the INSERTED and DELETED pseudo-tables in triggers?

`INSERTED` and `DELETED` are special in-memory tables available inside DML triggers holding new and old row states.

| Table | Available in | Contains |
|-------|-------------|----------|
| `INSERTED` | INSERT, UPDATE triggers | New (post-change) row values |
| `DELETED` | DELETE, UPDATE triggers | Old (pre-change) row values |

```sql
-- AFTER INSERT: INSERTED holds new rows
CREATE TRIGGER trg_Audit_Insert
ON Employees AFTER INSERT
AS
BEGIN
    SET NOCOUNT ON;
    INSERT INTO AuditLog (TableName, Action, RecordID, NewValue, ChangedAt)
    SELECT 'Employees', 'INSERT', EmployeeID,
           FirstName + ' ' + LastName + ' | Salary: ' + CAST(Salary AS NVARCHAR(20)),
           SYSDATETIME()
    FROM   inserted;
END;
GO

-- AFTER DELETE: DELETED holds removed rows
CREATE TRIGGER trg_Audit_Delete
ON Employees AFTER DELETE
AS
BEGIN
    SET NOCOUNT ON;
    INSERT INTO AuditLog (TableName, Action, RecordID, OldValue, ChangedAt)
    SELECT 'Employees', 'DELETE', EmployeeID,
           FirstName + ' ' + LastName, SYSDATETIME()
    FROM   deleted;
END;
GO

-- AFTER UPDATE: DELETED = old values, INSERTED = new values
CREATE TRIGGER trg_Audit_SalaryUpdate
ON Employees AFTER UPDATE
AS
BEGIN
    SET NOCOUNT ON;
    IF UPDATE(Salary)
        INSERT INTO SalaryAudit (EmployeeID, OldSalary, NewSalary, ChangedAt)
        SELECT d.EmployeeID, d.Salary AS OldSalary, i.Salary AS NewSalary, SYSDATETIME()
        FROM   deleted  d
        JOIN   inserted i ON i.EmployeeID = d.EmployeeID
        WHERE  d.Salary <> i.Salary;
END;
GO
```

<div align="right">
    <b><a href="#table-of-contents">↥ back to top</a></b>
</div>

## # 21. SQL Cursors

<br/>

## Q. What is a cursor in SQL Server?

A cursor allows row-by-row processing of a result set. **Always prefer set-based operations** — cursors are significantly slower.

```sql
DECLARE @EmpID INT, @Salary DECIMAL(12,2);

DECLARE emp_cursor CURSOR LOCAL FAST_FORWARD FOR
    SELECT EmployeeID, Salary FROM Employees WHERE IsActive = 1;

OPEN emp_cursor;
FETCH NEXT FROM emp_cursor INTO @EmpID, @Salary;

WHILE @@FETCH_STATUS = 0
BEGIN
    IF @Salary < 50000
        UPDATE Employees SET Salary = 50000 WHERE EmployeeID = @EmpID;

    FETCH NEXT FROM emp_cursor INTO @EmpID, @Salary;
END;

CLOSE emp_cursor;
DEALLOCATE emp_cursor;
```

**Equivalent set-based rewrite (preferred):**

```sql
UPDATE Employees SET Salary = 50000 WHERE IsActive = 1 AND Salary < 50000;
```

<div align="right">
    <b><a href="#table-of-contents">↥ back to top</a></b>
</div>

## # 22. SQL Stored Procedures

<br/>

## Q. Why are stored procedures called executable code?

Stored procedures are named, pre-compiled T-SQL batches stored in the database. SQL Server caches their execution plans, so repeated calls reuse the compiled plan — avoiding re-parsing and re-optimizing on every call.

<div align="right">
    <b><a href="#table-of-contents">↥ back to top</a></b>
</div>

## Q. What are the advantages of stored procedures?

- Compiled execution plan cached for reuse → better performance.
- Code reuse and centralized business logic.
- Security: grant `EXECUTE` without direct table access → prevents SQL injection.
- Reduces network traffic (one EXEC call vs. many statements).
- Supports output parameters, return codes, and result sets.

<div align="right">
    <b><a href="#table-of-contents">↥ back to top</a></b>
</div>

## Q. What is a stored procedure in SQL Server?

```sql
-- Basic stored procedure
CREATE PROCEDURE dbo.usp_GetEmployeesByDept @DeptID INT
AS
BEGIN
    SET NOCOUNT ON;
    SELECT EmployeeID, FirstName + ' ' + LastName AS FullName, Salary
    FROM   Employees
    WHERE  DeptID = @DeptID AND IsActive = 1
    ORDER  BY LastName;
END;
GO

EXEC dbo.usp_GetEmployeesByDept @DeptID = 2;

-- With OUTPUT parameter
CREATE PROCEDURE dbo.usp_CreateEmployee
    @FirstName NVARCHAR(50),
    @LastName  NVARCHAR(50),
    @Email     NVARCHAR(150),
    @Salary    DECIMAL(12,2),
    @DeptID    INT,
    @NewID     INT OUTPUT
AS
BEGIN
    SET NOCOUNT ON;
    INSERT INTO Employees (FirstName, LastName, Email, Salary, DeptID)
    VALUES (@FirstName, @LastName, @Email, @Salary, @DeptID);
    SET @NewID = SCOPE_IDENTITY();
END;
GO

DECLARE @CreatedID INT;
EXEC dbo.usp_CreateEmployee 'Jane','Doe','jane@example.com',82000,1,@NewID=@CreatedID OUTPUT;
SELECT @CreatedID AS NewEmployeeID;
```

<div align="right">
    <b><a href="#table-of-contents">↥ back to top</a></b>
</div>

## Q. What is a Stored Routine (User-Defined Function) in SQL Server?

```sql
-- Scalar function
CREATE FUNCTION dbo.fn_TaxAmount (@Salary DECIMAL(12,2))
RETURNS DECIMAL(12,2) WITH SCHEMABINDING
AS BEGIN RETURN @Salary * 0.25; END;
GO

SELECT EmployeeID, Salary, dbo.fn_TaxAmount(Salary) AS Tax FROM Employees;

-- Inline TVF (inlined by optimiser — best performance)
CREATE FUNCTION dbo.fn_SalesByRegion (@Region NVARCHAR(50))
RETURNS TABLE WITH SCHEMABINDING
AS
    RETURN SELECT SaleID, ProductID, Amount, SaleDate
           FROM   dbo.Sales WHERE Region = @Region;
GO

SELECT * FROM dbo.fn_SalesByRegion(N'North') ORDER BY SaleDate;
```

<div align="right">
    <b><a href="#table-of-contents">↥ back to top</a></b>
</div>

## Q. What is the difference between a Stored Procedure and a User-Defined Function?

| Feature | Stored Procedure | UDF |
|---------|-----------------|-----|
| Returns | Result sets, output params, return code | Scalar value or table |
| Used in SELECT | No | Yes |
| Can modify data | Yes | No (scalar/inline TVFs) |
| Transaction control | Full (`TRY/CATCH`) | Limited |

<div align="right">
    <b><a href="#table-of-contents">↥ back to top</a></b>
</div>

## Q. How to raise custom errors from a stored procedure?

SQL Server 2022 recommends `THROW` over the older `RAISERROR`:

```sql
CREATE PROCEDURE dbo.usp_WithdrawFunds @AccountID INT, @Amount DECIMAL(12,2)
AS
BEGIN
    SET NOCOUNT ON;
    BEGIN TRANSACTION;
    BEGIN TRY
        IF @Amount <= 0
            THROW 50001, 'Withdrawal amount must be positive.', 1;

        DECLARE @Balance DECIMAL(12,2);
        SELECT @Balance = Balance FROM BankAccounts WHERE AccountID = @AccountID;

        IF @Balance IS NULL
            THROW 50002, 'Account not found.', 1;

        IF @Balance < @Amount
            THROW 50003, 'Insufficient funds.', 1;

        UPDATE BankAccounts SET Balance = Balance - @Amount WHERE AccountID = @AccountID;
        COMMIT TRANSACTION;
    END TRY
    BEGIN CATCH
        ROLLBACK TRANSACTION;
        THROW;
    END CATCH;
END;
GO
```

<div align="right">
    <b><a href="#table-of-contents">↥ back to top</a></b>
</div>

## Q. What is the difference between EXEC and sp_executesql?

| Feature | `EXEC` / `EXECUTE` | `sp_executesql` |
|---------|-------------------|-----------------|
| Parameters | Concatenated into string | Named, typed parameters |
| Plan caching | New plan per unique string | Plans cached and reused |
| SQL Injection risk | **High** (with concatenation) | **Low** (params are data, not code) |
| Data type checking | No | Yes |

```sql
-- EXEC with concatenation – UNSAFE, no plan reuse
DECLARE @DeptID INT = 2;
DECLARE @sql NVARCHAR(500) = 'SELECT * FROM Employees WHERE DeptID = ' + CAST(@DeptID AS NVARCHAR);
EXEC(@sql);

-- sp_executesql – SAFE and plan-cache friendly
EXEC sp_executesql
    N'SELECT * FROM Employees WHERE DeptID = @d',
    N'@d INT',
    @d = @DeptID;

-- sp_executesql with OUTPUT parameter
DECLARE @Count INT;
EXEC sp_executesql
    N'SELECT @cnt = COUNT(*) FROM Employees WHERE DeptID = @d',
    N'@d INT, @cnt INT OUTPUT',
    @d   = 2,
    @cnt = @Count OUTPUT;
SELECT @Count AS EmployeeCount;
```

<div align="right">
    <b><a href="#table-of-contents">↥ back to top</a></b>
</div>

## # 23. Miscellaneous

<br/>

## Q. How do you find the Nth highest salary?

```sql
-- OFFSET-FETCH (SQL Server 2012+)
SELECT DISTINCT Salary FROM Employees
ORDER  BY Salary DESC
OFFSET 2 ROWS FETCH NEXT 1 ROW ONLY;  -- 3rd highest (change offset for N)

-- Window function (handles ties correctly)
WITH Ranked AS (
    SELECT Salary, DENSE_RANK() OVER (ORDER BY Salary DESC) AS rnk
    FROM   Employees
)
SELECT TOP 1 Salary FROM Ranked WHERE rnk = 3;   -- change 3 to N
```

<div align="right">
    <b><a href="#table-of-contents">↥ back to top</a></b>
</div>

## Q. What is the STUFF function and how does it differ from REPLACE?

| Function | Behaviour |
|----------|-----------|
| `STUFF(str, start, len, replacement)` | Removes `len` chars at `start`, inserts replacement |
| `REPLACE(str, find, replacement)` | Replaces **all** occurrences of `find` |

```sql
SELECT STUFF('Hello World', 7, 5, 'SQL');        -- 'Hello SQL'
SELECT REPLACE('foo bar foo', 'foo', 'baz');     -- 'baz bar baz'

-- Mask a credit card number
DECLARE @CC NVARCHAR(19) = '4111-1111-1111-1234';
SELECT STUFF(@CC, 1, 14, REPLICATE('*', 14));    -- '**************1234'
```

<div align="right">
    <b><a href="#table-of-contents">↥ back to top</a></b>
</div>

## Q. What is the RANK function?

| Function | Tie Handling | Gaps After Tie |
|----------|-------------|---------------|
| `ROW_NUMBER()` | Arbitrary unique number | No |
| `RANK()` | Same rank for ties | Yes (skips numbers) |
| `DENSE_RANK()` | Same rank for ties | No (consecutive) |

```sql
SELECT EmployeeID, FirstName, Salary,
       ROW_NUMBER()  OVER (ORDER BY Salary DESC) AS RowNum,
       RANK()        OVER (ORDER BY Salary DESC) AS RankNum,
       DENSE_RANK()  OVER (ORDER BY Salary DESC) AS DenseRank,
       NTILE(4)      OVER (ORDER BY Salary DESC) AS Quartile
FROM   Employees;

-- Rank within each department
SELECT EmployeeID, DeptID, Salary,
       RANK() OVER (PARTITION BY DeptID ORDER BY Salary DESC) AS DeptRank
FROM   Employees;
```

<div align="right">
    <b><a href="#table-of-contents">↥ back to top</a></b>
</div>

## Q. What are the reasons for poor query performance?

| Cause | Diagnosis | Fix |
|-------|-----------|-----|
| Missing indexes | Table scans in execution plan | Add covering non-clustered index |
| Index fragmentation | `sys.dm_db_index_physical_stats` > 30% | `ALTER INDEX … REBUILD` |
| Outdated statistics | Optimiser uses stale row counts | `UPDATE STATISTICS` |
| Parameter sniffing | Cached plan bad for new params | `OPTION (RECOMPILE)` |
| Implicit conversions | Type mismatch forces column scan | Match parameter types to column types |
| Blocking / deadlocks | `sys.dm_exec_requests` | Tune indexes; enable RCSI |

```sql
-- Find top expensive queries in plan cache
SELECT TOP 10
       qs.execution_count,
       qs.total_logical_reads / qs.execution_count AS avg_reads,
       qs.total_elapsed_time  / qs.execution_count AS avg_us,
       SUBSTRING(qt.text, (qs.statement_start_offset/2)+1,
           ((CASE qs.statement_end_offset WHEN -1 THEN DATALENGTH(qt.text)
             ELSE qs.statement_end_offset END - qs.statement_start_offset)/2)+1) AS query_text
FROM   sys.dm_exec_query_stats qs
CROSS  APPLY sys.dm_exec_sql_text(qs.sql_handle) qt
ORDER  BY avg_reads DESC;
```

<div align="right">
    <b><a href="#table-of-contents">↥ back to top</a></b>
</div>

## Q. How to find unique values when a column has duplicates?

```sql
-- Distinct values
SELECT DISTINCT Region FROM Sales ORDER BY Region;

-- Count duplicates
SELECT Email, COUNT(*) AS Cnt FROM Employees GROUP BY Email HAVING COUNT(*) > 1;

-- Delete duplicates, keep lowest EmployeeID
WITH Dupes AS (
    SELECT EmployeeID, ROW_NUMBER() OVER (PARTITION BY Email ORDER BY EmployeeID) AS rn
    FROM   Employees
)
DELETE FROM Dupes WHERE rn > 1;
```

<div align="right">
    <b><a href="#table-of-contents">↥ back to top</a></b>
</div>

## Q. What is the difference between local temp tables, global temp tables, and table variables?

| Feature | `#LocalTemp` | `##GlobalTemp` | `@TableVariable` |
|---------|-------------|---------------|-----------------|
| Scope | Current session + nested procs | All sessions | Current batch/proc only |
| Visibility | Session-only | All sessions until creator disconnects | Batch-only |
| Stored in | `tempdb` | `tempdb` | Memory (spills to tempdb if large) |
| Indexes | Yes (any type) | Yes (any type) | Only inline PK / UNIQUE |
| Statistics | Yes (auto) | Yes (auto) | No |
| Survives ROLLBACK | Rolled back | Rolled back | **Not** rolled back |
| Best for | Medium-to-large staging data | Cross-session sharing | Small row sets (<100 rows) |

```sql
-- Local temp table (#)
CREATE TABLE #TempEmployees (
    EmployeeID INT, FullName NVARCHAR(100), Salary DECIMAL(12,2)
);
INSERT INTO #TempEmployees
    SELECT EmployeeID, FirstName + ' ' + LastName, Salary
    FROM   Employees WHERE DeptID = 1;
SELECT * FROM #TempEmployees;
DROP TABLE IF EXISTS #TempEmployees;  -- auto-drops when session ends

-- Global temp table (##) – visible to all sessions
CREATE TABLE ##SharedLookup (Code NVARCHAR(20) PRIMARY KEY, Label NVARCHAR(100));
INSERT INTO ##SharedLookup VALUES ('USD','US Dollar'),('EUR','Euro');
-- Any session can query ##SharedLookup; dropped when creator disconnects

-- Table variable (@) – scoped to current batch
DECLARE @TopEarners TABLE (
    EmployeeID INT PRIMARY KEY,
    FullName   NVARCHAR(100),
    Salary     DECIMAL(12,2)
);
INSERT INTO @TopEarners
    SELECT TOP (10) EmployeeID, FirstName + ' ' + LastName, Salary
    FROM   Employees ORDER BY Salary DESC;
SELECT * FROM @TopEarners;  -- gone after batch ends
```

<div align="right">
    <b><a href="#table-of-contents">↥ back to top</a></b>
</div>

## Q. What is the difference between OLTP and OLAP?

| Feature | OLTP | OLAP |
|---------|------|------|
| Full Name | Online Transaction Processing | Online Analytical Processing |
| Purpose | Day-to-day operational transactions | Reporting and analytics |
| Operations | INSERT, UPDATE, DELETE (mixed) | Mainly SELECT (read-heavy) |
| Data volume | Current operational data | Historical, aggregated data |
| Normalization | Highly normalized (3NF+) | De-normalized (star/snowflake schema) |
| Query complexity | Simple, short queries | Complex, long-running aggregations |
| Optimization | Row-store indexes; fast writes | Columnstore indexes; fast reads |
| Response time | Milliseconds | Seconds to minutes |
| Example | Banking system, e-commerce ERP | Data warehouse, BI dashboard |

```sql
-- OLTP: fast transactional writes on normalized tables
BEGIN TRANSACTION;
    INSERT INTO Orders    (CustomerID, OrderDate) VALUES (1, GETDATE());
    INSERT INTO OrderItems (OrderID, ProductID, Qty) VALUES (SCOPE_IDENTITY(), 5, 2);
COMMIT;

-- OLAP: columnstore index for fast analytical reads
CREATE TABLE SalesFact (
    SaleID     BIGINT        NOT NULL,
    DateKey    INT           NOT NULL,
    ProductKey INT           NOT NULL,
    Region     NVARCHAR(50),
    Amount     DECIMAL(12,2) NOT NULL
);

CREATE CLUSTERED COLUMNSTORE INDEX cci_SalesFact ON SalesFact;

-- Analytical query benefits from columnstore
SELECT Region, SUM(Amount) AS Revenue, COUNT(*) AS Transactions
FROM   SalesFact
WHERE  DateKey BETWEEN 20240101 AND 20241231
GROUP  BY Region
ORDER  BY Revenue DESC;
```

<div align="right">
    <b><a href="#table-of-contents">↥ back to top</a></b>
</div>

## Q. What are LAG() and LEAD() window functions in SQL Server?

`LAG()` accesses a **previous** row\'s value; `LEAD()` accesses a **next** row\'s value — both without a self-join.

```sql
-- Syntax: LAG(column, offset, default) OVER (PARTITION BY ... ORDER BY ...)

-- Month-over-month sales comparison
SELECT
    SaleMonth,
    TotalSales,
    LAG(TotalSales,  1, 0) OVER (ORDER BY SaleMonth) AS PrevMonthSales,
    LEAD(TotalSales, 1, 0) OVER (ORDER BY SaleMonth) AS NextMonthSales,
    TotalSales - LAG(TotalSales, 1, 0) OVER (ORDER BY SaleMonth) AS MoM_Change
FROM (
    SELECT FORMAT(OrderDate, 'yyyy-MM') AS SaleMonth,
           SUM(Amount) AS TotalSales
    FROM   Orders
    GROUP  BY FORMAT(OrderDate, 'yyyy-MM')
) m
ORDER  BY SaleMonth;

-- Partition by region: compare to previous month within each region
SELECT Region, SaleMonth, TotalSales,
       LAG(TotalSales) OVER (PARTITION BY Region ORDER BY SaleMonth) AS PrevSales,
       TotalSales - LAG(TotalSales) OVER (PARTITION BY Region ORDER BY SaleMonth) AS Diff
FROM (
    SELECT Region, FORMAT(OrderDate, 'yyyy-MM') AS SaleMonth,
           SUM(Amount) AS TotalSales
    FROM   Orders
    GROUP  BY Region, FORMAT(OrderDate, 'yyyy-MM')
) t;

-- Detect gaps in sequential IDs
WITH Gaps AS (
    SELECT OrderID,
           OrderID - LAG(OrderID) OVER (ORDER BY OrderID) AS GapSize
    FROM   Orders
)
SELECT * FROM Gaps WHERE GapSize > 1;
```

<div align="right">
    <b><a href="#table-of-contents">↥ back to top</a></b>
</div>

## Q. How to test performance of a query in SQL Server?

```sql
-- I/O and CPU statistics
SET STATISTICS IO ON;
SET STATISTICS TIME ON;

SELECT e.LastName, d.DeptName, e.Salary
FROM   Employees e JOIN Departments d ON d.DeptID = e.DeptID
WHERE  e.IsActive = 1;

SET STATISTICS IO OFF;
SET STATISTICS TIME OFF;

-- Elapsed time with SYSDATETIME
DECLARE @s DATETIME2 = SYSDATETIME();
SELECT COUNT(*) FROM Orders WHERE OrderDate >= '2024-01-01';
SELECT DATEDIFF(MILLISECOND, @s, SYSDATETIME()) AS ElapsedMs;

-- Query Store (SQL Server 2016+) — tracks performance history
ALTER DATABASE CompanyDB SET QUERY_STORE = ON;

SELECT TOP 5
       qsq.query_id,
       qsqt.query_sql_text,
       qsrs.avg_duration / 1000.0 AS avg_ms
FROM   sys.query_store_query         qsq
JOIN   sys.query_store_query_text    qsqt ON qsq.query_text_id = qsqt.query_text_id
JOIN   sys.query_store_plan          qsp  ON qsq.query_id      = qsp.query_id
JOIN   sys.query_store_runtime_stats qsrs ON qsp.plan_id       = qsrs.plan_id
ORDER  BY qsrs.avg_duration DESC;
```

<div align="right">
    <b><a href="#table-of-contents">↥ back to top</a></b>
</div>

## Q. Explain buffer cache and log cache in SQL Server

| Component | Description |
|-----------|-------------|
| **Buffer Pool (Buffer Cache)** | Memory pool caching 8 KB data pages. SQL Server reads a page into memory on first access and keeps it as long as memory is available — subsequent reads are served from RAM. |
| **Log Cache** | Memory buffer holding transaction log records before they are flushed to the `.ldf` log file. At `COMMIT`, the log is hardened to disk (Write-Ahead Logging — durability guarantee). |

```sql
-- Buffer pool usage per database
SELECT  db_name(database_id) AS DatabaseName,
        COUNT(*) * 8 / 1024  AS CachedMB
FROM    sys.dm_os_buffer_descriptors
WHERE   database_id > 4
GROUP   BY database_id
ORDER   BY CachedMB DESC;

-- Log flush statistics (SQL Server 2017+)
SELECT name, log_cache_hit_ratio, log_flushes, log_flush_wait_time
FROM   sys.dm_db_log_stats(DB_ID());

-- Total server memory in use
SELECT physical_memory_in_use_kb / 1024 AS MemoryUsedMB
FROM   sys.dm_os_process_memory;
```

<div align="right">
    <b><a href="#table-of-contents">↥ back to top</a></b>
</div>
