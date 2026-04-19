# MSSQL-Server 2025 Commands 

## ALTER TABLE

```sql
ALTER TABLE table_name ADD column datatype;
```

`ALTER TABLE` lets you add columns to a table in a database.

<div align="right">
    <b><a href="#">↥ back to top</a></b>
</div>

## AND

```sql
SELECT column_name(s)
FROM table_name
WHERE column_1 = value_1
AND column_2 = value_2;
```

`AND` is an operator that combines two conditions. Both conditions must be true for the row to be included in the result set.

<div align="right">
    <b><a href="#">↥ back to top</a></b>
</div>

## AS

```sql
SELECT column_name AS 'Alias'
FROM table_name;
```

`AS` is a keyword in SQL that allows you to rename a column or table using an *alias*.

<div align="right">
    <b><a href="#">↥ back to top</a></b>
</div>

## AVG

```sql
SELECT AVG(column_name)
FROM table_name;

```

`AVG()` is an aggregate function that returns the average value for a numeric column.

<div align="right">
    <b><a href="#">↥ back to top</a></b>
</div>

## BETWEEN

```sql
SELECT column_name(s)
FROM table_name
WHERE column_name BETWEEN value_1 AND value_2;
```

The `BETWEEN` operator is used to filter the result set within a certain range. The values can be numbers, text or dates.

<div align="right">
    <b><a href="#">↥ back to top</a></b>
</div>

## CASE WHEN

```sql
-- Simple CASE: compare one expression against a list of values
SELECT
    CASE column_name
        WHEN value_1 THEN 'Result 1'
        WHEN value_2 THEN 'Result 2'
        ELSE 'Default'
    END AS alias
FROM table_name;

-- Searched CASE: each WHEN is an independent boolean condition
SELECT ProductID, ProductName, Price,
    CASE
        WHEN Price < 10  THEN 'Budget'
        WHEN Price < 50  THEN 'Standard'
        ELSE 'Premium'
    END AS PriceCategory
FROM Products;

-- CASE inside ORDER BY (custom sort order)
SELECT EmployeeID, Status
FROM Employees
ORDER BY
    CASE Status
        WHEN 'Active'  THEN 1
        WHEN 'Pending' THEN 2
        ELSE 3
    END;

-- IIF: shorthand two-branch CASE (SQL Server 2012+)
SELECT ProductID, IIF(Stock > 0, 'In Stock', 'Out of Stock') AS Availability
FROM Products;
```

`CASE` is T-SQL\'s conditional expression. The **simple** form compares one expression to multiple values; the **searched** form evaluates each `WHEN` condition independently. `IIF(condition, true_val, false_val)` is a shorthand for a two-branch `CASE`.

<div align="right">
    <b><a href="#">↥ back to top</a></b>
</div>

## CAST / CONVERT

```sql
-- CAST: ANSI standard type conversion
SELECT CAST(expression AS datatype) FROM table_name;
SELECT CAST('2026-04-19' AS DATE)   AS ParsedDate;
SELECT CAST(123.9 AS INT)           AS Truncated;    -- 123

-- CONVERT: SQL Server-specific; supports optional style codes for formatting
SELECT CONVERT(datatype, expression [, style]);
SELECT CONVERT(VARCHAR(10), GETDATE(), 23)  AS ISODate;    -- '2026-04-19'
SELECT CONVERT(VARCHAR(8),  GETDATE(), 112) AS Compact;    -- '20260419'
SELECT CONVERT(VARCHAR(20), GETDATE(), 120) AS ODBC;       -- '2026-04-19 14:30:00'
-- Common style codes: 23=yyyy-mm-dd | 112=yyyymmdd | 120=yyyy-mm-dd hh:mi:ss | 103=dd/mm/yyyy

-- TRY_CAST: returns NULL instead of an error on conversion failure
SELECT TRY_CAST('abc' AS INT)   AS SafeInt;    -- NULL
SELECT TRY_CAST('42'  AS INT)   AS ValidInt;   -- 42

-- TRY_CONVERT: same as CONVERT but returns NULL on failure
SELECT TRY_CONVERT(DATE, 'not-a-date') AS SafeDate;  -- NULL

-- TRY_PARSE: culture-aware string conversion (CLR-based)
SELECT TRY_PARSE('April 19, 2026' AS DATE USING 'en-US') AS Parsed;
SELECT TRY_PARSE('19/04/2026'     AS DATE USING 'en-GB') AS Parsed;
```

`CAST` is the ANSI standard; `CONVERT` is SQL Server-specific and adds an optional *style* code for date/number formatting. `TRY_CAST` and `TRY_CONVERT` return `NULL` instead of raising an error on failed conversions — always prefer them over `CAST`/`CONVERT` for untrusted input.

<div align="right">
    <b><a href="#">↥ back to top</a></b>
</div>

## COUNT

```sql
SELECT COUNT(column_name)
FROM table_name;
```

`COUNT()` is a function that takes the name of a column as an argument and counts the number of rows where the column is not `NULL`.

<div align="right">
    <b><a href="#">↥ back to top</a></b>
</div>

## CREATE DATABASE

```sql
-- Create a database with default settings
CREATE DATABASE database_name;

-- Create with explicit file placement and sizing
CREATE DATABASE SalesDB
ON PRIMARY (
    NAME       = 'SalesDB_Data',
    FILENAME   = 'C:\SQLData\SalesDB.mdf',
    SIZE       = 100MB,
    MAXSIZE    = UNLIMITED,
    FILEGROWTH = 64MB
)
LOG ON (
    NAME       = 'SalesDB_Log',
    FILENAME   = 'C:\SQLData\SalesDB.ldf',
    SIZE       = 50MB,
    FILEGROWTH = 32MB
);

-- Switch the active database context
USE database_name;
GO

-- Common ALTER DATABASE options
ALTER DATABASE database_name SET RECOVERY FULL;
ALTER DATABASE database_name SET READ_COMMITTED_SNAPSHOT ON WITH ROLLBACK IMMEDIATE;
ALTER DATABASE database_name COLLATE Latin1_General_CI_AS;

-- List all databases on the server
SELECT name, state_desc, recovery_model_desc, compatibility_level
FROM sys.databases
ORDER BY name;

-- Drop a database (switch to master first; close all connections)
USE master;
ALTER DATABASE database_name SET SINGLE_USER WITH ROLLBACK IMMEDIATE;
DROP DATABASE IF EXISTS database_name;
```

`CREATE DATABASE` creates a new database with its data (`.mdf`) and log (`.ldf`) files. `USE` switches the active database context for the current session. `IF EXISTS` (SQL Server 2016+) makes the `DROP` statement idempotent.

<div align="right">
    <b><a href="#">↥ back to top</a></b>
</div>

## CREATE INDEX

```sql
-- Non-clustered index (default; up to 999 per table)
CREATE INDEX idx_Customers_Email ON Customers (Email);

-- Clustered index (one per table; defines the physical row order)
CREATE CLUSTERED INDEX idx_Orders_OrderID ON Orders (OrderID);

-- Unique index (equivalent to a UNIQUE constraint)
CREATE UNIQUE NONCLUSTERED INDEX idx_UQ_Customers_Email
ON Customers (Email);

-- Composite index (column order matters for query matching)
CREATE INDEX idx_Orders_Customer_Date
ON Orders (CustomerID ASC, OrderDate DESC);

-- Covering index with INCLUDE (eliminates key lookups)
CREATE NONCLUSTERED INDEX idx_Orders_CustomerID
ON Orders (CustomerID)
INCLUDE (OrderDate, TotalAmount, Status);

-- Filtered index (partial index on a subset of rows)
CREATE NONCLUSTERED INDEX idx_ActiveProducts_Category
ON Products (CategoryID)
WHERE IsActive = 1;

-- Rebuild (removes fragmentation; can be ONLINE in Enterprise Edition)
ALTER INDEX idx_Orders_CustomerID ON Orders REBUILD WITH (ONLINE = ON);

-- Reorganize (defragment in-place; always online, lower resource usage)
ALTER INDEX idx_Orders_CustomerID ON Orders REORGANIZE;

-- Rebuild all indexes on a table
ALTER INDEX ALL ON table_name REBUILD;

-- Disable and re-enable
ALTER INDEX index_name ON table_name DISABLE;
ALTER INDEX index_name ON table_name REBUILD;   -- re-enables

-- Drop an index
DROP INDEX IF EXISTS index_name ON table_name;
```

SQL Server supports clustered (one per table), non-clustered (up to 999), unique, composite, covering (`INCLUDE`), and filtered indexes. Use `INCLUDE` to make a covering index that eliminates key lookups. Use filtered indexes for highly skewed data (e.g., active vs. inactive rows).

<div align="right">
    <b><a href="#">↥ back to top</a></b>
</div>

## CREATE PROCEDURE

