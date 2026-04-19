# MSSQL-Server 2025 Frequently Asked Questions

<br/>

## Q. What is difference between Correlated subquery and nested subquery?

**1. Correlated subqueries:**

Correlated subqueries are used for row-by-row processing. Each subquery is executed once for every row of the outer query.

A correlated subquery is evaluated once for each row processed by the parent statement. The parent statement can be a SELECT, UPDATE, or DELETE statement.

**Example:**

```sql
--- Correlated Subquery
SELECT e.EmpFirstName, e.Salary, e.DeptId 
FROM Employee e 
WHERE e.Salary = (SELECT max(Salary) FROM Employee ee WHERE ee.DeptId = e.DeptId)
```

**2. Nested subqueries:**

A subquery can be nested inside other subqueries. SQL has an ability to nest queries within one another. A subquery is a SELECT statement that is nested within another SELECT statement and which return intermediate results. SQL executes innermost subquery first, then next level.

**Example:**

```sql
--- Nested Subquery
-- SQL Server does not support row-value constructor (DeptId, Salary) IN (...).
-- Use a derived table or CTE joined on both columns instead.
SELECT e.EmpFirstName, e.Salary, e.DeptId
FROM Employee e
JOIN (
    SELECT DeptId, MAX(Salary) AS MaxSalary
    FROM Employee
    GROUP BY DeptId
) AS dept_max
  ON e.DeptId = dept_max.DeptId
 AND e.Salary = dept_max.MaxSalary;
```

<div align="right">
    <b><a href="#">↥ back to top</a></b>
</div>

## Q. What are indexes in a Database?

Indexing is a way to optimize the performance of a database by minimizing the number of disk accesses required when a query is processed. It is a data structure technique which is used to quickly locate and access the data in a database.

Indexes are created using a few database columns

* The first column is the **Search key** that contains a copy of the primary key or candidate key of the table. These values are stored in sorted order so that the corresponding data can be accessed quickly.

* The second column is the **Data Reference** or **Pointer** which contains a set of pointers holding the address of the disk block where that particular key value can be found.

|Sl.No|Query                               | Description                                       |
|-----|------------------------------------|---------------------------------------------------|
| 01. |CREATE INDEX index_name ON t(c1, c2) |Create an index on columns c1 and c2 of the table t |
| 02. |CREATE UNIQUE INDEX index_name ON t(c3, c4) |Create a unique index on columns c3 and c4 of the table t |
| 03. |DROP INDEX index_name |Drop an index |

**Example:**

```sql
-- Create a non-clustered index on one or more columns
CREATE INDEX index_name ON table_name (column1, column2, ...);

-- Create a clustered index (one per table; defines physical row order)
CREATE CLUSTERED INDEX index_name ON table_name (column_name);

-- Create a covering index with INCLUDE columns (eliminates key lookups)
CREATE NONCLUSTERED INDEX index_name
ON table_name (column1)
INCLUDE (column2, column3);

-- View indexes on a table (replaces MySQL SHOW INDEX FROM)
SELECT
    i.name          AS IndexName,
    i.type_desc     AS IndexType,
    i.is_unique     AS IsUnique,
    c.name          AS ColumnName,
    ic.key_ordinal  AS KeyOrder
FROM sys.indexes i
JOIN sys.index_columns ic ON ic.object_id = i.object_id AND ic.index_id = i.index_id
JOIN sys.columns c        ON c.object_id  = i.object_id AND c.column_id  = ic.column_id
WHERE i.object_id = OBJECT_ID('table_name')
ORDER BY i.index_id, ic.key_ordinal;

-- Rebuild an index (removes fragmentation)
ALTER INDEX index_name ON table_name REBUILD;

-- Reorganize an index (online defragment; lower resource use)
ALTER INDEX index_name ON table_name REORGANIZE;

-- Disable / re-enable an index
ALTER INDEX index_name ON table_name DISABLE;
ALTER INDEX index_name ON table_name REBUILD;   -- re-enables

-- Drop an index
DROP INDEX IF EXISTS index_name ON table_name;
```

<div align="right">
    <b><a href="#">↥ back to top</a></b>
</div>

## Q. What are the types of indexes in sql?

**1. Clustered Index:**

Clustered index is the type of indexing that establishes a physical sorting order of rows. Clustered index is like Dictionary; in the dictionary, sorting order is alphabetical and there is no separate index page.

**2. Non-clustered:**

Non-Clustered index is an index structure separate from the data stored in a table that reorders one or more selected columns. The non-clustered index is created to improve the performance of frequently used queries not covered by a clustered index. It\'s like a textbook; the index page is created separately at the beginning of that book.

<div align="right">
    <b><a href="#">↥ back to top</a></b>
</div>

## Q. What is transactions in SQL?

A SQL transaction is a grouping of one or more SQL statements that interact with a database. A transaction in its entirety can commit to a database as a single logical unit or rollback (become undone) as a single logical unit.

In SQL, transactions are essential for maintaining database integrity. They are used to preserve integrity when multiple related operations are executed concurrently, or when multiple users interact with a database concurrently.

**Properties of Transactions:**

Transactions have the following four standard properties, usually referred to by the acronym ACID.

* **Atomicity** − ensures that all operations within the work unit are completed successfully. Otherwise, the transaction is aborted at the point of failure and all the previous operations are rolled back to their former state.

* **Consistency** − ensures that the database properly changes states upon a successfully committed transaction.

* **Isolation** − enables transactions to operate independently of and transparent to each other.

* **Durability** − ensures that the result or effect of a committed transaction persists in case of a system failure.

**Transaction Control:**

The following commands are used to control transactions.

* **COMMIT** − to save the changes.

* **ROLLBACK** − to roll back the changes.

* **SAVEPOINT** − creates points within the groups of transactions in which to ROLLBACK.

* **SET TRANSACTION** − Places a name on a transaction.

**Example:**