```sql
-- Basic stored procedure
CREATE PROCEDURE procedure_name
    @Param1 datatype,
    @Param2 datatype = default_value   -- optional parameter with default
AS
BEGIN
    SET NOCOUNT ON;   -- suppress "N rows affected" messages
    SELECT * FROM table_name WHERE column = @Param1;
END;
GO

-- Example: retrieve orders by customer with optional status filter
CREATE PROCEDURE usp_GetOrdersByCustomer
    @CustomerID INT,
    @Status     NVARCHAR(20) = 'Active'
AS
BEGIN
    SET NOCOUNT ON;
    SELECT o.OrderID, o.OrderDate, o.TotalAmount
    FROM Orders o
    WHERE o.CustomerID = @CustomerID
      AND o.Status = @Status
    ORDER BY o.OrderDate DESC;
END;
GO

-- Execute
EXEC usp_GetOrdersByCustomer @CustomerID = 101;
EXEC usp_GetOrdersByCustomer 101, 'Shipped';

-- OUTPUT parameter: return a value to the caller
CREATE PROCEDURE usp_InsertProduct
    @ProductName NVARCHAR(100),
    @Price       DECIMAL(10,2),
    @NewID       INT OUTPUT
AS
BEGIN
    SET NOCOUNT ON;
    INSERT INTO Products (ProductName, Price) VALUES (@ProductName, @Price);
    SET @NewID = SCOPE_IDENTITY();
END;
GO

DECLARE @InsertedID INT;
EXEC usp_InsertProduct 'Widget', 9.99, @InsertedID OUTPUT;
SELECT @InsertedID AS NewProductID;

-- Alter or drop
ALTER PROCEDURE usp_GetOrdersByCustomer ... ;
DROP PROCEDURE IF EXISTS usp_GetOrdersByCustomer;
```

Stored procedures encapsulate T-SQL logic on the server, reducing network traffic and enabling plan caching. `SET NOCOUNT ON` suppresses row-count messages for performance. Use `OUTPUT` parameters to return scalar values to the caller. Always use `sp_executesql` for dynamic SQL inside procedures to prevent SQL injection.

<div align="right">
    <b><a href="#">↥ back to top</a></b>
</div>

## CREATE TABLE

```sql
-- Basic table with common constraints
CREATE TABLE table_name (
    column_1 INT           IDENTITY(1,1) PRIMARY KEY,
    column_2 NVARCHAR(100) NOT NULL,
    column_3 DECIMAL(10,2) NOT NULL DEFAULT 0,
    column_4 DATE          NULL
);

-- Example: Products table
CREATE TABLE Products (
    ProductID   INT           IDENTITY(1,1) PRIMARY KEY,
    ProductName NVARCHAR(100) NOT NULL,
    CategoryID  INT           NOT NULL,
    Price       DECIMAL(10,2) NOT NULL CHECK (Price >= 0),
    IsActive    BIT           NOT NULL DEFAULT 1,
    CreatedAt   DATETIME2     NOT NULL DEFAULT GETUTCDATE(),
    CONSTRAINT FK_Products_Categories
        FOREIGN KEY (CategoryID) REFERENCES Categories (CategoryID)
);

-- CREATE TABLE ... AS SELECT (CTAS pattern using SELECT INTO)
SELECT * INTO NewTable FROM ExistingTable WHERE 1 = 0;  -- copy structure only
SELECT * INTO NewTable FROM ExistingTable;              -- copy structure + data

-- Temporary table (scoped to the current session)
CREATE TABLE #TempOrders (
    OrderID  INT,
    Total    DECIMAL(10,2)
);

-- Global temporary table (visible to all sessions)
CREATE TABLE ##GlobalTemp (
    ID INT, Value NVARCHAR(100)
);
```

`CREATE TABLE` defines a new table with its columns, data types, and constraints. Use `IDENTITY(seed, increment)` for auto-incrementing primary keys. Prefix with `#` for session-scoped temp tables or `##` for global temp tables (stored in `tempdb`).

<div align="right">
    <b><a href="#">↥ back to top</a></b>
</div>

## CREATE VIEW

```sql
-- Basic view
CREATE VIEW vw_ActiveCustomers AS
SELECT CustomerID, Name, Email, City
FROM Customers
WHERE IsActive = 1;

-- Query the view like a table
SELECT * FROM vw_ActiveCustomers WHERE City = 'London';

-- WITH CHECK OPTION: prevent DML that would make the row invisible through the view
CREATE VIEW vw_PremiumOrders AS
SELECT OrderID, CustomerID, TotalAmount
FROM Orders
WHERE TotalAmount > 1000
WITH CHECK OPTION;

-- Indexed (materialized) view: persists aggregated data physically
-- Requires SCHEMABINDING and a unique clustered index
CREATE VIEW vw_SalesSummary
WITH SCHEMABINDING AS
SELECT CategoryID, COUNT_BIG(*) AS OrderCount, SUM(TotalAmount) AS Revenue
FROM dbo.Orders
GROUP BY CategoryID;
GO
CREATE UNIQUE CLUSTERED INDEX idx_vw_SalesSummary
ON vw_SalesSummary (CategoryID);

-- Alter and drop
ALTER VIEW vw_ActiveCustomers AS SELECT CustomerID, Name FROM Customers WHERE IsActive = 1;
DROP VIEW IF EXISTS vw_ActiveCustomers;
```

Views encapsulate complex queries behind a simple name and can be used in `SELECT`, `INSERT`, `UPDATE`, and `DELETE`. `WITH CHECK OPTION` prevents inserts/updates through the view that would violate its `WHERE` clause. An **indexed (materialized) view** requires `SCHEMABINDING` and physically stores the result, accelerating analytical reads.

<div align="right">
    <b><a href="#">↥ back to top</a></b>
</div>

## DELETE

```sql
DELETE FROM table_name WHERE some_column = some_value;
```

`DELETE` statements are used to remove rows from a table.

<div align="right">
    <b><a href="#">↥ back to top</a></b>
</div>

## DECLARE

```sql
-- Declare a variable
DECLARE @variable_name datatype;

-- Declare and initialize
DECLARE @CustomerID INT       = 101;
DECLARE @Name       NVARCHAR(100) = 'Alice';

-- Declare multiple variables in one statement
DECLARE @OrderID INT,
        @Total   DECIMAL(10,2),
        @Today   DATE = GETDATE();

-- Assign a value with SET
SET @OrderID = 5001;
SET @Total   = (SELECT SUM(TotalAmount) FROM Orders WHERE CustomerID = @CustomerID);

-- Assign from a query with SELECT (assigns multiple variables in one pass)
DECLARE @First NVARCHAR(50), @Last NVARCHAR(50);
SELECT @First = FirstName, @Last = LastName
FROM Employees WHERE EmployeeID = 1;

-- Print / return a variable
PRINT @Name;               -- writes to the Messages tab in SSMS
SELECT @Name AS NameValue; -- returns as a result set

-- Table variable: scoped to the current batch/procedure
DECLARE @TempOrders TABLE (
    OrderID   INT,
    OrderDate DATE,
    Total     DECIMAL(10,2)
);
INSERT INTO @TempOrders
SELECT OrderID, OrderDate, TotalAmount FROM Orders WHERE CustomerID = 5;
SELECT * FROM @TempOrders;
```

`DECLARE` defines local variables scoped to the current batch or stored procedure. Use `SET` for scalar assignment or `SELECT @var = col FROM ...` to assign from a query. **Table variables** (`DECLARE @T TABLE (...)`) are lightweight alternatives to temp tables for small data sets within a single batch.

<div align="right">
    <b><a href="#">↥ back to top</a></b>
</div>

## DROP

```sql
-- Drop a table (IF EXISTS prevents an error when the object does not exist)
DROP TABLE IF EXISTS table_name;

-- Drop multiple tables
DROP TABLE IF EXISTS Staging, Archive;

-- Drop a view
DROP VIEW IF EXISTS view_name;

-- Drop a stored procedure
DROP PROCEDURE IF EXISTS procedure_name;

-- Drop a function
DROP FUNCTION IF EXISTS function_name;

-- Drop an index
DROP INDEX IF EXISTS index_name ON table_name;

-- Drop a constraint by name
ALTER TABLE table_name DROP CONSTRAINT constraint_name;

-- Drop a column
ALTER TABLE table_name DROP COLUMN column_name;

-- Drop a database (switch to master first)
USE master;
DROP DATABASE IF EXISTS database_name;

-- Drop a schema (schema must be empty)
DROP SCHEMA IF EXISTS schema_name;

-- Truncate all rows faster than DELETE (resets IDENTITY; no WHERE clause)
TRUNCATE TABLE table_name;
```

`DROP` permanently removes a database object. `IF EXISTS` (SQL Server 2016+) makes scripts idempotent — no error is raised if the object does not exist. Dropping a table also drops its indexes, triggers, and constraints.

<div align="right">
    <b><a href="#">↥ back to top</a></b>
</div>

## GROUP BY

```sql
SELECT COUNT(*)
FROM table_name
GROUP BY column_name;
```

`GROUP BY` is a clause in SQL that is only used with aggregate functions. It is used in collaboration with the `SELECT` statement to arrange identical data into groups.

<div align="right">
    <b><a href="#">↥ back to top</a></b>
</div>

## HAVING

```sql
SELECT column_name, aggregate_function(column_name)
FROM table_name
GROUP BY column_name
HAVING aggregate_function(column_name) operator value;

-- Example: departments with more than 5 employees
SELECT Department, COUNT(*) AS EmployeeCount
FROM Employees
GROUP BY Department
HAVING COUNT(*) > 5
ORDER BY EmployeeCount DESC;

-- Example: customers whose total spend exceeds $1,000
SELECT CustomerID, SUM(TotalAmount) AS TotalSpent
FROM Orders
GROUP BY CustomerID
HAVING SUM(TotalAmount) > 1000;

-- Combine WHERE (pre-aggregation) with HAVING (post-aggregation)
SELECT Department, AVG(Salary) AS AvgSalary
FROM Employees
WHERE IsActive = 1            -- filters individual rows BEFORE grouping
GROUP BY Department
HAVING AVG(Salary) > 60000;   -- filters groups AFTER aggregation
```