```sql
-- Example - 01

-- MSSQL uses INT IDENTITY(1,1) instead of SERIAL
-- and BEGIN TRANSACTION / COMMIT instead of START TRANSACTION

CREATE TABLE widgetInventory (
    id          INT IDENTITY(1,1) PRIMARY KEY,
    description NVARCHAR(255)     NOT NULL,
    onhand      INT               NOT NULL
);

CREATE TABLE widgetSales (
    id     INT IDENTITY(1,1) PRIMARY KEY,
    inv_id INT,
    quan   INT,
    price  INT
);

INSERT INTO widgetInventory (description, onhand) VALUES ('rock',     25);
INSERT INTO widgetInventory (description, onhand) VALUES ('paper',    25);
INSERT INTO widgetInventory (description, onhand) VALUES ('scissors', 25);

-- Successful transaction
BEGIN TRANSACTION;
    INSERT INTO widgetSales (inv_id, quan, price) VALUES (1, 5, 500);
    UPDATE widgetInventory SET onhand = onhand - 5 WHERE id = 1;
COMMIT;

SELECT * FROM widgetInventory;
SELECT * FROM widgetSales;

-- Transaction that is rolled back
BEGIN TRANSACTION;
    INSERT INTO widgetInventory (description, onhand) VALUES ('toy', 25);
ROLLBACK;

SELECT * FROM widgetInventory;   -- 'toy' row will not appear
SELECT * FROM widgetSales;

-- Recommended pattern: TRY...CATCH with automatic rollback (SET XACT_ABORT ON)
SET XACT_ABORT ON;
BEGIN TRY
    BEGIN TRANSACTION;
        INSERT INTO widgetSales (inv_id, quan, price) VALUES (2, 10, 300);
        UPDATE widgetInventory SET onhand = onhand - 10 WHERE id = 2;
    COMMIT;
END TRY
BEGIN CATCH
    IF @@TRANCOUNT > 0
        ROLLBACK;
    THROW;   -- re-raise the original error
END CATCH;
```

<div align="right">
    <b><a href="#">↥ back to top</a></b>
</div>

## Q. What is Views in SQL?

A view is a virtual table that is a result of a query. They can be extremely useful and are often used as a security mechanism, letting users access the data through the view, rather than letting them access the underlying base table:

**Syntax:**

```sql
CREATE VIEW view_name AS
SELECT column1, column2, ...
FROM table_name
WHERE condition;
```

**Example:**

```sql
--- Creating a View
-- MSSQL uses / for integer division and % for modulo (not DIV / MOD)
CREATE VIEW trackView AS
    SELECT
        id,
        album_id,
        title,
        track_number,
        duration / 60  AS m,   -- integer division gives whole minutes
        duration % 60  AS s    -- modulo gives remaining seconds
    FROM track;

SELECT * FROM trackView;

-- Drop the view
DROP VIEW IF EXISTS trackView;

-- Refresh view metadata after base table changes
-- (equivalent of MySQL CREATE OR REPLACE VIEW)
ALTER VIEW trackView AS
    SELECT id, album_id, title, track_number,
           duration / 60 AS m, duration % 60 AS s
    FROM track;
```

<div align="right">
    <b><a href="#">↥ back to top</a></b>
</div>

## Q. What are the triggers in SQL?

A trigger is a stored procedure in database which automatically invokes whenever a special event in the database occurs. For example, a trigger can be invoked when a row is inserted into a specified table or when certain table columns are being updated.

**Syntax:**

```sql
-- MSSQL Server trigger syntax
CREATE TRIGGER trigger_name
ON table_name
{ FOR | AFTER | INSTEAD OF } { INSERT | UPDATE | DELETE }
AS
BEGIN
    SET NOCOUNT ON;
    -- trigger body: use inserted / deleted pseudo-tables
END;
GO
```

**Example - 01:**

```sql
-- AFTER INSERT trigger: populate full_name from first_name and last_name
-- Uses the 'inserted' pseudo-table (rows just inserted)
CREATE TRIGGER trg_employee_fullname
ON employee
AFTER INSERT
AS
BEGIN
    SET NOCOUNT ON;
    UPDATE e
    SET e.full_name = i.first_name + ' ' + i.last_name
    FROM employee e
    JOIN inserted i ON e.employee_id = i.employee_id;
END;
GO
```

**Example - 02: Audit trigger (log changes on UPDATE):**

```sql
CREATE TRIGGER trg_employee_audit
ON employee
AFTER UPDATE
AS
BEGIN
    SET NOCOUNT ON;
    INSERT INTO employee_audit (employee_id, old_salary, new_salary, changed_at)
    SELECT
        d.employee_id,
        d.salary        AS old_salary,
        i.salary        AS new_salary,
        GETUTCDATE()    AS changed_at
    FROM deleted  d                              -- pre-UPDATE values
    JOIN inserted i ON d.employee_id = i.employee_id  -- post-UPDATE values
    WHERE d.salary <> i.salary;                  -- only when salary actually changed
END;
GO

-- Disable / enable a trigger
DISABLE TRIGGER trg_employee_fullname ON employee;
ENABLE  TRIGGER trg_employee_fullname ON employee;

-- Drop a trigger
DROP TRIGGER IF EXISTS trg_employee_fullname;
```

<div align="right">
    <b><a href="#">↥ back to top</a></b>
</div>

## Q. What is a cursor?

When we execute any SQL operations, SQL Server opens a work area in memory which is called Cursor. When it is required to perform the row by row operations which are not possible with the set-based operations then cursor is used.

There are two of cursors:

**1. Implicit Cursor:**

Implicit Cursors are also known as Default Cursors of SQL SERVER. These Cursors are allocated by SQL SERVER when the user performs DML operations.

**2. Explicit Cursor:**

* When the programmer wants to perform the row by row operations for the result set containing more than one row, then he explicitly declares a cursor with a name.

* They are managed by `DECLARE`, `OPEN`, `FETCH`, and `CLOSE`.

* In MSSQL, cursor state is checked using **`@@FETCH_STATUS`** (0 = success, -1 = beyond result set, -2 = row missing).

**Full Explicit Cursor Lifecycle:**

**1. Declare Cursor Object:**

```sql
-- DECLARE cursor_name CURSOR FOR <SELECT statement>
DECLARE s1 CURSOR
    LOCAL           -- scope: current batch/procedure only
    FORWARD_ONLY    -- can only FETCH NEXT (most efficient)
    READ_ONLY       -- cannot update rows through the cursor
FOR
    SELECT EmployeeID, FirstName, LastName FROM Employee;
```

**2. Open Cursor Connection:**

```sql
OPEN s1;
```

**3. Fetch Data from cursor:**

SQL Server supports the following `FETCH` options:

* **NEXT** — fetch the next row (default; works with FORWARD_ONLY cursors)
* **PRIOR** — fetch the previous row (requires SCROLL cursor)
* **FIRST** — fetch the first row (requires SCROLL cursor)
* **LAST** — fetch the last row (requires SCROLL cursor)
* **ABSOLUTE n** — fetch the exact nth row (requires SCROLL cursor)
* **RELATIVE n** — fetch n rows forward (+) or backward (-) (requires SCROLL cursor)

```sql
-- Declare variables to hold fetched values
DECLARE @EmpID    INT;
DECLARE @First    NVARCHAR(100);
DECLARE @Last     NVARCHAR(100);

-- Fetch the first row
FETCH NEXT FROM s1 INTO @EmpID, @First, @Last;

-- Loop while rows remain (@@FETCH_STATUS = 0 means success)
WHILE @@FETCH_STATUS = 0
BEGIN
    PRINT CAST(@EmpID AS NVARCHAR) + ': ' + @First + ' ' + @Last;
    FETCH NEXT FROM s1 INTO @EmpID, @First, @Last;
END;

-- SCROLL cursor example (allows non-sequential access)
DECLARE s2 CURSOR SCROLL FOR SELECT EmployeeID FROM Employee;
OPEN s2;
FETCH FIRST    FROM s2;          -- first row
FETCH LAST     FROM s2;          -- last row
FETCH ABSOLUTE 5  FROM s2;       -- 5th row
FETCH RELATIVE -2 FROM s2;       -- 2 rows before current
FETCH PRIOR    FROM s2;          -- one row back
```

**4. Close cursor connection:**

```sql
CLOSE s1;
```

**5. Deallocate cursor memory:**

```sql
DEALLOCATE s1;
```

> **Note:** Cursors are a last resort in MSSQL. Set-based operations (window functions, CTEs, `UPDATE...FROM`) are always preferred over cursors for performance.

<div align="right">
    <b><a href="#">↥ back to top</a></b>
</div>

## Q. What is stored procedure in SQL?

Stored Procedures are created to perform one or more DML operations on Database. It is nothing but the group of SQL statements that accepts some input in the form of parameters and performs some task and may or may not returns a value.

**Syntax:**

```sql
-- MSSQL Server stored procedure syntax
CREATE PROCEDURE procedure_name
    @Param1 datatype,
    @Param2 datatype = default_value    -- optional parameter with default
AS
BEGIN
    SET NOCOUNT ON;    -- suppress "N rows affected" messages
    -- SQL statements
END;
GO
```

**Example:**

```sql
-- Simple procedure: select all customers
CREATE PROCEDURE SelectAllCustomers
AS
BEGIN
    SET NOCOUNT ON;
    SELECT * FROM Customers;
END;
GO
```

Execute the stored procedure above as follows:

```sql
EXEC SelectAllCustomers;
```

**Example with parameters and OUTPUT:**

```sql
-- Procedure with input parameters and an OUTPUT parameter
CREATE PROCEDURE usp_GetCustomersByCity
    @City       NVARCHAR(100),
    @TotalCount INT OUTPUT
AS
BEGIN
    SET NOCOUNT ON;

    SELECT CustomerID, Name, Email
    FROM Customers
    WHERE City = @City
    ORDER BY Name;

    SET @TotalCount = @@ROWCOUNT;   -- number of rows returned
END;
GO

-- Execute with OUTPUT parameter
DECLARE @Count INT;
EXEC usp_GetCustomersByCity
    @City       = 'London',
    @TotalCount = @Count OUTPUT;
SELECT @Count AS TotalCustomers;

-- Alter an existing procedure
ALTER PROCEDURE usp_GetCustomersByCity
    @City NVARCHAR(100)
AS
BEGIN
    SET NOCOUNT ON;
    SELECT CustomerID, Name FROM Customers WHERE City = @City;
END;
GO

-- Drop a procedure
DROP PROCEDURE IF EXISTS usp_GetCustomersByCity;
```

<div align="right">
    <b><a href="#">↥ back to top</a></b>
</div>

---

## Joins & Relationships

## Q. What are the different types of JOINs in SQL Server?

SQL Server supports the following JOIN types:

| Join Type | Returns |
|---|---|
| `INNER JOIN` | Only rows with matching values in **both** tables |
| `LEFT [OUTER] JOIN` | All rows from the left table + matching rows from right (NULLs for no match) |
| `RIGHT [OUTER] JOIN` | All rows from the right table + matching rows from left (NULLs for no match) |
| `FULL [OUTER] JOIN` | All rows from both tables; NULLs where there is no match on either side |
| `CROSS JOIN` | Cartesian product — every row of table A combined with every row of table B |
| `SELF JOIN` | A table joined to itself (uses aliases) |

**Example — all join types on Employees / Departments:**

```sql
-- Sample tables
-- Employees: EmpID, Name, DeptID
-- Departments: DeptID, DeptName

-- INNER JOIN: employees who belong to a department
SELECT e.Name, d.DeptName
FROM   Employees e
INNER JOIN Departments d ON e.DeptID = d.DeptID;

-- LEFT JOIN: all employees, even those with no department assigned
SELECT e.Name, d.DeptName
FROM   Employees e
LEFT JOIN Departments d ON e.DeptID = d.DeptID;

-- RIGHT JOIN: all departments, even those with no employees
SELECT e.Name, d.DeptName
FROM   Employees e
RIGHT JOIN Departments d ON e.DeptID = d.DeptID;

-- FULL OUTER JOIN: all employees and all departments
SELECT e.Name, d.DeptName
FROM   Employees e
FULL OUTER JOIN Departments d ON e.DeptID = d.DeptID;

-- CROSS JOIN: every combination of employee and department (no ON clause)
SELECT e.Name, d.DeptName
FROM   Employees e
CROSS JOIN Departments d;
```

<div align="right">
    <b><a href="#">↥ back to top</a></b>
</div>

## Q. What is the difference between INNER JOIN and OUTER JOIN?

| Feature | INNER JOIN | OUTER JOIN (LEFT/RIGHT/FULL) |
|---|---|---|
| Rows returned | Only matching rows | Matching rows **plus** unmatched rows (as NULLs) |
| Use case | Related data guaranteed to exist on both sides | Optional relationships (e.g. customer without orders) |
| NULL in result | Never from join condition | Yes, for unmatched side |