`HAVING` filters grouped results produced by `GROUP BY`. It is evaluated **after** aggregation, unlike `WHERE` which is evaluated before. Use `WHERE` to filter individual rows and `HAVING` to filter aggregated groups.

<div align="right">
    <b><a href="#">↥ back to top</a></b>
</div>

## INNER JOIN

```sql
SELECT column_name(s) FROM table_1
JOIN table_2
ON table_1.column_name = table_2.column_name;
```

An inner join will combine rows from different tables if the *join condition* is true.

<div align="right">
    <b><a href="#">↥ back to top</a></b>
</div>

## IN / NOT IN

```sql
-- IN: match any value in a list
SELECT column_name(s)
FROM table_name
WHERE column_name IN (value_1, value_2, value_3);

-- Example
SELECT ProductID, ProductName
FROM Products
WHERE CategoryID IN (1, 3, 5);

-- NOT IN: exclude values in the list
SELECT ProductID, ProductName
FROM Products
WHERE CategoryID NOT IN (2, 4);

-- IN with a subquery
SELECT CustomerID, Name
FROM Customers
WHERE CustomerID IN (
    SELECT DISTINCT CustomerID FROM Orders WHERE TotalAmount > 500
);

-- Prefer EXISTS over IN for large subqueries (short-circuits on first match)
SELECT c.CustomerID, c.Name
FROM Customers c
WHERE EXISTS (
    SELECT 1 FROM Orders o
    WHERE o.CustomerID = c.CustomerID AND o.TotalAmount > 500
);

-- WARNING: NOT IN with a NULL in the subquery returns 0 rows
-- Use NOT EXISTS to safely handle NULLs
SELECT c.CustomerID
FROM Customers c
WHERE NOT EXISTS (
    SELECT 1 FROM Orders o WHERE o.CustomerID = c.CustomerID
);
```

`IN` checks whether a value matches any member of a list or subquery. **`NOT IN` with a list or subquery that contains `NULL` returns no rows** because `x <> NULL` evaluates to UNKNOWN. Always use `NOT EXISTS` for subqueries that may return `NULL` values.

<div align="right">
    <b><a href="#">↥ back to top</a></b>
</div>

## INSERT

```sql
INSERT INTO table_name (column_1, column_2, column_3) VALUES (value_1, 'value_2', value_3);
```

`INSERT` statements are used to add a new row to a table.

<div align="right">
    <b><a href="#">↥ back to top</a></b>
</div>

## IS NULL / IS NOT NULL

```sql
-- Find rows where the column has no value
SELECT column_name(s)
FROM table_name
WHERE column_name IS NULL;

-- Find rows where the column has a value
SELECT column_name(s)
FROM table_name
WHERE column_name IS NOT NULL;

-- Example: customers with no phone number
SELECT CustomerID, Name
FROM Customers
WHERE Phone IS NULL;

-- Substitute a default for NULL (ISNULL = MSSQL-specific, 2 args)
SELECT CustomerID,
       ISNULL(Phone, 'N/A')              AS Phone,
       COALESCE(Phone, Mobile, 'N/A')   AS BestContact  -- ANSI, picks first non-NULL
FROM Customers;

-- NULLIF: return NULL when two expressions are equal (avoids divide-by-zero)
SELECT Revenue / NULLIF(Units, 0) AS PricePerUnit FROM Sales;

-- NULL-safe equality check (SQL Server 2022+)
SELECT * FROM table_name
WHERE col1 IS NOT DISTINCT FROM col2;  -- treats NULL = NULL as TRUE
```

In T-SQL, any comparison with `NULL` using `=`, `<>`, or other operators yields **UNKNOWN** (not TRUE or FALSE), so always use `IS NULL` / `IS NOT NULL`. `ISNULL(col, default)` substitutes a fallback; `COALESCE(col1, col2, ...)` returns the first non-`NULL` from a list (ANSI standard). `NULLIF` converts a specific value to `NULL`.

<div align="right">
    <b><a href="#">↥ back to top</a></b>
</div>

## LIKE

```sql
SELECT column_name(s)
FROM table_name
WHERE column_name LIKE pattern;
```

`LIKE` is a special operator used with the `WHERE` clause to search for a specific pattern in a column.

<div align="right">
    <b><a href="#">↥ back to top</a></b>
</div>

## MERGE

```sql
-- MERGE (UPSERT): INSERT, UPDATE, or DELETE in a single atomic statement
MERGE target_table AS target
USING source_table AS source
ON target.key_column = source.key_column
WHEN MATCHED THEN
    UPDATE SET target.col1 = source.col1,
               target.col2 = source.col2
WHEN NOT MATCHED BY TARGET THEN
    INSERT (col1, col2) VALUES (source.col1, source.col2)
WHEN NOT MATCHED BY SOURCE THEN
    DELETE;    -- always terminate MERGE with a semicolon

-- Example: sync a staging table into production
MERGE Products AS tgt
USING ProductsStaging AS src
ON tgt.ProductID = src.ProductID
WHEN MATCHED AND tgt.Price <> src.Price THEN
    UPDATE SET tgt.Price = src.Price, tgt.UpdatedAt = GETUTCDATE()
WHEN NOT MATCHED BY TARGET THEN
    INSERT (ProductID, ProductName, Price, Stock)
    VALUES (src.ProductID, src.ProductName, src.Price, src.Stock)
WHEN NOT MATCHED BY SOURCE THEN
    DELETE
OUTPUT $action            AS MergeAction,
       inserted.ProductID AS NewProductID,
       deleted.ProductID  AS OldProductID;
```

`MERGE` performs conditional `INSERT`, `UPDATE`, and `DELETE` in one atomic statement — the standard pattern for UPSERT in SQL Server. `$action` in the `OUTPUT` clause returns `'INSERT'`, `'UPDATE'`, or `'DELETE'` for each affected row. The statement **must** be terminated with a semicolon.

<div align="right">
    <b><a href="#">↥ back to top</a></b>
</div>

## TOP / OFFSET-FETCH

```sql
-- Return a fixed number of rows (SQL Server equivalent of LIMIT)
SELECT TOP (number) column_name(s)
FROM table_name
ORDER BY column_name;

-- Example: top 5 most expensive products
SELECT TOP (5) ProductID, ProductName, Price
FROM Products
ORDER BY Price DESC;

-- Pagination using OFFSET...FETCH (SQL Server 2012+)
SELECT column_name(s)
FROM table_name
ORDER BY column_name
OFFSET skip_rows ROWS
FETCH NEXT number ROWS ONLY;

-- Example: page 2 with 10 rows per page
SELECT ProductID, ProductName
FROM Products
ORDER BY ProductID
OFFSET 10 ROWS
FETCH NEXT 10 ROWS ONLY;

-- TOP WITH TIES: include extra rows that tie on the last value
SELECT TOP (3) WITH TIES EmployeeID, Salary
FROM Employees
ORDER BY Salary DESC;
```

`TOP` limits the number of rows returned. SQL Server does not support `LIMIT`; use `TOP` for a simple row cap or `OFFSET...FETCH` for pagination (requires `ORDER BY`). `WITH TIES` includes additional rows that share the same value as the last row in the top set.

<div align="right">
    <b><a href="#">↥ back to top</a></b>
</div>

## MAX

```sql
SELECT MAX(column_name)
FROM table_name;
```

`MAX()` is a function that takes the name of a column as an argument and returns the largest value in that column.

<div align="right">
    <b><a href="#">↥ back to top</a></b>
</div>

## MIN

```sql
SELECT MIN(column_name)
FROM table_name;
```

`MIN()` is a function that takes the name of a column as an argument and returns the smallest value in that column.

<div align="right">
    <b><a href="#">↥ back to top</a></b>
</div>

## NULL Functions

```sql
-- ISNULL(expression, replacement): SQL Server-specific; exactly 2 arguments
SELECT ISNULL(MiddleName, 'N/A') AS MiddleName FROM Customers;

-- COALESCE(expr1, expr2, ...): ANSI standard; returns first non-NULL (N arguments)
SELECT COALESCE(Phone, Mobile, Email, 'No Contact') AS ContactInfo
FROM Customers;

-- NULLIF(expr1, expr2): return NULL if both are equal; else return expr1
-- Prevents divide-by-zero errors
SELECT Revenue / NULLIF(Units, 0) AS AvgPrice FROM Sales;

-- ISNULL vs COALESCE
-- ISNULL: return type = type of first arg; short-circuits evaluation
-- COALESCE: return type = highest-precedence type across all args; ANSI-portable

-- Build a full name, omitting middle name gracefully
SELECT FirstName + ' ' + ISNULL(MiddleName + ' ', '') + LastName AS FullName
FROM Employees;

-- NULL behaviour in aggregate functions
SELECT
    COUNT(*)     AS TotalRows,    -- counts ALL rows including NULLs
    COUNT(Phone) AS WithPhone,    -- counts only non-NULL Phone values
    AVG(Salary)  AS AvgSalary,   -- NULLs excluded from AVG
    SUM(Bonus)   AS TotalBonus   -- NULLs treated as 0 in SUM
FROM Employees;
```

`ISNULL` and `COALESCE` both substitute a fallback for `NULL`. Prefer `COALESCE` for portability and when you need more than two alternatives. `NULLIF` converts a specific value to `NULL`, commonly used to avoid divide-by-zero errors.

<div align="right">
    <b><a href="#">↥ back to top</a></b>
</div>

## OR

```sql
SELECT column_name
FROM table_name
WHERE column_name = value_1
OR column_name = value_2;
```

`OR` is an operator that filters the result set to only include rows where either condition is true.

<div align="right">
    <b><a href="#">↥ back to top</a></b>