```sql
-- Employees table: EmpID 1 (Alice, Dept 10), 2 (Bob, Dept NULL)
-- Departments table: DeptID 10 (HR), 20 (Finance)

-- INNER JOIN — Bob excluded (no dept); Finance excluded (no employee)
SELECT e.Name, d.DeptName
FROM   Employees e
INNER JOIN Departments d ON e.DeptID = d.DeptID;
-- Result: Alice | HR

-- LEFT JOIN — Bob included with NULL DeptName; Finance still excluded
SELECT e.Name, d.DeptName
FROM   Employees e
LEFT JOIN Departments d ON e.DeptID = d.DeptID;
-- Result: Alice | HR
--         Bob   | NULL

-- FULL OUTER JOIN — all rows from both sides
SELECT e.Name, d.DeptName
FROM   Employees e
FULL OUTER JOIN Departments d ON e.DeptID = d.DeptID;
-- Result: Alice   | HR
--         Bob     | NULL
--         NULL    | Finance
```

<div align="right">
    <b><a href="#">↥ back to top</a></b>
</div>

## Q. What is a self-join and when would you use it?

A **self-join** joins a table to itself using two different aliases. It is used when rows within the same table have a hierarchical or peer relationship (e.g. manager–employee, product pairs).

```sql
-- Find each employee and their manager\'s name
-- Employees: EmpID, Name, ManagerID (ManagerID references EmpID)
SELECT
    e.Name       AS Employee,
    m.Name       AS Manager
FROM   Employees e
LEFT JOIN Employees m ON e.ManagerID = m.EmpID
ORDER BY m.Name, e.Name;

-- Find pairs of employees in the same department (avoid duplicates with e1.EmpID < e2.EmpID)
SELECT
    e1.Name AS Employee1,
    e2.Name AS Employee2,
    e1.DeptID
FROM   Employees e1
JOIN   Employees e2 ON e1.DeptID = e2.DeptID
                   AND e1.EmpID  < e2.EmpID;
```

<div align="right">
    <b><a href="#">↥ back to top</a></b>
</div>

## Q. What is a CROSS JOIN and when should it be used?

A **CROSS JOIN** produces a Cartesian product — every row from the left table combined with every row from the right table. With M rows on the left and N rows on the right, the result has M × N rows. There is no `ON` condition.

**Common use cases:**
- Generate all combinations (e.g. sizes × colours for a product catalogue)
- Build a calendar or number tally table
- Test data generation

```sql
-- Generate all size/colour combinations for a product
SELECT s.SizeName, c.ColorName
FROM   Sizes  s
CROSS JOIN Colors c;
-- 3 sizes × 4 colors = 12 rows

-- Generate a sequence of numbers 1–100 using a tally CTE
WITH Tally AS (
    SELECT TOP 100 ROW_NUMBER() OVER (ORDER BY (SELECT NULL)) AS n
    FROM   sys.all_columns
)
SELECT n FROM Tally ORDER BY n;
```

> **Warning:** A CROSS JOIN on large tables can produce billions of rows. Always be intentional — use it only when the Cartesian product is the desired result.

<div align="right">
    <b><a href="#">↥ back to top</a></b>
</div>

## Q. What is a non-equi join?

A **non-equi join** uses a condition other than equality (`=`) in the `ON` clause — typically `BETWEEN`, `<`, `>`, `!=`, or range comparisons. It is used when rows relate by a range rather than an exact key match.

```sql
-- Assign a salary grade to each employee based on a SalaryGrades range table
-- SalaryGrades: Grade, MinSalary, MaxSalary
SELECT
    e.Name,
    e.Salary,
    g.Grade
FROM   Employees     e
JOIN   SalaryGrades  g ON e.Salary BETWEEN g.MinSalary AND g.MaxSalary;

-- Find employee pairs where the salary difference is less than 5000
SELECT
    e1.Name AS Emp1, e1.Salary,
    e2.Name AS Emp2, e2.Salary,
    ABS(e1.Salary - e2.Salary) AS SalaryDiff
FROM   Employees e1
JOIN   Employees e2 ON e1.EmpID < e2.EmpID               -- avoid duplicates
                   AND ABS(e1.Salary - e2.Salary) < 5000;
```

<div align="right">
    <b><a href="#">↥ back to top</a></b>
</div>

## Q. When should you use a JOIN versus a subquery?

| Scenario | Prefer |
|---|---|
| Retrieving columns from multiple tables | `JOIN` |
| Existence check only (`EXISTS`) | Correlated subquery or `EXISTS` |
| Aggregation used as a filter | Subquery in `WHERE` / `HAVING`, or CTE |
| Readability / complex multi-step logic | CTE |
| Performance on large sets | `JOIN` (optimizer can use hash/merge join strategies) |

```sql
-- Prefer JOIN: get customer name alongside order total
SELECT c.Name, SUM(o.Amount) AS Total
FROM   Customers c
JOIN   Orders o ON c.CustomerID = o.CustomerID
GROUP BY c.Name;

-- Prefer EXISTS: check if a customer has placed any order (no columns needed from Orders)
SELECT c.Name
FROM   Customers c
WHERE  EXISTS (
    SELECT 1 FROM Orders o WHERE o.CustomerID = c.CustomerID
);

-- Prefer CTE for readability when logic is multi-step
WITH DeptAverages AS (
    SELECT DeptID, AVG(Salary) AS AvgSalary
    FROM   Employees
    GROUP BY DeptID
)
SELECT e.Name, e.Salary, d.AvgSalary
FROM   Employees e
JOIN   DeptAverages d ON e.DeptID = d.DeptID
WHERE  e.Salary > d.AvgSalary;
```

<div align="right">
    <b><a href="#">↥ back to top</a></b>
</div>

---

## Aggregation & Window Functions

## Q. What is the difference between WHERE and HAVING?

| Clause | Filters | Timing | Can use aggregates? |
|---|---|---|---|
| `WHERE` | Individual rows | **Before** grouping | No |
| `HAVING` | Groups / aggregated results | **After** `GROUP BY` | Yes |

```sql
-- WHERE filters rows before aggregation
SELECT DeptID, AVG(Salary) AS AvgSalary
FROM   Employees
WHERE  IsActive = 1              -- exclude inactive employees first
GROUP BY DeptID;

-- HAVING filters groups after aggregation
SELECT DeptID, AVG(Salary) AS AvgSalary
FROM   Employees
WHERE  IsActive = 1
GROUP BY DeptID
HAVING AVG(Salary) > 60000;     -- only departments with avg salary above 60k

-- Both together
SELECT DeptID, COUNT(*) AS HeadCount, SUM(Salary) AS TotalSalary
FROM   Employees
WHERE  HireDate >= '2020-01-01'  -- rows filter
GROUP BY DeptID
HAVING COUNT(*) >= 5;            -- groups filter
```