</div>

## ORDER BY

```sql
SELECT column_name
FROM table_name
ORDER BY column_name ASC|DESC;
```

`ORDER BY` is a clause that indicates you want to sort the result set by a particular column either alphabetically or numerically.

<div align="right">
    <b><a href="#">↥ back to top</a></b>
</div>

## OUTPUT

```sql
-- OUTPUT clause: capture rows affected by INSERT, UPDATE, DELETE, or MERGE
-- Uses the pseudo-tables: inserted (post-DML values) and deleted (pre-DML values)

-- Capture rows from an INSERT
INSERT INTO Orders (CustomerID, TotalAmount)
OUTPUT inserted.OrderID, inserted.CustomerID, inserted.TotalAmount
VALUES (1, 250.00), (2, 499.99);

-- Capture rows from a DELETE
DELETE FROM Orders
OUTPUT deleted.OrderID, deleted.CustomerID, deleted.TotalAmount
WHERE OrderDate < '2020-01-01';

-- Capture old and new values from an UPDATE
UPDATE Products
SET Price = Price * 1.10
OUTPUT deleted.ProductID,
       deleted.Price  AS OldPrice,
       inserted.Price AS NewPrice
WHERE CategoryID = 3;

-- Store OUTPUT results into a table variable for further processing
DECLARE @Changes TABLE (
    ProductID INT,
    OldPrice  DECIMAL(10,2),
    NewPrice  DECIMAL(10,2)
);
UPDATE Products
SET Price = Price * 1.10
OUTPUT deleted.ProductID, deleted.Price, inserted.Price
INTO @Changes
WHERE CategoryID = 3;
SELECT * FROM @Changes;
```

`OUTPUT` returns data from rows affected by a DML statement without a separate `SELECT`. The `inserted` pseudo-table holds new (post-DML) values; `deleted` holds old (pre-DML) values. `OUTPUT INTO` persists results into a table or table variable — useful for auditing, logging, or chained operations.

<div align="right">
    <b><a href="#">↥ back to top</a></b>
</div>

## OUTER JOIN

```sql
SELECT column_name(s) FROM table_1
LEFT JOIN table_2
ON table_1.column_name = table_2.column_name;
```

An outer join will combine rows from different tables even if the the join condition is not met. Every row in the *left* table is returned in the result set, and if the join condition is not met, then `NULL` values are used to fill in the columns from the *right* table.

<div align="right">
    <b><a href="#">↥ back to top</a></b>
</div>

## PIVOT / UNPIVOT

```sql
-- PIVOT: rotate distinct row values into columns with aggregation
SELECT *
FROM (
    SELECT [Year], Quarter, Revenue
    FROM SalesData
) AS SourceData
PIVOT (
    SUM(Revenue)
    FOR Quarter IN ([Q1], [Q2], [Q3], [Q4])
) AS PivotTable;
-- Each distinct value in Quarter becomes a column; Revenue is summed per Year.

-- UNPIVOT: rotate columns back into rows
SELECT [Year], Quarter, Revenue
FROM (
    SELECT [Year], Q1, Q2, Q3, Q4 FROM SalesSummary
) AS SourceData
UNPIVOT (
    Revenue FOR Quarter IN (Q1, Q2, Q3, Q4)
) AS UnpivotTable;

-- Dynamic PIVOT: column values are not known at design time
DECLARE @Cols NVARCHAR(MAX) = '';
SELECT @Cols += QUOTENAME(Quarter) + ','
FROM (SELECT DISTINCT Quarter FROM SalesData) t;
SET @Cols = LEFT(@Cols, LEN(@Cols) - 1);

DECLARE @SQL NVARCHAR(MAX) = N'
SELECT [Year], ' + @Cols + N'
FROM SalesData
PIVOT (SUM(Revenue) FOR Quarter IN (' + @Cols + N')) p;';
EXEC sp_executesql @SQL;   -- use sp_executesql to avoid SQL injection
```

`PIVOT` transforms row values into column headers with aggregation. `UNPIVOT` is the reverse. **Dynamic PIVOT** uses `sp_executesql` with `QUOTENAME()` to safely build the column list at runtime when values are not known at design time.

<div align="right">
    <b><a href="#">↥ back to top</a></b>
</div>

## RIGHT JOIN / FULL OUTER JOIN / CROSS JOIN

```sql
-- RIGHT JOIN: return ALL rows from the RIGHT table; NULL for unmatched left rows
SELECT c.CustomerID, c.Name, o.OrderID
FROM Orders o
RIGHT JOIN Customers c ON o.CustomerID = c.CustomerID;
-- Customers without orders appear with NULL OrderID

-- FULL OUTER JOIN: return ALL rows from BOTH tables; NULL where no match exists
SELECT c.CustomerID, c.Name, o.OrderID
FROM Customers c
FULL OUTER JOIN Orders o ON c.CustomerID = o.CustomerID;

-- CROSS JOIN: Cartesian product (every row from table1 paired with every row from table2)
SELECT p.ProductName, c.ColorName
FROM Products p
CROSS JOIN Colors c;
-- 10 products × 5 colors = 50 rows

-- CROSS APPLY: like INNER JOIN for table-valued functions; returns rows only when TVF has results
SELECT e.EmployeeID, e.Name, proj.ProjectName
FROM Employees e
CROSS APPLY dbo.GetProjectsByEmployee(e.EmployeeID) proj;

-- OUTER APPLY: like LEFT JOIN for table-valued functions; returns NULLs when TVF has no results
SELECT e.EmployeeID, e.Name, proj.ProjectName
FROM Employees e
OUTER APPLY dbo.GetProjectsByEmployee(e.EmployeeID) proj;
```

`RIGHT JOIN` and `FULL OUTER JOIN` extend `LEFT JOIN` for unmatched row handling. `CROSS JOIN` produces a Cartesian product — use with care on large tables. `CROSS APPLY` and `OUTER APPLY` are the join equivalents for table-valued functions and correlated subqueries that return a table result.

<div align="right">
    <b><a href="#">↥ back to top</a></b>
</div>

## ROUND

```sql
SELECT ROUND(column_name, integer)
FROM table_name;
```

`ROUND()` is a function that takes a column name and an integer as an argument. It rounds the values in the column to the number of decimal places specified by the integer.

<div align="right">
    <b><a href="#">↥ back to top</a></b>
</div>

## SELECT

```sql
SELECT column_name FROM table_name;
```

`SELECT` statements are used to fetch data from a database. Every query will begin with SELECT.

<div align="right">
    <b><a href="#">↥ back to top</a></b>
</div>

## SELECT DISTINCT

```sql
SELECT DISTINCT column_name FROM table_name;
```

`SELECT DISTINCT` specifies that the statement is going to be a query that returns unique values in the specified column(s).

<div align="right">
    <b><a href="#">↥ back to top</a></b>
</div>

## SET

```sql
-- Assign a scalar value to a variable
DECLARE @Counter INT = 0;
SET @Counter = @Counter + 1;

-- Assign a query result (must return exactly one row/column)
DECLARE @MaxSalary DECIMAL(10,2);
SET @MaxSalary = (SELECT MAX(Salary) FROM Employees WHERE Department = 'Sales');

-- SELECT can assign multiple variables in one scan (preferred for multi-assign)
DECLARE @First NVARCHAR(50), @Last NVARCHAR(50);
SELECT @First = FirstName, @Last = LastName
FROM Employees WHERE EmployeeID = 1;

-- Session-level SET options (commonly placed at top of scripts / procedures)
SET NOCOUNT ON;            -- suppress "N rows affected" messages
SET XACT_ABORT ON;         -- auto-rollback the transaction on any error
SET ANSI_NULLS ON;         -- require IS NULL / IS NOT NULL (ANSI standard)
SET QUOTED_IDENTIFIER ON;  -- allow double-quoted identifiers
SET STATISTICS IO ON;      -- report logical/physical reads per statement
SET STATISTICS TIME ON;    -- report CPU and elapsed time per statement
```

`SET` assigns a scalar value to a variable. For assigning multiple variables in one statement, use `SELECT @var1 = col1, @var2 = col2 FROM ...`. Session-level `SET` options control query behaviour — `SET NOCOUNT ON` and `SET XACT_ABORT ON` are recommended best practices inside stored procedures.

<div align="right">
    <b><a href="#">↥ back to top</a></b>
</div>

## SUM

```sql
SELECT SUM(column_name)
FROM table_name;
```

`SUM()` is a function that takes the name of a column as an argument and returns the sum of all the values in that column.

<div align="right">
    <b><a href="#">↥ back to top</a></b>
</div>

## TRUNCATE TABLE

```sql
-- Remove all rows from a table instantly (cannot use WHERE)
TRUNCATE TABLE table_name;

-- Example
TRUNCATE TABLE StagingOrders;

-- Truncate specific partitions (SQL Server 2016+)
TRUNCATE TABLE PartitionedSales WITH (PARTITIONS (1 TO 3, 5));

-- TRUNCATE vs DELETE
-- TRUNCATE: no WHERE clause | resets IDENTITY seed | minimal logging
--           blocked if a FK from another table references this table
--           DML triggers do NOT fire
-- DELETE:   supports WHERE | does NOT reset IDENTITY | fully logged
--           works with FK constraints | DML triggers fire
```

`TRUNCATE TABLE` removes all rows as a minimally-logged metadata operation, making it far faster than `DELETE` for bulk removal. It resets the `IDENTITY` seed but cannot be used when a `FOREIGN KEY` from another table references the table. Use `DELETE` when you need a `WHERE` clause, triggers, or FK constraints respected.