<div align="right">
    <b><a href="#">↥ back to top</a></b>
</div>

## Q. What are aggregate functions in SQL Server?

Aggregate functions perform a calculation on a set of values and return a single scalar result. They ignore `NULL` values (except `COUNT(*)`).

| Function | Description |
|---|---|
| `COUNT(*)` | Total rows (including NULLs) |
| `COUNT(col)` | Non-NULL values in column |
| `COUNT(DISTINCT col)` | Distinct non-NULL values |
| `SUM(col)` | Total of numeric column |
| `AVG(col)` | Mean (NULLs excluded from count and sum) |
| `MIN(col)` | Smallest value |
| `MAX(col)` | Largest value |
| `STDEV(col)` | Sample standard deviation |
| `VAR(col)` | Sample variance |
| `STRING_AGG(col, sep)` | Concatenate strings with separator (SQL Server 2017+) |

```sql
SELECT
    DeptID,
    COUNT(*)                    AS TotalEmployees,
    COUNT(ManagerID)            AS HasManager,
    COUNT(DISTINCT JobTitle)    AS UniqueRoles,
    SUM(Salary)                 AS TotalPayroll,
    AVG(Salary)                 AS AvgSalary,
    MIN(Salary)                 AS MinSalary,
    MAX(Salary)                 AS MaxSalary,
    STDEV(Salary)               AS SalaryStdDev,
    STRING_AGG(Name, ', ')
        WITHIN GROUP (ORDER BY Name) AS EmployeeList
FROM   Employees
GROUP BY DeptID
ORDER BY TotalPayroll DESC;
```

<div align="right">
    <b><a href="#">↥ back to top</a></b>
</div>

## Q. What are window functions in SQL Server?

**Window functions** perform calculations across a set of rows related to the current row (the "window") without collapsing rows into a single output row — unlike aggregate functions with `GROUP BY`.

**Syntax:**

```sql
function_name() OVER (
    [PARTITION BY partition_columns]
    [ORDER BY order_columns]
    [ROWS | RANGE BETWEEN frame_start AND frame_end]
)
```

**Categories:**

| Category | Functions |
|---|---|
| Ranking | `ROW_NUMBER()`, `RANK()`, `DENSE_RANK()`, `NTILE(n)` |
| Offset | `LAG()`, `LEAD()`, `FIRST_VALUE()`, `LAST_VALUE()` |
| Aggregate | `SUM()`, `AVG()`, `COUNT()`, `MIN()`, `MAX()` over a window |
| Statistical | `PERCENT_RANK()`, `CUME_DIST()`, `PERCENTILE_CONT()`, `PERCENTILE_DISC()` |

```sql
SELECT
    Name,
    DeptID,
    Salary,
    -- Ranking within each department
    ROW_NUMBER()  OVER (PARTITION BY DeptID ORDER BY Salary DESC) AS RowNum,
    RANK()        OVER (PARTITION BY DeptID ORDER BY Salary DESC) AS Rnk,
    DENSE_RANK()  OVER (PARTITION BY DeptID ORDER BY Salary DESC) AS DenseRnk,
    -- Running total of salary within dept, ordered by salary desc
    SUM(Salary)   OVER (PARTITION BY DeptID ORDER BY Salary DESC
                        ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) AS RunningTotal,
    -- Compare to previous/next employee salary in dept
    LAG(Salary, 1)  OVER (PARTITION BY DeptID ORDER BY Salary DESC) AS PrevSalary,
    LEAD(Salary, 1) OVER (PARTITION BY DeptID ORDER BY Salary DESC) AS NextSalary
FROM Employees;
```

<div align="right">
    <b><a href="#">↥ back to top</a></b>
</div>

## Q. What is the difference between ROW_NUMBER(), RANK(), and DENSE_RANK()?

All three assign a number to rows within a window, but they differ when **ties** occur:

| Function | Behaviour on tie | Gaps after tie? |
|---|---|---|
| `ROW_NUMBER()` | Arbitrary unique number per row | No gaps (always sequential) |
| `RANK()` | Same rank for tied rows | **Yes** — skips rank numbers |
| `DENSE_RANK()` | Same rank for tied rows | **No** — next rank is always +1 |

```sql
-- Salaries: 90000, 85000, 85000, 75000
SELECT
    Name,
    Salary,
    ROW_NUMBER() OVER (ORDER BY Salary DESC) AS RowNum,
    -- Result: 1, 2, 3, 4  (no ties, always unique)

    RANK()       OVER (ORDER BY Salary DESC) AS Rnk,
    -- Result: 1, 2, 2, 4  (85000 tied at 2; rank 3 is skipped)

    DENSE_RANK() OVER (ORDER BY Salary DESC) AS DenseRnk
    -- Result: 1, 2, 2, 3  (85000 tied at 2; next rank is 3, no gap)
FROM Employees;

-- Common use: top N per group using DENSE_RANK (handles ties fairly)
WITH Ranked AS (
    SELECT Name, DeptID, Salary,
           DENSE_RANK() OVER (PARTITION BY DeptID ORDER BY Salary DESC) AS dr
    FROM   Employees
)
SELECT Name, DeptID, Salary
FROM   Ranked
WHERE  dr <= 3;   -- top 3 salaries per department
```

<div align="right">
    <b><a href="#">↥ back to top</a></b>
</div>

## Q. What is the difference between PARTITION BY and GROUP BY?

| Feature | `GROUP BY` | `PARTITION BY` (in window function) |
|---|---|---|
| Output rows | One row per group | Same number of rows as input |
| Non-aggregate columns | Must be in `GROUP BY` | All columns available |
| Aggregate result | Collapses to single value | Available alongside each row |
| Use with `OVER()` | No | Yes — only inside window functions |

```sql
-- GROUP BY collapses rows — one summary row per department
SELECT DeptID, AVG(Salary) AS DeptAvg
FROM   Employees
GROUP BY DeptID;

-- PARTITION BY keeps all rows and adds the dept average alongside each employee
SELECT
    Name,
    DeptID,
    Salary,
    AVG(Salary) OVER (PARTITION BY DeptID) AS DeptAvg,
    Salary - AVG(Salary) OVER (PARTITION BY DeptID) AS DiffFromAvg
FROM Employees;
```

<div align="right">
    <b><a href="#">↥ back to top</a></b>
</div>

## Q. What are LAG() and LEAD() functions?

`LAG()` and `LEAD()` are offset window functions that access a value from a **previous** or **following** row within the same window — without a self-join.

**Syntax:**

```sql
LAG  (expression [, offset [, default]]) OVER (... ORDER BY ...)
LEAD (expression [, offset [, default]]) OVER (... ORDER BY ...)
```

- `offset` — how many rows back (LAG) or forward (LEAD); default is 1
- `default` — value to return when offset goes out of bounds (default is NULL)

```sql
-- Month-over-month sales comparison
SELECT
    SaleMonth,
    TotalSales,
    LAG(TotalSales, 1, 0) OVER (ORDER BY SaleMonth) AS PrevMonthSales,
    TotalSales - LAG(TotalSales, 1, 0) OVER (ORDER BY SaleMonth) AS MoMChange,
    ROUND(
        100.0 * (TotalSales - LAG(TotalSales, 1) OVER (ORDER BY SaleMonth))
              / NULLIF(LAG(TotalSales, 1) OVER (ORDER BY SaleMonth), 0),
        2
    ) AS MoMPct
FROM MonthlySales
ORDER BY SaleMonth;

-- Detect session gaps: flag rows where time since last event exceeds 30 minutes
SELECT
    UserID,
    EventTime,
    LAG(EventTime) OVER (PARTITION BY UserID ORDER BY EventTime) AS PrevEventTime,
    DATEDIFF(MINUTE,
        LAG(EventTime) OVER (PARTITION BY UserID ORDER BY EventTime),
        EventTime
    ) AS MinutesSinceLast
FROM UserEvents;
```

<div align="right">
    <b><a href="#">↥ back to top</a></b>
</div>

## Q. How do you calculate a running total and moving average using window functions?

```sql
-- Sample: DailySales (SaleDate DATE, Amount DECIMAL(12,2))

SELECT
    SaleDate,
    Amount,

    -- Running total (cumulative sum from first row to current row)
    SUM(Amount) OVER (ORDER BY SaleDate
                      ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) AS RunningTotal,

    -- 7-day moving average (current row + 6 preceding rows)
    AVG(Amount) OVER (ORDER BY SaleDate
                      ROWS BETWEEN 6 PRECEDING AND CURRENT ROW)          AS MovingAvg7Day,

    -- Cumulative % of grand total
    ROUND(
        100.0 * SUM(Amount) OVER (ORDER BY SaleDate ROWS UNBOUNDED PRECEDING)
              / SUM(Amount) OVER (),
        2
    ) AS CumulativePct

FROM DailySales
ORDER BY SaleDate;
```

**Frame clause quick reference:**

| Frame | Meaning |
|---|---|
| `ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW` | All rows from start to current (running total) |
| `ROWS BETWEEN N PRECEDING AND CURRENT ROW` | Current + N prior rows (moving window) |
| `ROWS BETWEEN CURRENT ROW AND UNBOUNDED FOLLOWING` | Current row to end |
| `ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING` | Entire partition (same as omitting frame) |

<div align="right">
    <b><a href="#">↥ back to top</a></b>
</div>

---

## Indexes & Performance Tuning

## Q. What is the difference between a clustered and a non-clustered index?

| Feature | Clustered Index | Non-Clustered Index |
|---|---|---|
| Physical order | Rows physically stored in index key order | Separate B-tree; row locator points to heap or clustered index |
| Count per table | **One** | Up to 999 |
| Leaf level | Actual data rows | Index key + row locator (RID or clustering key) |
| Range scans | Very efficient | May need key lookups |
| Default on PK | Yes (unless specified otherwise) | — |

```sql
-- Clustered index: typically the primary key
CREATE TABLE Orders (
    OrderID   INT          NOT NULL,
    OrderDate DATE         NOT NULL,
    CustomerID INT         NOT NULL,
    Amount    DECIMAL(10,2),
    CONSTRAINT PK_Orders PRIMARY KEY CLUSTERED (OrderID)
);

-- Non-clustered index for a frequently filtered column
CREATE NONCLUSTERED INDEX IX_Orders_CustomerID
ON Orders (CustomerID)
INCLUDE (OrderDate, Amount);   -- covering: avoids key lookup for these columns
```

<div align="right">
    <b><a href="#">↥ back to top</a></b>
</div>

## Q. What is a covering index and how does it eliminate key lookups?

A **covering index** includes all columns referenced by a query (in the key or `INCLUDE` list) so the optimizer can satisfy the query entirely from the index without reading the clustered index (a **key lookup**).

```sql
-- Query: get OrderDate and Amount for a specific customer
SELECT OrderDate, Amount
FROM   Orders
WHERE  CustomerID = 42;

-- Without covering index: IX on CustomerID alone forces a key lookup
-- for OrderDate and Amount → can be slow on large tables.

-- With covering index: OrderDate and Amount in INCLUDE → no key lookup needed
CREATE NONCLUSTERED INDEX IX_Orders_CustomerID_Covering
ON Orders (CustomerID)
INCLUDE (OrderDate, Amount);

-- Verify in execution plan: look for "Index Seek" with no "Key Lookup" operator
-- Check missing index DMV for suggestions
SELECT TOP 10
    mid.statement                        AS TableName,
    migs.avg_user_impact                 AS AvgImpact,
    migs.user_seeks + migs.user_scans    AS TotalUsage,
    mid.equality_columns,
    mid.inequality_columns,
    mid.included_columns
FROM   sys.dm_db_missing_index_details  mid
JOIN   sys.dm_db_missing_index_groups   mig  ON mid.index_handle = mig.index_handle
JOIN   sys.dm_db_missing_index_group_stats migs ON mig.index_group_handle = migs.group_handle
ORDER BY migs.avg_user_impact DESC;
```

<div align="right">
    <b><a href="#">↥ back to top</a></b>
</div>

## Q. What is index fragmentation and how do you fix it?

**Index fragmentation** occurs when data pages in an index are logically or physically out of order due to INSERT/UPDATE/DELETE operations. It causes excessive I/O during range scans.

| Type | Description | Impact |
|---|---|---|
| **Logical fragmentation** | Page logical order differs from physical order | Causes extra I/O for ordered scans |
| **Page density / internal fragmentation** | Pages are partially empty | Wastes memory and disk |