<div align="right">
    <b><a href="#">↥ back to top</a></b>
</div>

## UPDATE

```sql
UPDATE table_name
SET some_column = some_value
WHERE some_column = some_value;
```

`UPDATE` statments allow you to edit rows in a table.

<div align="right">
    <b><a href="#">↥ back to top</a></b>
</div>

## UNION / UNION ALL / INTERSECT / EXCEPT

```sql
-- UNION: combine two result sets, removing duplicates
SELECT column_name(s) FROM table_1
UNION
SELECT column_name(s) FROM table_2;

-- UNION ALL: combine result sets, keeping duplicates (faster — no de-duplication)
SELECT column_name(s) FROM table_1
UNION ALL
SELECT column_name(s) FROM table_2;

-- INTERSECT: rows that appear in BOTH result sets
SELECT CustomerID FROM Customers WHERE City = 'London'
INTERSECT
SELECT CustomerID FROM Orders WHERE TotalAmount > 1000;

-- EXCEPT: rows in the FIRST set NOT present in the SECOND (Oracle calls this MINUS)
SELECT CustomerID FROM Customers
EXCEPT
SELECT CustomerID FROM Orders;   -- customers who have never placed an order

-- Rules:
-- Both queries must return the same number of columns
-- Corresponding columns must have compatible data types
-- Column names come from the first SELECT
-- ORDER BY applies to the final combined result and uses first-SELECT column names

-- Example: combine active customers from two regions
SELECT CustomerID, Name, 'EU' AS Region FROM EU_Customers WHERE IsActive = 1
UNION ALL
SELECT CustomerID, Name, 'US' AS Region FROM US_Customers WHERE IsActive = 1
ORDER BY Name;
```

`UNION` merges result sets and removes duplicate rows (slower). `UNION ALL` keeps duplicates and is faster. `INTERSECT` returns only rows common to both sets. `EXCEPT` returns rows from the first set not found in the second.

<div align="right">
    <b><a href="#">↥ back to top</a></b>
</div>

## WHERE

```sql
SELECT column_name(s)
FROM table_name
WHERE column_name operator value;
```

`WHERE` is a clause that indicates you want to filter the result set to include only rows where the following *condition* is true.

<div align="right">
    <b><a href="#">↥ back to top</a></b>
</div>

## WITH (Common Table Expression)

```sql
-- Basic CTE: a named temporary result set scoped to one query
WITH cte_name AS (
    SELECT column_name(s)
    FROM table_name
    WHERE condition
)
SELECT * FROM cte_name;

-- Example: customers with above-average order totals
WITH AvgOrders AS (
    SELECT AVG(TotalAmount) AS AvgTotal FROM Orders
)
SELECT c.Name, o.TotalAmount
FROM Customers c
JOIN Orders o ON c.CustomerID = o.CustomerID
JOIN AvgOrders a ON o.TotalAmount > a.AvgTotal;

-- Multiple CTEs (chain with commas)
WITH
    ActiveCustomers AS (
        SELECT CustomerID, Name FROM Customers WHERE IsActive = 1
    ),
    RecentOrders AS (
        SELECT CustomerID, MAX(OrderDate) AS LastOrder
        FROM Orders WHERE OrderDate >= DATEADD(YEAR, -1, GETDATE())
        GROUP BY CustomerID
    )
SELECT ac.Name, ro.LastOrder
FROM ActiveCustomers ac
JOIN RecentOrders ro ON ac.CustomerID = ro.CustomerID;

-- Recursive CTE: traverse hierarchical data (org chart, folder tree)
WITH OrgChart AS (
    -- Anchor member: top-level rows (no manager)
    SELECT EmployeeID, ManagerID, Name, 0 AS Level
    FROM Employees
    WHERE ManagerID IS NULL

    UNION ALL

    -- Recursive member: employees reporting to the previous level
    SELECT e.EmployeeID, e.ManagerID, e.Name, oc.Level + 1
    FROM Employees e
    INNER JOIN OrgChart oc ON e.ManagerID = oc.EmployeeID
)
SELECT EmployeeID, Name, Level
FROM OrgChart
ORDER BY Level, Name
OPTION (MAXRECURSION 100);   -- default max recursion depth; 0 = unlimited

-- CTE as the target of UPDATE / DELETE
WITH SalesTeam AS (
    SELECT EmployeeID, Salary FROM Employees WHERE Department = 'Sales'
)
UPDATE SalesTeam SET Salary = Salary * 1.05;
```

A **CTE** (`WITH`) is a temporary named result set scoped to a single statement. CTEs improve readability over nested subqueries, support self-referencing for **recursive** traversal of hierarchies, and can be the target of `UPDATE` and `DELETE`. Set `MAXRECURSION` to cap recursion depth and prevent infinite loops.

<div align="right">
    <b><a href="#">↥ back to top</a></b>
</div>

## Basic Queries

**Q. Execute a `.sql` script file from the command line:**

```sql
-- Using sqlcmd utility (Command Prompt / PowerShell)
-- Syntax: sqlcmd -S <server> -d <database> -U <user> -P <password> -i <script_file>
sqlcmd -S localhost -d AdventureWorks -U sa -P YourPassword -i "C:\scripts\database.sql"

-- Using Windows Authentication
sqlcmd -S localhost\MSSQLSERVER -d AdventureWorks -E -i "C:\scripts\database.sql"

-- Inside sqlcmd interactive session, use :r to run a script
:r C:\scripts\database.sql

-- Using SSMS: File > Open > File, then press F5 to execute
-- Using PowerShell with SqlServer module (SQL Server 2025)
Invoke-Sqlcmd -ServerInstance "localhost" -Database "AdventureWorks" -InputFile "C:\scripts\database.sql"
```

<div align="right">
    <b><a href="#">↥ back to top</a></b>
</div>

**Q. MSSQL Server Performance Queries:**

```sql
-- Rebuild index to reduce fragmentation (equivalent of OPTIMIZE TABLE)
ALTER INDEX ALL ON table_name REBUILD;
ALTER INDEX ALL ON table_name REORGANIZE;  -- Online, lower resource usage

-- Display table and column metadata
EXEC sp_help 'table_name';
EXEC sp_columns 'table_name';

-- Describe a table\'s columns (equivalent of DESC)
SELECT COLUMN_NAME, DATA_TYPE, CHARACTER_MAXIMUM_LENGTH, IS_NULLABLE, COLUMN_DEFAULT
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_NAME = 'table_name';

-- List all tables in the current database
SELECT TABLE_NAME, TABLE_TYPE
FROM INFORMATION_SCHEMA.TABLES
WHERE TABLE_TYPE = 'BASE TABLE';

-- Server configuration variables
SELECT name, value_in_use, description
FROM sys.configurations
ORDER BY name;

-- Show currently executing requests (equivalent of SHOW FULL PROCESSLIST)
SELECT
    r.session_id,
    s.login_name,
    s.host_name,
    r.status,
    r.command,
    r.cpu_time,
    r.total_elapsed_time,
    t.text AS query_text
FROM sys.dm_exec_requests r
JOIN sys.dm_exec_sessions s ON r.session_id = s.session_id
CROSS APPLY sys.dm_exec_sql_text(r.sql_handle) t
WHERE r.session_id > 50;

-- Server name and instance
SELECT @@SERVERNAME AS ServerName, @@SERVICENAME AS InstanceName;

-- Top 10 CPU-intensive cached queries
SELECT TOP 10
    total_worker_time / execution_count AS avg_cpu_us,
    execution_count,
    SUBSTRING(t.text, 1, 200) AS query_text
FROM sys.dm_exec_query_stats qs
CROSS APPLY sys.dm_exec_sql_text(qs.sql_handle) t
ORDER BY avg_cpu_us DESC;

-- Check index fragmentation
SELECT
    OBJECT_NAME(ips.object_id) AS table_name,
    i.name AS index_name,
    ips.avg_fragmentation_in_percent
FROM sys.dm_db_index_physical_stats(DB_ID(), NULL, NULL, NULL, 'LIMITED') ips
JOIN sys.indexes i ON ips.object_id = i.object_id AND ips.index_id = i.index_id
WHERE ips.avg_fragmentation_in_percent > 10
ORDER BY ips.avg_fragmentation_in_percent DESC;
```

<div align="right">
    <b><a href="#">↥ back to top</a></b>
</div>

**Q. Table Related Queries:**

```sql
-- Get the last 4 characters of a column
SELECT MAX(RIGHT(field_name, 4)) FROM table_name;

-- Convert to upper case (UPPER replaces UCASE in MSSQL)
SELECT UPPER(column_name) FROM table_name;

-- Select nearest value using a variable
DECLARE @MyValue INT = 42;
SELECT TOP 1 * FROM table_name ORDER BY ABS(value_column - @MyValue);

-- Pagination: page 2, 5 rows per page (OFFSET...FETCH replaces LIMIT ... OFFSET)
SELECT * FROM table_name
ORDER BY field_name
OFFSET 5 ROWS FETCH NEXT 5 ROWS ONLY;

-- Find duplicate entries
SELECT field_name, COUNT(field_name) AS duplicate_count
FROM table_name
GROUP BY field_name
HAVING COUNT(field_name) > 1;

-- Reseed an IDENTITY column (equivalent of AUTO_INCREMENT = 1)
DBCC CHECKIDENT ('table_name', RESEED, 0);

-- Drop a primary key constraint
ALTER TABLE table_name DROP CONSTRAINT PK_constraint_name;

-- Add an IDENTITY column (equivalent of AUTO_INCREMENT)
-- Note: cannot add IDENTITY to an existing column directly; use a new column
ALTER TABLE table_name ADD id INT IDENTITY(1,1) NOT NULL;

-- Add a column after another column
-- SQL Server does not support AFTER; use ALTER TABLE ADD (appends to end)
ALTER TABLE table_name ADD column_name datatype NULL;
-- To reorder, use SQL Server Management Studio or recreate the table.

-- Drop a column
ALTER TABLE table_name DROP COLUMN column_name;

-- Modify a column\'s datatype
ALTER TABLE table_name ALTER COLUMN column_name new_datatype;

-- Rename a column (sp_rename replaces CHANGE/RENAME COLUMN)
EXEC sp_rename 'table_name.old_column_name', 'new_column_name', 'COLUMN';

-- Rename a table (sp_rename replaces RENAME TABLE)
EXEC sp_rename 'old_table_name', 'new_table_name';

-- Replace a specific character in a column
UPDATE mytable SET city = REPLACE(city, N'ï', N'i');

-- Swap two column values using a CTE (no := assignment in MSSQL)
DECLARE @temp INT;
SELECT @temp = x FROM swap_test WHERE id = 1;
UPDATE swap_test SET x = y, y = @temp WHERE id = 1;

-- Copy one column\'s value to another
UPDATE table_name SET field_name1 = field_name2;
UPDATE table_name SET field_name = UPPER(field_name);

-- Truncate and drop
TRUNCATE TABLE table_name;
DROP TABLE IF EXISTS table_name;  -- IF EXISTS supported from SQL Server 2016+
```

<div align="right">
    <b><a href="#">↥ back to top</a></b>
</div>

**Q. Date and Time:**

```sql
-- Show server time zone / UTC offset
SELECT SYSDATETIMEOFFSET() AS ServerTimeWithOffset;
SELECT GETUTCDATE() AS UTCNow, GETDATE() AS LocalNow;

-- Current timestamp (high precision)
SELECT SYSDATETIME() AS HighPrecision;      -- DATETIME2 precision
SELECT GETDATE() AS CurrentDateTime;        -- DATETIME precision (legacy)

-- Current date only
SELECT CAST(GETDATE() AS DATE) AS TodayDate;

-- Current day name (equivalent of DAYNAME)
SELECT DATENAME(WEEKDAY, GETDATE()) AS DayName;

-- Subtract time (equivalent of SUBTIME)
SELECT DATEADD(MINUTE, -15, '1900-01-01 01:30:00') AS Result;  -- 01:15:00

-- Format a date (FORMAT function, SQL Server 2012+)
SELECT FORMAT(GETDATE(), 'dddd, d MMMM yyyy') AS FormattedDate;
-- Example output: Saturday, 19 April 2026

-- Difference between two datetimes (equivalent of TIMEDIFF)
SELECT DATEDIFF(SECOND, '2007-10-05 12:10:18', '2007-10-05 16:14:59') AS DiffSeconds;
SELECT DATEDIFF(MINUTE, '2007-10-05 12:10:18', '2007-10-05 16:14:59') AS DiffMinutes;

-- Filter rows by a specific date (sargable — allows index seek)
SELECT * FROM table_name
WHERE field_name >= '2010-01-01' AND field_name < '2010-01-02';

-- Add days / months / years to a date
SELECT DATEADD(DAY,   7,  GETDATE()) AS NextWeek;
SELECT DATEADD(MONTH, 1,  GETDATE()) AS NextMonth;
SELECT DATEADD(YEAR,  1,  GETDATE()) AS NextYear;

-- Extract date parts
SELECT
    YEAR(GETDATE())    AS YearPart,
    MONTH(GETDATE())   AS MonthPart,
    DAY(GETDATE())     AS DayPart,
    DATEPART(HOUR,   GETDATE()) AS HourPart,
    DATEPART(MINUTE, GETDATE()) AS MinutePart;

-- Convert string to date
SELECT CONVERT(DATE, '2026-04-19', 23) AS ParsedDate;          -- ISO 8601
SELECT TRY_CONVERT(DATETIME2, '2026-04-19 14:30:00') AS SafeParse;  -- returns NULL on failure
```

<div align="right">
    <b><a href="#">↥ back to top</a></b>
</div>

**Q. MSSQL Server Miscellaneous Queries:**

```sql
-- Generate a unique GUID (equivalent of uuid())
SELECT NEWID() AS UniqueID;
-- Sequential GUID (better for clustered index inserts)
SELECT NEWSEQUENTIALID();  -- only valid as a column DEFAULT

-- Filter rows containing only numeric values
-- SQL Server 2012+: TRY_CAST returns NULL for non-numeric values
SELECT * FROM table_name WHERE TRY_CAST(field AS BIGINT) IS NOT NULL;
-- Alternatively, ISNUMERIC (less strict — allows '.', '-', 'e')
SELECT * FROM table_name WHERE ISNUMERIC(field) = 1;

-- String concatenation (CONCAT is supported, + operator also works)
SELECT CONCAT('w3resource', '.', 'com') AS site;
SELECT 'w3resource' + '.' + 'com' AS site;

-- BIT datatype (MSSQL BIT stores 0/1/NULL; use IDENTITY instead of SERIAL)
CREATE TABLE table_bit (
    id   INT IDENTITY(1,1) PRIMARY KEY,
    flag BIT NOT NULL DEFAULT 0
);

-- ENUM equivalent using a CHECK constraint (MSSQL has no ENUM type)
CREATE TABLE table_status (
    id     INT IDENTITY(1,1) PRIMARY KEY,
    status NVARCHAR(10) NOT NULL CHECK (status IN ('Active', 'Inactive'))
);

-- Get string length (LEN replaces CHAR_LENGTH / LENGTH)
-- LEN excludes trailing spaces; DATALENGTH counts bytes including them
SELECT LEN(field_name) AS CharLength FROM table_name;
SELECT * FROM table_name WHERE LEN(field_name) < 10;

-- Copy rows from same table (self-insert)
INSERT INTO table_name (col1, col2, col3)
SELECT col1, col2, col3 FROM table_name;

-- Count distinct values
SELECT COUNT(DISTINCT column_name) AS DistinctCount FROM table_name;

-- Substring operations (MID is not supported; use SUBSTRING)
SELECT
    field_name,
    LEFT(field_name, 3)          AS LeftPart,
    RIGHT(field_name, 3)         AS RightPart,
    SUBSTRING(field_name, 2, 3)  AS MidPart   -- replaces MID()
FROM table_name;

-- Flow control with CASE
SELECT
    CASE WHEN status = 1 THEN 'Active' ELSE 'Inactive' END AS StatusLabel,
    CASE
        WHEN score >= 90 THEN 'A'
        WHEN score >= 80 THEN 'B'
        ELSE 'C'
    END AS Grade
FROM table_name;

-- IIF (inline IF, SQL Server 2012+)
SELECT IIF(stock > 0, 'In Stock', 'Out of Stock') AS Availability FROM Products;

-- COALESCE — return first non-NULL value
SELECT COALESCE(phone_mobile, phone_home, phone_work, 'No Phone') AS ContactNumber
FROM Customers;

-- String aggregation (SQL Server 2017+)
SELECT
    DepartmentID,
    STRING_AGG(EmployeeName, ', ') WITHIN GROUP (ORDER BY EmployeeName) AS Employees
FROM Employees
GROUP BY DepartmentID;
```

<div align="right">
    <b><a href="#">↥ back to top</a></b>
</div>

## Window Functions

Window functions perform calculations across a **window** of rows related to the current row without collapsing rows like `GROUP BY`.

**ROW_NUMBER / RANK / DENSE_RANK / NTILE:**

```sql
-- ROW_NUMBER: unique sequential number per partition (no ties)
SELECT EmployeeID, Department, Salary,
    ROW_NUMBER() OVER (PARTITION BY Department ORDER BY Salary DESC) AS RowNum
FROM Employees;

-- RANK: same rank for ties; gaps appear after ties (1, 2, 2, 4)
SELECT EmployeeID, Department, Salary,
    RANK() OVER (PARTITION BY Department ORDER BY Salary DESC) AS Rank
FROM Employees;

-- DENSE_RANK: same rank for ties; no gaps (1, 2, 2, 3)
SELECT EmployeeID, Department, Salary,
    DENSE_RANK() OVER (PARTITION BY Department ORDER BY Salary DESC) AS DenseRank
FROM Employees;

-- NTILE(n): divide rows into n approximately equal buckets
SELECT EmployeeID, Salary,
    NTILE(4) OVER (ORDER BY Salary DESC) AS Quartile
FROM Employees;

-- Most common pattern: get the top 1 row per group
WITH Ranked AS (
    SELECT *, ROW_NUMBER() OVER (PARTITION BY CustomerID ORDER BY OrderDate DESC) AS rn
    FROM Orders
)
SELECT * FROM Ranked WHERE rn = 1;
```

**Aggregate window functions (running totals, moving averages):**

```sql
-- Running total
SELECT OrderDate, TotalAmount,
    SUM(TotalAmount) OVER (ORDER BY OrderDate
        ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) AS RunningTotal
FROM Orders;

-- 3-row moving average
SELECT SaleDate, Revenue,
    AVG(Revenue) OVER (ORDER BY SaleDate
        ROWS BETWEEN 2 PRECEDING AND CURRENT ROW) AS MovingAvg3
FROM DailySales;

-- Each row\'s percentage of the grand total
SELECT ProductName, Revenue,
    ROUND(100.0 * Revenue / SUM(Revenue) OVER (), 2) AS PctOfTotal
FROM ProductRevenue;
```