**Checking fragmentation:**

```sql
SELECT
    OBJECT_NAME(ips.object_id)  AS TableName,
    i.name                      AS IndexName,
    ips.avg_fragmentation_in_percent,
    ips.page_count
FROM   sys.dm_db_index_physical_stats(
           DB_ID(), NULL, NULL, NULL, 'LIMITED') ips
JOIN   sys.indexes i ON ips.object_id = i.object_id
                    AND ips.index_id  = i.index_id
WHERE  ips.avg_fragmentation_in_percent > 5
ORDER BY ips.avg_fragmentation_in_percent DESC;
```

**Fixing fragmentation:**

```sql
-- < 30% fragmentation: REORGANIZE (online, low resource)
ALTER INDEX IX_Orders_CustomerID ON Orders REORGANIZE;

-- >= 30% fragmentation: REBUILD (offline by default; online with Enterprise)
ALTER INDEX IX_Orders_CustomerID ON Orders REBUILD;

-- Rebuild online (Enterprise edition — no blocking)
ALTER INDEX IX_Orders_CustomerID ON Orders
REBUILD WITH (ONLINE = ON, SORT_IN_TEMPDB = ON);

-- Rebuild all indexes on a table
ALTER INDEX ALL ON Orders REBUILD;
```

**General guideline:** REORGANIZE for 5–30% fragmentation; REBUILD for > 30%.

<div align="right">
    <b><a href="#">↥ back to top</a></b>
</div>

## Q. What is the difference between an index seek and an index scan?

| Operation | Description | Cost |
|---|---|---|
| **Index Seek** | Navigator jumps directly to matching rows using the B-tree | Low — reads only needed pages |
| **Index Scan** | Reads every row in the index from start to end | High — proportional to index size |
| **Clustered Index Scan** | Full table scan via the clustered index | Highest — reads all data pages |

**What causes a scan instead of a seek?**
- Non-SARGable predicates (function applied to indexed column)
- Low selectivity (optimizer decides a scan is cheaper)
- Missing index on filtered column
- Implicit data type conversion

```sql
-- Non-SARGable: forces index SCAN (function wraps the column)
SELECT * FROM Orders WHERE YEAR(OrderDate) = 2024;

-- SARGable: enables index SEEK (range on the column itself)
SELECT * FROM Orders
WHERE  OrderDate >= '2024-01-01' AND OrderDate < '2025-01-01';

-- Non-SARGable: implicit conversion when column is VARCHAR but param is INT
-- (forces SCAN on a VARCHAR index)
SELECT * FROM Products WHERE ProductCode = 12345;   -- ProductCode is VARCHAR

-- Fixed: explicit cast of the literal, not the column
SELECT * FROM Products WHERE ProductCode = '12345';
```

<div align="right">
    <b><a href="#">↥ back to top</a></b>
</div>

## Q. What are filtered indexes and when should you use them?

A **filtered index** is a non-clustered index with a `WHERE` clause. It indexes only a subset of rows, making it smaller, cheaper to maintain, and more selective than a full-column index.

**Ideal for:**
- Sparse columns (mostly NULL)
- Soft-delete patterns (`IsDeleted = 0`)
- Status enumerations where queries almost always filter on one value

```sql
-- Index only active orders (IsActive = 1 filters out ~90% of rows)
CREATE NONCLUSTERED INDEX IX_Orders_Active
ON Orders (CustomerID, OrderDate)
INCLUDE (Amount)
WHERE  IsActive = 1;

-- Filtered unique index: enforce uniqueness only for non-NULL values
-- (multiple NULLs allowed; only one non-NULL value permitted per email)
CREATE UNIQUE NONCLUSTERED INDEX UIX_Customers_Email
ON Customers (Email)
WHERE  Email IS NOT NULL;

-- The query MUST include the filter predicate for the optimizer to use it
SELECT CustomerID, OrderDate, Amount
FROM   Orders
WHERE  CustomerID = 42
AND    IsActive   = 1;    -- matches filter → optimizer can use IX_Orders_Active
```

<div align="right">
    <b><a href="#">↥ back to top</a></b>
</div>

## Q. What is a columnstore index and when should you use it?

A **columnstore index** stores data by column rather than by row, enabling exceptional compression and batch-mode execution for analytical (OLAP) workloads. SQL Server 2022+ supports updatable clustered columnstore indexes and is fully supported in SQL Server 2025.

| Feature | Rowstore (B-tree) | Columnstore |
|---|---|---|
| Storage | Row-by-row | Column-by-column (compressed segments) |
| Best for | OLTP (point lookups, small inserts/updates) | OLAP (aggregations over millions of rows) |
| Compression | Page/row compression | ColumnStore + ColumnStore Archive compression |
| Execution mode | Row mode | Batch mode (processes 900 rows at a time) |
| Updatable | Always | Yes (clustered CCI with delta store) |

```sql
-- Non-clustered columnstore: add analytics to an existing OLTP table
CREATE NONCLUSTERED COLUMNSTORE INDEX NCCI_Sales_Analytics
ON Sales (SaleDate, ProductID, RegionID, Amount, Quantity);

-- Clustered columnstore: ideal for a dedicated fact/aggregation table
CREATE CLUSTERED COLUMNSTORE INDEX CCI_FactSales
ON FactSales;

-- Typical query that benefits: aggregation over millions of rows
SELECT
    ProductID,
    YEAR(SaleDate)  AS SaleYear,
    SUM(Amount)     AS TotalRevenue,
    COUNT(*)        AS TransactionCount
FROM   FactSales
WHERE  SaleDate >= '2023-01-01'
GROUP BY ProductID, YEAR(SaleDate)
ORDER BY TotalRevenue DESC;
```

<div align="right">
    <b><a href="#">↥ back to top</a></b>
</div>

## Q. What is SARGability and why does it matter for index performance?

**SARGable** (Search ARGument ABLE) means a predicate is written in a form that allows the query engine to use an index seek. A predicate is non-SARGable when the indexed column is wrapped in a function or expression — forcing a full scan.