**LAG / LEAD / FIRST_VALUE / LAST_VALUE:**

```sql
-- LAG: access a previous row\'s value (offset=1, default=0)
SELECT SaleDate, Revenue,
    LAG(Revenue, 1, 0)  OVER (ORDER BY SaleDate) AS PrevRevenue,
    Revenue - LAG(Revenue, 1, 0) OVER (ORDER BY SaleDate) AS Change
FROM DailySales;

-- LEAD: access a next row\'s value
SELECT SaleDate, Revenue,
    LEAD(Revenue, 1, 0) OVER (ORDER BY SaleDate) AS NextRevenue
FROM DailySales;

-- FIRST_VALUE / LAST_VALUE with explicit frame
SELECT EmployeeID, Department, Salary,
    FIRST_VALUE(Salary) OVER (PARTITION BY Department ORDER BY Salary DESC
        ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING) AS MaxInDept,
    LAST_VALUE(Salary)  OVER (PARTITION BY Department ORDER BY Salary DESC
        ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING) AS MinInDept
FROM Employees;
```

Window functions cannot appear in `WHERE` or `HAVING` directly — wrap them in a CTE or subquery and filter the outer query.

<div align="right">
    <b><a href="#">↥ back to top</a></b>
</div>

## Transactions

```sql
-- Basic transaction
BEGIN TRANSACTION;   -- or: BEGIN TRAN
    INSERT INTO Orders (CustomerID, TotalAmount) VALUES (1, 250.00);
    INSERT INTO OrderItems (OrderID, ProductID, Qty) VALUES (SCOPE_IDENTITY(), 5, 2);
COMMIT;              -- make all changes permanent

-- Rollback on error (legacy @@ERROR check)
BEGIN TRANSACTION;
    UPDATE Accounts SET Balance = Balance - 500 WHERE AccountID = 1;
    UPDATE Accounts SET Balance = Balance + 500 WHERE AccountID = 2;
    IF @@ERROR <> 0
        ROLLBACK;
    ELSE
        COMMIT;

-- Recommended pattern: TRY...CATCH with SET XACT_ABORT ON
SET XACT_ABORT ON;   -- automatically rolls back on any error severity >= 16
BEGIN TRY
    BEGIN TRANSACTION;
        UPDATE Accounts SET Balance = Balance - 500 WHERE AccountID = 1;
        UPDATE Accounts SET Balance = Balance + 500 WHERE AccountID = 2;
    COMMIT;
END TRY
BEGIN CATCH
    IF @@TRANCOUNT > 0
        ROLLBACK;
    THROW;   -- re-raise the original error to the caller
END CATCH;

-- SAVEPOINT: partial rollback within a transaction
BEGIN TRANSACTION;
    INSERT INTO AuditLog (Message) VALUES ('Step 1 complete');
    SAVE TRANSACTION sp1;

    INSERT INTO AuditLog (Message) VALUES ('Step 2 complete');
    ROLLBACK TRANSACTION sp1;   -- undo Step 2 only; Step 1 remains
COMMIT;

-- Check open transaction count
SELECT @@TRANCOUNT AS OpenTransactions;   -- 0 = no open transaction

-- Isolation levels
SET TRANSACTION ISOLATION LEVEL READ COMMITTED;    -- default (readers block on uncommitted writes)
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;  -- dirty reads allowed; no shared locks
SET TRANSACTION ISOLATION LEVEL REPEATABLE READ;   -- prevents non-repeatable reads
SET TRANSACTION ISOLATION LEVEL SERIALIZABLE;      -- strictest; prevents phantom reads
SET TRANSACTION ISOLATION LEVEL SNAPSHOT;          -- row versioning; readers don\'t block writers
-- Enable snapshot / RCSI at the database level:
ALTER DATABASE dbname SET ALLOW_SNAPSHOT_ISOLATION ON;
ALTER DATABASE dbname SET READ_COMMITTED_SNAPSHOT ON;
```

Always pair `BEGIN TRANSACTION` with either `COMMIT` or `ROLLBACK`. Use `SET XACT_ABORT ON` in stored procedures so any error automatically rolls back the open transaction. `SNAPSHOT` isolation (via row versioning) eliminates reader-writer blocking on high-concurrency OLTP workloads.

<div align="right">
    <b><a href="#">↥ back to top</a></b>
</div>

## Control Flow (IF / WHILE / TRY...CATCH)

**IF...ELSE:**

```sql
IF condition
BEGIN
    -- executed when condition is TRUE
END
ELSE IF other_condition
BEGIN
    -- executed when other_condition is TRUE
END
ELSE
BEGIN
    -- default branch
END;

-- Example
DECLARE @Stock INT = 5;
IF @Stock > 10
    PRINT 'Sufficient stock';
ELSE IF @Stock > 0
    PRINT 'Low stock — reorder soon';
ELSE
    PRINT 'Out of stock';
```

**WHILE:**

```sql
-- Basic loop
DECLARE @Counter INT = 1;
WHILE @Counter <= 5
BEGIN
    PRINT 'Iteration: ' + CAST(@Counter AS VARCHAR(10));
    SET @Counter = @Counter + 1;
END;

-- BREAK exits the loop; CONTINUE skips to the next iteration
WHILE 1 = 1
BEGIN
    IF (SELECT COUNT(*) FROM ProcessQueue WHERE Processed = 0) = 0
        BREAK;
    -- process one item...
END;
```

**TRY...CATCH:**

```sql
BEGIN TRY
    -- T-SQL that may raise an error
    INSERT INTO Orders (CustomerID, TotalAmount) VALUES (999, -50.00);
END TRY
BEGIN CATCH
    SELECT
        ERROR_NUMBER()    AS ErrorNumber,
        ERROR_SEVERITY()  AS Severity,
        ERROR_STATE()     AS State,
        ERROR_PROCEDURE() AS ProcedureName,
        ERROR_LINE()      AS LineNumber,
        ERROR_MESSAGE()   AS Message;

    THROW;   -- re-raise the original error to the caller (SQL Server 2012+)
END CATCH;

-- THROW: raise a custom error (preferred over legacy RAISERROR)
THROW 50001, 'Invalid order: negative total not allowed.', 1;

-- RAISERROR (legacy syntax, still supported)
RAISERROR('Error in %s at line %d', 16, 1, 'usp_ProcessOrder', 42);
```

Use `TRY...CATCH` to handle errors gracefully inside stored procedures and batches. `THROW` (SQL Server 2012+) re-raises with the original error number and is preferred over `RAISERROR`. Combine with `SET XACT_ABORT ON` and explicit `ROLLBACK` inside `CATCH` for reliable transaction management.

<div align="right">
    <b><a href="#">↥ back to top</a></b>
</div>

## String Functions

```sql
-- Length
SELECT LEN('Hello World')        AS CharLength;   -- 11 (excludes trailing spaces)
SELECT DATALENGTH('Hello World') AS ByteLength;   -- 11 for VARCHAR; 22 for NVARCHAR

-- Case
SELECT UPPER('hello') AS Upper;   -- 'HELLO'
SELECT LOWER('HELLO') AS Lower;   -- 'hello'

-- Trim whitespace
SELECT TRIM('  Hello  ')   AS Trimmed;       -- 'Hello'        (SQL Server 2017+)
SELECT LTRIM('  Hello  ')  AS LeftTrimmed;   -- 'Hello  '
SELECT RTRIM('  Hello  ')  AS RightTrimmed;  -- '  Hello'
-- Trim specific characters (SQL Server 2022+)
SELECT TRIM('.' FROM '...Hello...') AS CustomTrim;  -- 'Hello'

-- Substring / extraction
SELECT SUBSTRING('SQL Server 2025', 5, 6)  AS Mid;    -- 'Server'
SELECT LEFT('SQL Server', 3)               AS Left3;  -- 'SQL'
SELECT RIGHT('SQL Server', 6)              AS Right6; -- 'Server'

-- Search / position
SELECT CHARINDEX('Server', 'SQL Server 2025')   AS Position;    -- 5
SELECT PATINDEX('%[0-9]%', 'SQL Server 2025')   AS FirstDigit;  -- 11

-- Replace / insert
SELECT REPLACE('SQL Server 2019', '2019', '2025') AS Updated;  -- 'SQL Server 2025'
SELECT STUFF('SQL Server', 5, 6, 'Query')         AS Stuffed;  -- 'SQL Query'

-- Repeat and reverse
SELECT REPLICATE('*', 5)  AS Stars;  -- '*****'
SELECT REVERSE('Hello')   AS Rev;   -- 'olleH'

-- Formatting and padding
SELECT FORMAT(42, '000')                       AS ZeroPad;   -- '042'
SELECT RIGHT('00000' + CAST(42 AS VARCHAR), 5) AS Padded;   -- '00042'

-- Concatenation
SELECT CONCAT('SQL', ' ', 'Server', ' ', '2025')    AS Concat;     -- 'SQL Server 2025'
SELECT CONCAT_WS(', ', 'Alice', 'Bob', 'Carol')      AS Delimited;  -- 'Alice, Bob, Carol'

-- Split a delimited string into rows (SQL Server 2016+)
SELECT value FROM STRING_SPLIT('Apple,Banana,Cherry', ',');

-- Aggregate strings into one value (SQL Server 2017+)
SELECT DepartmentID,
    STRING_AGG(Name, ', ') WITHIN GROUP (ORDER BY Name) AS Members
FROM Employees
GROUP BY DepartmentID;

-- Soundex / phonetic matching
SELECT SOUNDEX('Smith'), SOUNDEX('Smythe');   -- both return 'S530'
SELECT DIFFERENCE('Smith', 'Smythe');         -- 4 = very similar

-- Check if value is numeric (TRY_CAST is more precise than ISNUMERIC)
SELECT TRY_CAST('123' AS INT)   AS IsInt;      -- 123 if numeric, NULL if not
SELECT ISNUMERIC('1e3')         AS Numeric;    -- 1 (includes scientific notation — less strict)
```

<div align="right">
    <b><a href="#">↥ back to top</a></b>
</div>

## JSON Functions

```sql
-- Validate JSON
SELECT ISJSON('{"name":"Alice","age":30}') AS IsValid;   -- 1
SELECT ISJSON('not json')                  AS IsValid;   -- 0

-- Extract a scalar value with JSON_VALUE
SELECT JSON_VALUE('{"name":"Alice","score":95}', '$.name')    AS Name;   -- 'Alice'
SELECT JSON_VALUE('{"items":[1,2,3]}',           '$.items[0]') AS First; -- '1'

-- Extract a JSON fragment (object or array) with JSON_QUERY
SELECT JSON_QUERY('{"user":{"id":1,"name":"Alice"}}', '$.user') AS UserObj;

-- Modify JSON (SQL Server 2016+)
SELECT JSON_MODIFY('{"name":"Alice"}', '$.age', 30) AS Updated;
-- Result: {"name":"Alice","age":30}

-- Convert a result set to JSON
SELECT ProductID, ProductName, Price
FROM Products
FOR JSON AUTO;                         -- automatic structure

SELECT o.OrderID       AS [order.id],
       o.OrderDate     AS [order.date],
       c.Name          AS [customer.name]
FROM Orders o
JOIN Customers c ON o.CustomerID = c.CustomerID
FOR JSON PATH, ROOT('orders');         -- custom nested structure

-- Shred a JSON array into rows with OPENJSON
SELECT *
FROM OPENJSON('[{"id":1,"name":"Bolt"},{"id":2,"name":"Nut"}]')
WITH (
    id   INT           '$.id',
    name NVARCHAR(50)  '$.name'
);

-- Store and query JSON in a column
CREATE TABLE Events (
    EventID INT IDENTITY PRIMARY KEY,
    Payload NVARCHAR(MAX) CHECK (ISJSON(Payload) = 1)
);
INSERT INTO Events (Payload)
VALUES ('{"user":"Alice","action":"login","ip":"10.0.0.1"}');

SELECT EventID,
    JSON_VALUE(Payload, '$.user')   AS UserName,
    JSON_VALUE(Payload, '$.action') AS Action
FROM Events;

-- JSON_ARRAYAGG / JSON_OBJECTAGG (SQL Server 2025)
SELECT JSON_ARRAYAGG(ProductName ORDER BY ProductName) AS ProductList
FROM Products WHERE CategoryID = 1;

SELECT JSON_OBJECTAGG(ProductID: ProductName) AS ProductMap
FROM Products WHERE CategoryID = 1;
```

<div align="right">
    <b><a href="#">↥ back to top</a></b>
</div>

## Constraints

```sql
-- PRIMARY KEY: uniquely identifies each row; implicitly NOT NULL
CREATE TABLE Customers (
    CustomerID INT IDENTITY(1,1) PRIMARY KEY,
    Email      NVARCHAR(255)     NOT NULL
);

-- Composite PRIMARY KEY
CREATE TABLE OrderItems (
    OrderID   INT NOT NULL,
    ProductID INT NOT NULL,
    Quantity  INT NOT NULL DEFAULT 1,
    CONSTRAINT PK_OrderItems PRIMARY KEY (OrderID, ProductID)
);

-- FOREIGN KEY: enforces referential integrity between tables
CREATE TABLE Orders (
    OrderID    INT IDENTITY(1,1) PRIMARY KEY,
    CustomerID INT NOT NULL,
    CONSTRAINT FK_Orders_Customers
        FOREIGN KEY (CustomerID) REFERENCES Customers (CustomerID)
        ON DELETE CASCADE       -- delete child rows when parent is deleted
        ON UPDATE NO ACTION
);

-- UNIQUE: allows one NULL per column; enforces distinct non-NULL values
ALTER TABLE Customers
ADD CONSTRAINT UQ_Customers_Email UNIQUE (Email);

-- CHECK: validate column values with an expression
ALTER TABLE Products
ADD CONSTRAINT CHK_Products_Price CHECK (Price > 0);

ALTER TABLE Employees
ADD CONSTRAINT CHK_Employees_Status
    CHECK (Status IN ('Active', 'Inactive', 'Pending'));

-- DEFAULT: provide a value when none is specified
ALTER TABLE Orders
ADD CONSTRAINT DF_Orders_Status    DEFAULT 'Pending'      FOR Status;
ALTER TABLE Orders
ADD CONSTRAINT DF_Orders_CreatedAt DEFAULT GETUTCDATE()   FOR CreatedAt;

-- NOT NULL: modify a column to require a value
ALTER TABLE Customers ALTER COLUMN Phone NVARCHAR(20) NOT NULL;

-- Add a named constraint using ALTER TABLE
ALTER TABLE table_name
ADD CONSTRAINT constraint_name constraint_type (column_name);

-- Drop a constraint
ALTER TABLE table_name DROP CONSTRAINT constraint_name;

-- List all constraints on a table
SELECT
    c.name        AS ConstraintName,
    c.type_desc   AS ConstraintType,
    col.name      AS ColumnName
FROM sys.objects c
JOIN sys.tables t  ON c.parent_object_id = t.object_id
LEFT JOIN sys.columns col
    ON col.object_id       = c.parent_object_id
    AND col.default_object_id = c.object_id
WHERE t.name = 'table_name'
  AND c.type IN ('PK','UQ','C','F','D');
```

SQL Server enforces data integrity through six constraint types: `PRIMARY KEY` (unique non-null row identifier), `FOREIGN KEY` (referential integrity), `UNIQUE` (distinct values), `CHECK` (expression validation), `DEFAULT` (fallback values), and `NOT NULL` (column-level). Always give constraints explicit names for easier maintenance.

<div align="right">
    <b><a href="#">↥ back to top</a></b>
</div>

## BACKUP / RESTORE

```sql
-- Full backup (baseline; required to start a restore chain)
BACKUP DATABASE DatabaseName
TO DISK = 'C:\Backups\DatabaseName_Full.bak'
WITH FORMAT,           -- overwrite existing backup set
     COMPRESSION,      -- reduce file size (SQL Server 2008+)
     STATS = 10,       -- report progress every 10%
     NAME = 'Full Backup - DatabaseName';

-- Differential backup (changes since last full backup)
BACKUP DATABASE DatabaseName
TO DISK = 'C:\Backups\DatabaseName_Diff.bak'
WITH DIFFERENTIAL, COMPRESSION, STATS = 10;

-- Transaction log backup (requires FULL or BULK_LOGGED recovery model)
BACKUP LOG DatabaseName
TO DISK = 'C:\Backups\DatabaseName_Log.bak'
WITH COMPRESSION, STATS = 10;

-- Verify a backup without restoring data
RESTORE VERIFYONLY FROM DISK = 'C:\Backups\DatabaseName_Full.bak';

-- Restore full backup (NORECOVERY = leave DB in restoring state for further backups)
RESTORE DATABASE DatabaseName
FROM DISK = 'C:\Backups\DatabaseName_Full.bak'
WITH NORECOVERY,
     MOVE 'DatabaseName'     TO 'C:\SQLData\DatabaseName.mdf',
     MOVE 'DatabaseName_log' TO 'C:\SQLData\DatabaseName.ldf',
     STATS = 10;

-- Apply differential backup
RESTORE DATABASE DatabaseName
FROM DISK = 'C:\Backups\DatabaseName_Diff.bak'
WITH NORECOVERY, STATS = 10;

-- Apply each transaction log backup in chronological order
RESTORE LOG DatabaseName
FROM DISK = 'C:\Backups\DatabaseName_Log.bak'
WITH NORECOVERY;

-- Final step: bring the database online (RECOVERY)
RESTORE DATABASE DatabaseName WITH RECOVERY;

-- Point-in-time restore (stop at a specific moment during log apply)
RESTORE LOG DatabaseName
FROM DISK = 'C:\Backups\DatabaseName_Log.bak'
WITH STOPAT = '2026-04-19T10:30:00', RECOVERY;

-- Backup to Azure Blob Storage (SQL Server 2012+)
BACKUP DATABASE DatabaseName
TO URL = 'https://storageaccount.blob.core.windows.net/backups/DatabaseName_Full.bak'
WITH CREDENTIAL = 'AzureStorageCredential', COMPRESSION, STATS = 10;

-- View backup history from msdb
SELECT TOP 20
    s.database_name,
    s.backup_start_date,
    s.backup_finish_date,
    CASE s.type
        WHEN 'D' THEN 'Full'
        WHEN 'I' THEN 'Differential'
        WHEN 'L' THEN 'Log'
    END AS BackupType,
    s.backup_size / 1048576 AS SizeMB
FROM msdb.dbo.backupset s
ORDER BY s.backup_finish_date DESC;
```

The restore sequence is: **Full** → **Differential** (optional) → **Log backups in order** → **RECOVERY**. Use `WITH NORECOVERY` on all steps except the last. `STOPAT` enables point-in-time recovery within a log backup. Back up to Azure Blob Storage with `TO URL` for off-site, geo-redundant protection.

<div align="right">
    <b><a href="#">↥ back to top</a></b>
</div>