```sql
-- NON-SARGable examples (force index scan)
WHERE YEAR(OrderDate) = 2024               -- function on column
WHERE UPPER(LastName) = 'SMITH'            -- function on column
WHERE Salary * 1.1 > 60000                -- expression on column
WHERE CONVERT(VARCHAR, OrderID) = '1001'  -- implicit/explicit conversion
WHERE ISNULL(Status, 'X') = 'Active'      -- function on column

-- SARGable equivalents (enable index seek)
WHERE OrderDate >= '2024-01-01' AND OrderDate < '2025-01-01'
WHERE LastName = 'Smith'           -- use a case-insensitive collation instead
WHERE Salary > 60000 / 1.1        -- move math to the literal side
WHERE OrderID = 1001               -- use correct data type
WHERE Status = 'Active'            -- handle NULLs separately if needed

-- Add a persisted computed column + index if you must query by YEAR()
ALTER TABLE Orders ADD SaleYear AS YEAR(OrderDate) PERSISTED;
CREATE INDEX IX_Orders_SaleYear ON Orders (SaleYear);
SELECT * FROM Orders WHERE SaleYear = 2024;   -- now SARGable
```

<div align="right">
    <b><a href="#">↥ back to top</a></b>
</div>

## Q. What is parameter sniffing in SQL Server?

**Parameter sniffing** is the behaviour where SQL Server generates an execution plan the first time a stored procedure or parameterised query runs based on the **initial parameter values**, then **caches and reuses** that plan for all subsequent calls — even if later parameter values would benefit from a different plan.

**Problem scenario:**
```sql
-- First call: @CustomerID = 1 (VIP with 50,000 orders → table scan is optimal)
-- Plan is cached with table scan strategy.
-- Second call: @CustomerID = 999 (regular with 2 orders → index seek is optimal)
-- Cached table-scan plan is reused → very slow for customer 999.

CREATE PROCEDURE usp_GetOrders
    @CustomerID INT
AS
BEGIN
    SELECT * FROM Orders WHERE CustomerID = @CustomerID;
END;
```

**Solutions:**

```sql
-- Option 1: OPTIMIZE FOR UNKNOWN — compile with average statistics
CREATE PROCEDURE usp_GetOrders
    @CustomerID INT
AS
BEGIN
    SELECT * FROM Orders WHERE CustomerID = @CustomerID
    OPTION (OPTIMIZE FOR (@CustomerID UNKNOWN));
END;

-- Option 2: RECOMPILE — generate fresh plan on every execution (CPU cost)
CREATE PROCEDURE usp_GetOrders
    @CustomerID INT
AS
BEGIN
    SELECT * FROM Orders WHERE CustomerID = @CustomerID
    OPTION (RECOMPILE);
END;

-- Option 3: local variable (breaks sniffing; plan uses average density)
CREATE PROCEDURE usp_GetOrders
    @CustomerID INT
AS
BEGIN
    DECLARE @LocalID INT = @CustomerID;
    SELECT * FROM Orders WHERE CustomerID = @LocalID;
END;

-- Option 4 (SQL Server 2022+): Automatic Parameter Sensitive Plan (PSP) optimization
-- Enabled by default under compatibility level 160+; no code change needed.
-- SQL Server automatically caches multiple plans for the same query.
ALTER DATABASE MyDB SET COMPATIBILITY_LEVEL = 160;
```

<div align="right">
    <b><a href="#">↥ back to top</a></b>
</div>

## Q. How do you identify and resolve slow queries in SQL Server?

**Step 1 — Find expensive queries via DMVs:**

```sql
-- Top 10 queries by total CPU time
SELECT TOP 10
    qs.total_worker_time / qs.execution_count  AS AvgCPU_µs,
    qs.total_elapsed_time / qs.execution_count AS AvgDuration_µs,
    qs.execution_count,
    qs.total_logical_reads / qs.execution_count AS AvgLogicalReads,
    SUBSTRING(st.text, (qs.statement_start_offset / 2) + 1,
        ((CASE qs.statement_end_offset
              WHEN -1 THEN DATALENGTH(st.text)
              ELSE qs.statement_end_offset END
          - qs.statement_start_offset) / 2) + 1) AS QueryText,
    qp.query_plan                              AS ExecutionPlan
FROM   sys.dm_exec_query_stats qs
CROSS APPLY sys.dm_exec_sql_text(qs.sql_handle)  st
CROSS APPLY sys.dm_exec_query_plan(qs.plan_handle) qp
ORDER BY qs.total_worker_time DESC;
```

**Step 2 — Check for missing indexes:**

```sql
SELECT TOP 10
    ROUND(migs.avg_user_impact, 2)               AS AvgImpact,
    migs.user_seeks,
    mid.equality_columns,
    mid.inequality_columns,
    mid.included_columns,
    mid.statement                                AS TableName
FROM   sys.dm_db_missing_index_group_stats migs
JOIN   sys.dm_db_missing_index_groups      mig  ON migs.group_handle = mig.index_group_handle
JOIN   sys.dm_db_missing_index_details     mid  ON mig.index_handle  = mid.index_handle
ORDER BY migs.avg_user_impact DESC;
```

**Step 3 — Common fixes checklist:**

| Issue | Fix |
|---|---|
| Index scan instead of seek | Make predicate SARGable; add/cover index |
| Key lookups | Add `INCLUDE` columns to existing index |
| Table spools / sorting | Add index on `ORDER BY` / `GROUP BY` columns |
| High logical reads | Covering index; update statistics (`UPDATE STATISTICS`) |
| Blocking / waits | Check `sys.dm_exec_requests`; reduce transaction scope |
| Outdated statistics | `UPDATE STATISTICS table_name WITH FULLSCAN` |
| Parameter sniffing | `OPTION (RECOMPILE)` or `OPTIMIZE FOR UNKNOWN` |
| Excessive recompilation | Remove DDL inside procedures; use temp table carefully |

```sql
-- Update statistics for a specific table
UPDATE STATISTICS Orders WITH FULLSCAN;

-- Update all statistics in the database
EXEC sp_updatestats;

-- Check wait statistics to find the dominant bottleneck type
SELECT TOP 10
    wait_type,
    wait_time_ms / 1000.0       AS WaitSec,
    waiting_tasks_count
FROM   sys.dm_os_wait_stats
WHERE  wait_type NOT IN (
    'SLEEP_TASK','BROKER_TO_FLUSH','BROKER_EVENTHANDLER',
    'REQUEST_FOR_DEADLOCK_SEARCH','XE_TIMER_EVENT','SQLTRACE_INCREMENTAL_FLUSH_SLEEP'
)
ORDER BY wait_time_ms DESC;
```

<div align="right">
    <b><a href="#">↥ back to top</a></b>
</div>
