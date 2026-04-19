# MSSQL-Server 2025 Scenario-Based MCQ

> Scenario-based multiple choice questions covering core Microsoft SQL Server 2025 topics.

<br>

## Table of Contents

1. [T-SQL Queries & Filtering](#1-t-sql-queries--filtering)
2. [Joins & Subqueries](#2-joins--subqueries)
3. [Indexes & Performance](#3-indexes--performance)
4. [Stored Procedures & Functions](#4-stored-procedures--functions)
5. [Transactions & Concurrency](#5-transactions--concurrency)
6. [Views & CTEs](#6-views--ctes)
7. [Window Functions](#7-window-functions)
8. [JSON & XML Support](#8-json--xml-support)
9. [Security & Permissions](#9-security--permissions)
10. [Database Design & Normalization](#10-database-design--normalization)
11. [Backup & Recovery](#11-backup--recovery)
12. [Query Optimization & Execution Plans](#12-query-optimization--execution-plans)
13. [Temporal Tables & Change Tracking](#13-temporal-tables--change-tracking)
14. [Partitioning & Columnstore Indexes](#14-partitioning--columnstore-indexes)
15. [New Features in SQL Server 2025](#15-new-features-in-sql-server-2025)

<br>

## 1. T-SQL Queries & Filtering

**Q.** A developer runs the following query against a `Products` table that has 500 rows. The `Price` column is of type `DECIMAL(10,2)` and is NOT NULL. What does the query return?

```sql
SELECT COUNT(*) FROM Products WHERE Price != Price;
```

- A) 500 — it counts all rows because every value is not equal to itself due to floating-point precision.
- B) 0 — no row satisfies `Price != Price` because a value always equals itself.
- C) NULL — comparing a column to itself returns NULL.
- D) An error — you cannot compare a column to itself.

> **Answer: B**  
> For any deterministic non-NULL value, `Price != Price` is always `FALSE`. SQL evaluates the predicate row by row, and since `DECIMAL` values are exact (not floating-point), no precision issue arises. The result is 0. If the column were nullable and contained NULLs, those rows would also be excluded because any comparison with NULL yields UNKNOWN.

<div align="right">
    <b><a href="#table-of-contents">↥ back to top</a></b>
</div>

**Q.** A reporting team needs all customers whose last name starts with "Mc" or "Mac" and whose city is either "Dublin" or "Edinburgh". Which WHERE clause is most correct and efficient?

- A) `WHERE LastName LIKE 'Mc%' OR LastName LIKE 'Mac%' AND City IN ('Dublin', 'Edinburgh')`
- B) `WHERE (LastName LIKE 'Mc%' OR LastName LIKE 'Mac%') AND City IN ('Dublin', 'Edinburgh')`
- C) `WHERE LastName IN ('Mc%', 'Mac%') AND City IN ('Dublin', 'Edinburgh')`
- D) `WHERE LastName LIKE 'M[ac]%' AND City IN ('Dublin', 'Edinburgh')`

> **Answer: B**  
> `AND` has higher precedence than `OR`, so option A would be parsed as `LastName LIKE 'Mc%' OR (LastName LIKE 'Mac%' AND City IN (...))`, returning incorrect results. Option B uses parentheses to correctly group the OR condition first. Option C is invalid — `IN` does not accept wildcards. Option D\'s pattern `M[ac]%` matches "Ma..." or "Mc..." but misses "Mac..." prefixes of length > 2 incorrectly (it would match "Macintosh" but the intent is clearer with B).

<div align="right">
    <b><a href="#table-of-contents">↥ back to top</a></b>
</div>

**Q.** An analyst queries an `Orders` table with `TOP` and `ORDER BY`. The table has no clustered index. What does the following return?

```sql
SELECT TOP 5 OrderID, Amount FROM Orders;
```

- A) The 5 orders with the smallest `OrderID` values.
- B) The 5 orders with the largest `Amount` values.
- C) An arbitrary set of 5 rows — the order is undefined without `ORDER BY`.
- D) An error — `TOP` requires `ORDER BY`.

> **Answer: C**  
> Without `ORDER BY`, SQL Server makes no guarantee about which rows are returned by `TOP`. The engine may return any 5 rows depending on the physical storage order, parallel execution plan, or buffer state. `TOP` without `ORDER BY` is non-deterministic.

<div align="right">
    <b><a href="#table-of-contents">↥ back to top</a></b>
</div>

**Q.** You need to retrieve all employees hired in Q1 (January–March) of any year from an `Employees` table with a `HireDate DATE` column. Which query correctly and efficiently filters those rows?

- A) `WHERE YEAR(HireDate) IN (1,2,3)`
- B) `WHERE MONTH(HireDate) IN (1, 2, 3)`
- C) `WHERE HireDate LIKE '%-01%' OR HireDate LIKE '%-02%' OR HireDate LIKE '%-03%'`
- D) `WHERE HireDate BETWEEN '2000-01-01' AND '2000-03-31'`

> **Answer: B**  
> `MONTH(HireDate) IN (1, 2, 3)` correctly extracts the month component from any year and filters January, February, and March. Option A incorrectly filters `YEAR` values 1–3 AD. Option C applies string pattern matching to a `DATE` type, which is unreliable. Option D limits results to a single year.

<div align="right">
    <b><a href="#table-of-contents">↥ back to top</a></b>
</div>

**Q.** A DBA writes the following query. The `Salary` column allows NULL values. What is the result?

```sql
SELECT * FROM Employees WHERE Salary NOT IN (50000, 60000, NULL);
```

- A) All employees whose salary is not 50000 or 60000, including those with NULL salary.
- B) All employees whose salary is not 50000 or 60000, excluding those with NULL salary.
- C) No rows — the NULL in the IN list causes the entire result to be empty.
- D) An error — NULL is not allowed inside an IN list.

> **Answer: C**  
> When `NULL` appears in the list of a `NOT IN`, the comparison `Salary NOT IN (..., NULL)` internally evaluates `Salary <> NULL` for each row, which yields UNKNOWN. Because UNKNOWN is not TRUE, no rows pass the filter. This is a classic NULL trap in T-SQL. The fix is to remove NULL from the list or use `NOT EXISTS`.

<div align="right">
    <b><a href="#table-of-contents">↥ back to top</a></b>
</div>

---

## 2. Joins & Subqueries

**Q.** A developer writes the following query to find all customers who have never placed an order:

```sql
SELECT c.CustomerID
FROM Customers c
LEFT JOIN Orders o ON c.CustomerID = o.CustomerID
WHERE o.CustomerID = NULL;
```

The query returns 0 rows even though unmatched customers exist. What is wrong?

- A) `LEFT JOIN` should be `RIGHT JOIN` to find unmatched rows.
- B) The `WHERE` clause should use `IS NULL` instead of `= NULL`.
- C) The join condition should use `<>` instead of `=`.
- D) `CustomerID` cannot be used in both the join and the WHERE clause.

> **Answer: B**  
> NULL is never equal to anything, including NULL itself. The comparison `o.CustomerID = NULL` always evaluates to UNKNOWN, so no rows satisfy the WHERE clause. The correct predicate is `WHERE o.CustomerID IS NULL`, which captures left-join rows where no matching order was found.

<div align="right">
    <b><a href="#table-of-contents">↥ back to top</a></b>
</div>

**Q.** You have a `Sales` table and a `Products` table joined on `ProductID`. A product can appear in multiple sales. A CROSS JOIN is accidentally written. The `Sales` table has 1,000 rows and `Products` has 200 rows. How many rows does a CROSS JOIN produce?

- A) 1,000
- B) 200
- C) 1,200
- D) 200,000

> **Answer: D**  
> A CROSS JOIN produces a Cartesian product — every row in the first table combined with every row in the second table. 1,000 × 200 = 200,000 rows.

<div align="right">
    <b><a href="#table-of-contents">↥ back to top</a></b>
</div>

**Q.** An analyst needs to list every department and the count of employees in each department, including departments that currently have no employees. Which query achieves this?

- A) `SELECT d.DeptName, COUNT(e.EmpID) FROM Departments d INNER JOIN Employees e ON d.DeptID = e.DeptID GROUP BY d.DeptName`
- B) `SELECT d.DeptName, COUNT(e.EmpID) FROM Departments d LEFT JOIN Employees e ON d.DeptID = e.DeptID GROUP BY d.DeptName`
- C) `SELECT d.DeptName, COUNT(*) FROM Departments d LEFT JOIN Employees e ON d.DeptID = e.DeptID GROUP BY d.DeptName`
- D) `SELECT d.DeptName, COUNT(e.EmpID) FROM Employees e RIGHT JOIN Departments d ON d.DeptID = e.DeptID GROUP BY e.DeptID`

> **Answer: B**  
> A `LEFT JOIN` keeps all department rows, placing NULL for employee columns when no match exists. `COUNT(e.EmpID)` correctly returns 0 for those departments (COUNT ignores NULLs). Option A uses INNER JOIN, dropping departments with no employees. Option C uses `COUNT(*)` which would count the NULL row as 1. Option D groups by `e.DeptID` which is NULL for unmatched rows, causing incorrect grouping.

<div align="right">
    <b><a href="#table-of-contents">↥ back to top</a></b>
</div>

**Q.** A developer replaces a correlated subquery with a `JOIN` for performance reasons. Which pair of queries are logically equivalent when `OrderID` is unique in the `Orders` table?

- A) `SELECT * FROM Customers WHERE CustomerID IN (SELECT CustomerID FROM Orders)` and `SELECT DISTINCT c.* FROM Customers c JOIN Orders o ON c.CustomerID = o.CustomerID`
- B) `SELECT * FROM Customers WHERE CustomerID IN (SELECT CustomerID FROM Orders)` and `SELECT c.* FROM Customers c JOIN Orders o ON c.CustomerID = o.CustomerID`
- C) `SELECT * FROM Customers WHERE EXISTS (SELECT 1 FROM Orders o WHERE o.CustomerID = c.CustomerID)` and `SELECT c.* FROM Customers c JOIN Orders o ON c.CustomerID = o.CustomerID`
- D) All of the above are equivalent.

> **Answer: A**  
> Without `DISTINCT`, joining on a one-to-many relationship produces duplicate customer rows (one per order). `IN` and `EXISTS` return each customer at most once. Adding `DISTINCT` to the JOIN makes it logically equivalent to the subquery versions. Option B omits DISTINCT and would produce duplicates.

<div align="right">
    <b><a href="#table-of-contents">↥ back to top</a></b>
</div>

**Q.** You run the following query but it takes 45 seconds on a table with 10 million rows:

```sql
SELECT * FROM Orders o
WHERE o.CustomerID = (SELECT CustomerID FROM Customers WHERE Email = 'test@example.com');
```

The subquery always returns exactly one row. Which change would most likely improve performance?

- A) Replace `=` with `IN`.
- B) Add an index on `Customers.Email` and `Orders.CustomerID`.
- C) Replace the subquery with a CROSS JOIN.
- D) Add `NOLOCK` to the outer query.

> **Answer: B**  
> The bottleneck is likely a table scan on `Customers.Email` (no index) and/or `Orders.CustomerID` (no index). Creating a non-clustered index on `Customers(Email)` speeds up the subquery lookup, and an index on `Orders(CustomerID)` speeds up the outer filter. Option A makes no semantic difference since the subquery returns one row. `NOLOCK` trades consistency for speed and does not address the root cause.

<div align="right">
    <b><a href="#table-of-contents">↥ back to top</a></b>
</div>

---

## 3. Indexes & Performance

**Q.** A table `SalesOrders` has a clustered index on `OrderID`. A DBA adds a non-clustered index on `CustomerID`. What is physically stored in the non-clustered index leaf pages?

- A) The full data rows, duplicating the table storage.
- B) The `CustomerID` values and the clustered key (`OrderID`) as a row locator.
- C) Pointers to the physical disk addresses (RID) of each row.
- D) Only the `CustomerID` values with no row locator.

> **Answer: B**  
> For a table with a clustered index, non-clustered index leaf pages store the index key column(s) and the clustered key value(s) as a row locator. SQL Server uses the clustered key to perform a key lookup when additional columns are needed. A RID (row identifier) is used only when the table is a heap (no clustered index).

<div align="right">
    <b><a href="#table-of-contents">↥ back to top</a></b>
</div>

**Q.** An execution plan shows a "Key Lookup" operator consuming 90% of the query cost. What is the most effective way to eliminate it?

- A) Convert the clustered index to a non-clustered index.
- B) Add the additional columns needed by the query to the non-clustered index as INCLUDE columns.
- C) Replace the WHERE clause predicate with a subquery.
- D) Increase the server\'s max memory setting.

> **Answer: B**  
> A Key Lookup occurs when a non-clustered index satisfies the seek but must fetch additional columns from the base table via the clustered key. Adding those columns as `INCLUDE` columns on the non-clustered index makes it a covering index, eliminating the Key Lookup entirely.

<div align="right">
    <b><a href="#table-of-contents">↥ back to top</a></b>
</div>

**Q.** A developer notices a query on a `Transactions` table is suddenly slow after months of good performance. The table receives heavy INSERT/UPDATE/DELETE activity. Running `sys.dm_db_index_physical_stats` shows `avg_fragmentation_in_percent = 72`. What is the recommended action?

- A) Drop and recreate the table.
- B) Run `ALTER INDEX ... REORGANIZE` because fragmentation is below 30%.
- C) Run `ALTER INDEX ... REBUILD` because fragmentation exceeds 30%.
- D) Add a new clustered index on a different column.

> **Answer: C**  
> Microsoft\'s general guidance: fragmentation 5–30% → REORGANIZE (online, less resource intensive); fragmentation > 30% → REBUILD (more thorough, can be done online with the `ONLINE = ON` option in Enterprise Edition). At 72%, REBUILD is the correct choice.

<div align="right">
    <b><a href="#table-of-contents">↥ back to top</a></b>
</div>

**Q.** A table `Logs` has 50 million rows and a non-clustered index on `EventType`. A query filters on `EventType = 'INFO'`, but 80% of all rows have `EventType = 'INFO'`. The query optimizer chooses a full table scan instead of the index. Why?

- A) The non-clustered index is corrupted and should be rebuilt.
- B) The optimizer estimates that reading the entire table is cheaper than random I/O through a low-selectivity index.
- C) SQL Server does not support non-clustered indexes on VARCHAR columns.
- D) The query is missing an `ORDER BY` clause, so the index is ignored.

> **Answer: B**  
> When an index has low selectivity (80% of rows match), using the index means many key lookups back to the base table — more random I/O than a sequential table scan. The cost-based optimizer correctly chooses the scan. To force the query to use the index you could use a hint, but the optimizer\'s choice is usually correct in this scenario.

<div align="right">
    <b><a href="#table-of-contents">↥ back to top</a></b>
</div>

**Q.** Which index type in SQL Server is best suited for a data warehouse fact table with 500 million rows that is queried with aggregations (SUM, COUNT, AVG) across wide column ranges but rarely updated row by row?

- A) Clustered B-Tree index on the date column.
- B) Non-clustered filtered index on each aggregated column.
- C) Clustered columnstore index.
- D) XML index on the fact column.

> **Answer: C**  
> Columnstore indexes store data column-by-column and use batch execution mode, making them highly efficient for analytical workloads with aggregations over large column ranges. A clustered columnstore index is the standard recommendation for fact tables in data warehouse scenarios in SQL Server 2022/2025.

<div align="right">
    <b><a href="#table-of-contents">↥ back to top</a></b>
</div>

---

## 4. Stored Procedures & Functions

**Q.** A stored procedure updates a customer\'s credit limit and then calls another procedure that logs the change. An error occurs inside the logging procedure. The outer procedure has no TRY/CATCH. What happens?

```sql
CREATE PROCEDURE usp_UpdateCredit (@CustID INT, @NewLimit DECIMAL)
AS
BEGIN
    UPDATE Customers SET CreditLimit = @NewLimit WHERE CustomerID = @CustID;
    EXEC usp_LogChange @CustID, @NewLimit;
END
```

- A) The UPDATE is always rolled back when the inner procedure fails.
- B) By default, the UPDATE is committed; only the inner procedure\'s statements are rolled back.
- C) SQL Server automatically wraps the outer procedure in a transaction and rolls everything back.
- D) The outer procedure terminates but the UPDATE is committed because it completed before the error.

> **Answer: D**  
> Without an explicit transaction, each statement auto-commits. The `UPDATE` completes and commits before `EXEC usp_LogChange` is called. When the inner procedure fails, only that batch\'s changes are affected. To ensure atomicity, both operations should be wrapped in an explicit `BEGIN TRANSACTION / COMMIT / ROLLBACK` with TRY/CATCH.

<div align="right">
    <b><a href="#table-of-contents">↥ back to top</a></b>
</div>

**Q.** A developer creates a scalar user-defined function `dbo.GetDiscount(@Price DECIMAL)` and uses it in a query:

```sql
SELECT ProductID, dbo.GetDiscount(Price) AS Discount FROM Products;
```

The query scans 1 million rows and runs very slowly. A DBA suggests replacing it with an inline table-valued function (iTVF). Why?

- A) Scalar UDFs cannot accept DECIMAL parameters.
- B) Scalar UDFs execute row-by-row and inhibit parallelism; iTVFs are inlined into the query plan and can be parallelized.
- C) Scalar UDFs are deprecated in SQL Server 2025.
- D) The iTVF version requires fewer table scans.

> **Answer: B**  
> Scalar UDFs (pre-2019 behavior) are executed once per row and prevent parallel query plans. SQL Server 2019+ introduced Scalar UDF Inlining, but it has restrictions. Inline TVFs are always expanded (inlined) into the calling query\'s plan, enabling set-based processing and parallelism, which dramatically improves performance at scale.

<div align="right">
    <b><a href="#table-of-contents">↥ back to top</a></b>
</div>

**Q.** A stored procedure uses `RETURN` to send a status code back to the caller. Which statement correctly captures the return value?

- A) `EXEC @status = usp_ProcessOrder @OrderID = 101;`
- B) `SELECT @status = EXEC usp_ProcessOrder @OrderID = 101;`
- C) `DECLARE @status INT; usp_ProcessOrder @OrderID = 101 OUTPUT @status;`
- D) `SET @status = CALL usp_ProcessOrder(101);`

> **Answer: A**  
> The `RETURN` value of a stored procedure is captured by placing a variable before the `EXEC` keyword: `EXEC @status = ProcName ...`. Options B and D use invalid syntax. Option C conflates OUTPUT parameters with RETURN values.

<div align="right">
    <b><a href="#table-of-contents">↥ back to top</a></b>
</div>

**Q.** You need a reusable piece of T-SQL logic that accepts a `CustomerID`, returns a result set of their orders, and can be used directly in a FROM clause with `CROSS APPLY`. Which object type is the correct choice?

- A) Scalar user-defined function.
- B) Stored procedure.
- C) Inline table-valued function.
- D) View.

> **Answer: C**  
> Inline table-valued functions return a table result set and can be used in a FROM clause, including with `CROSS APPLY` or `OUTER APPLY`. Stored procedures cannot be used in a FROM clause. Scalar UDFs return a single value. Views do not accept parameters.

<div align="right">
    <b><a href="#table-of-contents">↥ back to top</a></b>
</div>

**Q.** What is the key difference between `EXEC sp_executesql` and `EXEC` (with a string) when running dynamic SQL?

- A) `sp_executesql` supports parameterized queries, preventing SQL injection and enabling plan reuse; `EXEC` with a string concatenates values into SQL, risking injection and poor plan caching.
- B) `sp_executesql` is slower because it re-compiles the plan on every call.
- C) `EXEC` supports OUTPUT parameters but `sp_executesql` does not.
- D) There is no functional difference; they produce identical execution plans.

> **Answer: A**  
> `sp_executesql` accepts a parameterized query string and separate parameter values, similar to prepared statements. This prevents SQL injection and allows SQL Server to cache and reuse the execution plan. Concatenating user input into an `EXEC` string is a security vulnerability (SQL injection) and prevents plan reuse due to varying query text.

<div align="right">
    <b><a href="#table-of-contents">↥ back to top</a></b>
</div>

---

## 5. Transactions & Concurrency

**Q.** Session A begins a transaction and updates a row in `Accounts`. Session B then tries to `SELECT` the same row with the default isolation level. What happens in SQL Server?

- A) Session B reads the uncommitted data (dirty read) immediately.
- B) Session B is blocked until Session A commits or rolls back.
- C) Session B receives an error saying the row is locked.
- D) Session B reads the last committed version of the row from the version store.

> **Answer: B**  
> The default isolation level in SQL Server is `READ COMMITTED`. Under this level, a `SELECT` acquires shared locks and is blocked by an exclusive lock held by an uncommitted UPDATE. Session B waits until Session A\'s transaction ends. (If `READ_COMMITTED_SNAPSHOT` is enabled at the database level, option D would be correct instead.)

<div align="right">
    <b><a href="#table-of-contents">↥ back to top</a></b>
</div>

**Q.** Session A reads row X (shared lock), then reads row Y. Session B reads row Y (shared lock), then tries to update row X. Both sessions are now waiting for each other. What is this situation called, and how does SQL Server resolve it?

- A) Livelock — SQL Server retries indefinitely.
- B) Deadlock — SQL Server\'s deadlock monitor selects one session as the victim and rolls back its transaction.
- C) Blocking — the DBA must manually kill one session.
- D) Race condition — SQL Server uses a queue to serialize the sessions.

> **Answer: B**  
> This is a classic deadlock: two sessions each hold a lock the other needs. SQL Server\'s background deadlock monitor detects the cycle and chooses a victim (typically the session with the least rollback cost), rolls back its transaction, and raises error 1205 to that session.

<div align="right">
    <b><a href="#table-of-contents">↥ back to top</a></b>
</div>

**Q.** A developer writes the following and wants to ensure both operations succeed or both fail:

```sql
BEGIN TRANSACTION;
    INSERT INTO Orders (CustomerID, Total) VALUES (5, 250.00);
    INSERT INTO OrderItems (OrderID, ProductID, Qty) VALUES (SCOPE_IDENTITY(), 12, 3);
COMMIT;
```

An error occurs on the second INSERT (e.g., a foreign key violation). What happens to the first INSERT?

- A) The first INSERT is committed because it completed successfully before the error.
- B) The whole transaction is automatically rolled back by SQL Server.
- C) The first INSERT remains uncommitted until the session ends.
- D) The first INSERT is rolled back only if the developer adds a ROLLBACK statement inside a CATCH block.

> **Answer: D**  
> SQL Server does not automatically roll back a transaction on a non-fatal error (like a constraint violation) unless `XACT_ABORT` is ON or the error is fatal. Without `TRY/CATCH` and explicit `ROLLBACK`, the first INSERT stays in an open transaction after the second fails. The correct pattern is to wrap the block in `BEGIN TRY / BEGIN CATCH / ROLLBACK / END CATCH`.

<div align="right">
    <b><a href="#table-of-contents">↥ back to top</a></b>
</div>

**Q.** A developer sets `SET TRANSACTION ISOLATION LEVEL SERIALIZABLE` before a SELECT. What additional guarantee does this provide compared to READ COMMITTED?

- A) It prevents dirty reads.
- B) It prevents dirty reads and non-repeatable reads, but not phantom reads.
- C) It prevents dirty reads, non-repeatable reads, and phantom reads.
- D) It allows reading uncommitted data for maximum throughput.

> **Answer: C**  
> `SERIALIZABLE` is the strictest isolation level. It places range locks to prevent phantom reads (new rows inserted by other transactions that match the WHERE clause of a repeated read), in addition to preventing dirty and non-repeatable reads. This comes at the cost of reduced concurrency.

<div align="right">
    <b><a href="#table-of-contents">↥ back to top</a></b>
</div>

**Q.** A high-traffic e-commerce site sees significant blocking on a table. The DBA enables `READ_COMMITTED_SNAPSHOT ISOLATION` (RCSI) at the database level. What is the primary effect?

- A) All queries run under SERIALIZABLE isolation automatically.
- B) Readers no longer block writers, and writers no longer block readers; readers see the last committed row version from tempdb.
- C) Exclusive locks are replaced with shared locks for all DML statements.
- D) The database becomes read-only while RCSI is active.

> **Answer: B**  
> RCSI uses row versioning in the version store (`tempdb` or the database itself in SQL Server 2019+). Readers get a consistent, committed snapshot of data without acquiring shared locks, so they no longer block writers. Writers still acquire exclusive locks but do not block readers. This significantly reduces contention on OLTP workloads.

<div align="right">
    <b><a href="#table-of-contents">↥ back to top</a></b>
</div>

---

## 6. Views & CTEs

**Q.** A developer creates a view and tries to insert data through it:

```sql
CREATE VIEW vw_ActiveEmployees AS
SELECT EmpID, Name, Department FROM Employees WHERE IsActive = 1;

INSERT INTO vw_ActiveEmployees (EmpID, Name, Department) VALUES (99, 'Alice', 'HR');
```

The new row has `IsActive = 0` by default. After the INSERT, is the row visible through the view?

- A) Yes — the row was inserted and the view always shows all rows.
- B) No — the view rejects the INSERT because `IsActive` is not in the SELECT list.
- C) No — without `WITH CHECK OPTION`, the INSERT succeeds but the row is not visible through the view because it does not satisfy the WHERE clause.
- D) It depends on whether the table has a trigger.

> **Answer: C**  
> Without `WITH CHECK OPTION`, inserting through a view that has a WHERE clause can insert rows that the view itself does not expose. The INSERT goes to the base table with the default `IsActive = 0`, but the view filters `WHERE IsActive = 1`, so the row is invisible through the view. Adding `WITH CHECK OPTION` would prevent the INSERT entirely.

<div align="right">
    <b><a href="#table-of-contents">↥ back to top</a></b>
</div>

**Q.** A complex report query is used in 15 different stored procedures. A developer proposes using a CTE vs. a view. When should a CTE be preferred over a view?

- A) When the logic needs to be persisted for reuse across many sessions and stored procedures.
- B) When the query is recursive (e.g., traversing a hierarchy) or the derived result is used only once within a single query.
- C) When the query result needs to be indexed for performance.
- D) When the result set needs to be materialized and stored on disk.

> **Answer: B**  
> CTEs (Common Table Expressions) are scoped to a single query batch and are not persisted. They are ideal for recursive queries (e.g., org charts) or when intermediate result sets are referenced only once within the same query. Views are persisted objects reusable across sessions. Indexed (materialized) views persist and index the result set on disk.

<div align="right">
    <b><a href="#table-of-contents">↥ back to top</a></b>
</div>

**Q.** A developer writes a recursive CTE to traverse an employee hierarchy but forgets the termination condition. What does SQL Server do?

- A) The query runs forever until the server is restarted.
- B) SQL Server detects the infinite recursion and throws an error after exceeding the default maximum recursion level of 100.
- C) The query returns all rows and stops when the table is exhausted.
- D) SQL Server automatically adds a `ROWCOUNT` limit of 1000.

> **Answer: B**  
> SQL Server enforces a default maximum recursion level of 100 for CTEs (`MAXRECURSION` option, default = 100). When the recursion exceeds this level without a termination condition, it raises error 530: "The statement terminated. The maximum recursion 100 has been exhausted...". You can set `OPTION (MAXRECURSION 0)` to remove the limit, but this risks infinite loops.

<div align="right">
    <b><a href="#table-of-contents">↥ back to top</a></b>
</div>

**Q.** A developer wants to update rows in a CTE. Is the following statement valid in SQL Server?

```sql
WITH CTE AS (
    SELECT EmpID, Salary FROM Employees WHERE Department = 'Sales'
)
UPDATE CTE SET Salary = Salary * 1.10;
```

- A) No — CTEs are read-only and cannot be used in UPDATE statements.
- B) Yes — the UPDATE modifies the underlying base table rows that the CTE references.
- C) Yes — the UPDATE creates a new copy of the data with the changes applied.
- D) No — UPDATE through a CTE requires the `INSTEAD OF` trigger.

> **Answer: B**  
> SQL Server allows DML (INSERT, UPDATE, DELETE) through a CTE when the CTE references a single base table and meets updatability conditions (same rules as views). The UPDATE modifies the actual base table rows filtered by the CTE\'s WHERE clause. This is a common pattern for updating with ranking or filtering logic.

<div align="right">
    <b><a href="#table-of-contents">↥ back to top</a></b>
</div>

---

## 7. Window Functions

**Q.** A sales analyst wants to rank salespeople by `TotalSales` within each `Region`, with ties sharing the same rank and no gaps in rank numbers (e.g., 1, 2, 2, 3). Which function should be used?

- A) `RANK() OVER (PARTITION BY Region ORDER BY TotalSales DESC)`
- B) `DENSE_RANK() OVER (PARTITION BY Region ORDER BY TotalSales DESC)`
- C) `ROW_NUMBER() OVER (PARTITION BY Region ORDER BY TotalSales DESC)`
- D) `NTILE(3) OVER (PARTITION BY Region ORDER BY TotalSales DESC)`

> **Answer: B**  
> `DENSE_RANK()` assigns the same rank to ties and does not leave gaps in the sequence (1, 2, 2, 3). `RANK()` leaves gaps after ties (1, 2, 2, 4). `ROW_NUMBER()` assigns a unique sequential number even to ties. `NTILE(n)` divides rows into n buckets.

<div align="right">
    <b><a href="#table-of-contents">↥ back to top</a></b>
</div>

**Q.** A developer writes the following query to calculate a running total of sales:

```sql
SELECT SaleDate, Amount,
       SUM(Amount) OVER (ORDER BY SaleDate) AS RunningTotal
FROM Sales;
```

What does the `OVER (ORDER BY SaleDate)` clause define?

- A) It sorts the final result set by `SaleDate`.
- B) It defines a window frame that accumulates all rows from the start of the partition up to the current row, ordered by `SaleDate`.
- C) It partitions the data by `SaleDate` into separate groups.
- D) It restricts the SUM to only the rows where `SaleDate` matches the current row\'s date.

> **Answer: B**  
> When `ORDER BY` is used inside `OVER()` without an explicit frame clause, `SUM` defaults to `ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW` — a cumulative sum from the beginning of the partition to the current row. This is different from a GROUP BY SUM, which collapses rows; window functions preserve all rows.

<div align="right">
    <b><a href="#table-of-contents">↥ back to top</a></b>
</div>

**Q.** An analyst uses `LAG()` to compare each month\'s revenue to the previous month:

```sql
SELECT Month, Revenue,
       LAG(Revenue, 1, 0) OVER (ORDER BY Month) AS PrevRevenue
FROM MonthlySales;
```

What does the third argument `0` in `LAG(Revenue, 1, 0)` specify?

- A) The offset — look back 0 rows.
- B) The default value returned when there is no previous row (first row of the partition).
- C) The partition boundary.
- D) The number of decimal places to round to.

> **Answer: B**  
> `LAG(column, offset, default)` — the third argument is the default value returned when the offset falls outside the partition (i.e., there is no previous row). For the first row in the partition, `LAG` would return NULL if no default is specified. Here, `0` is returned instead of NULL for the first month.

<div align="right">
    <b><a href="#table-of-contents">↥ back to top</a></b>
</div>

**Q.** A developer wants to select only the most recent order for each customer from an `Orders` table without using a subquery. Which window function approach is correct?

- A) `SELECT * FROM Orders WHERE RANK() OVER (PARTITION BY CustomerID ORDER BY OrderDate DESC) = 1`
- B) Use a CTE with `ROW_NUMBER() OVER (PARTITION BY CustomerID ORDER BY OrderDate DESC)` and filter `WHERE rn = 1`.
- C) `SELECT TOP 1 * FROM Orders GROUP BY CustomerID ORDER BY OrderDate DESC`
- D) `SELECT FIRST_VALUE(OrderID) OVER (PARTITION BY CustomerID ORDER BY OrderDate DESC) FROM Orders`

> **Answer: B**  
> Window functions cannot appear directly in a WHERE clause because they are evaluated after WHERE. The correct pattern is to define the `ROW_NUMBER()` in a CTE or subquery, then filter `WHERE rn = 1` in the outer query. `RANK()` could return multiple rows per customer if there are ties in `OrderDate`.

<div align="right">
    <b><a href="#table-of-contents">↥ back to top</a></b>
</div>

---

## 8. JSON & XML Support

**Q.** A table `Events` has a column `Details NVARCHAR(MAX)` that stores JSON like `{"user":"Alice","action":"login","ip":"10.0.0.1"}`. Which T-SQL expression extracts the `action` value?

- A) `Details.action`
- B) `JSON_VALUE(Details, '$.action')`
- C) `OPENXML(Details, '/action')`
- D) `Details->>'action'`

> **Answer: B**  
> `JSON_VALUE(expression, path)` extracts a scalar value from a JSON string using a JSONPath expression. The `$` represents the root of the JSON document. `OPENXML` is for XML, not JSON. The `->>`  operator is PostgreSQL syntax, not T-SQL.

<div align="right">
    <b><a href="#table-of-contents">↥ back to top</a></b>
</div>

**Q.** You need to validate that all rows in the `Events.Details` column contain valid JSON before running a JSON query. Which function should you use?

- A) `JSON_VALUE(Details, '$') IS NOT NULL`
- B) `ISJSON(Details) = 1`
- C) `TRY_CONVERT(XML, Details) IS NOT NULL`
- D) `LEN(Details) > 2`

> **Answer: B**  
> `ISJSON(expression)` returns 1 if the string is valid JSON, 0 if it is not, and NULL if the input is NULL. It is the correct function for JSON validation. `JSON_VALUE(Details, '$')` returns the root, which may be NULL for objects/arrays, and does not validate structure. `TRY_CONVERT(XML, ...)` tests for valid XML, not JSON.

<div align="right">
    <b><a href="#table-of-contents">↥ back to top</a></b>
</div>

**Q.** A developer needs to convert query results into a JSON array where each row becomes a JSON object. Which T-SQL clause achieves this?

- A) `FOR XML AUTO`
- B) `FOR JSON AUTO`
- C) `JSON_ARRAYAGG(*)`
- D) `CONVERT(JSON, *)`

> **Answer: B**  
> `FOR JSON AUTO` automatically formats the result set as a JSON array, mapping each row to a JSON object with column names as keys. `FOR JSON PATH` provides more control over the output structure. `FOR XML AUTO` produces XML, not JSON. `JSON_ARRAYAGG` is a SQL standard function not natively available in T-SQL (SQL Server 2025 introduced `JSON_ARRAYAGG` — see section 15).

<div align="right">
    <b><a href="#table-of-contents">↥ back to top</a></b>
</div>

**Q.** A microservice stores product metadata as JSON in SQL Server. A developer uses `OPENJSON` to shred the JSON array into rows:

```sql
SELECT * FROM OPENJSON('{"products":[{"id":1,"name":"Bolt"},{"id":2,"name":"Nut"}]}', '$.products')
WITH (id INT, name NVARCHAR(50));
```

What does the `WITH` clause do here?

- A) It defines a filter on the JSON output.
- B) It defines the schema (column names and types) to map JSON properties to relational columns.
- C) It creates a new table to store the result.
- D) It specifies which JSON path to use as the primary key.

> **Answer: B**  
> `OPENJSON` with a `WITH` clause uses an explicit schema definition to map JSON property names to typed relational columns. Without `WITH`, it returns three generic columns: `key`, `value`, and `type`. The `WITH` clause enables strongly-typed shredding of JSON into a relational rowset.

<div align="right">
    <b><a href="#table-of-contents">↥ back to top</a></b>
</div>

---

## 9. Security & Permissions

**Q.** A developer creates a stored procedure that accesses a table owned by a different schema. When a user executes the procedure, they get a permissions error on the underlying table. What concept explains why this happens, and what is the best fix?

- A) The user needs `SELECT` permission on the table — grant it directly.
- B) Ownership chaining is broken because the procedure and table have different owners; change them to share the same owner/schema.
- C) The procedure must use dynamic SQL to access cross-schema tables.
- D) SQL Server does not allow stored procedures to access tables in other schemas.

> **Answer: B**  
> SQL Server\'s ownership chaining allows permission checks to be skipped on objects within the same ownership chain. When a stored procedure and the tables it accesses share the same owner (typically `dbo`), users only need `EXECUTE` on the procedure. If ownership differs, SQL Server checks the caller\'s permissions on each object, breaking the chain. The fix is to ensure consistent ownership or grant explicit permissions.

<div align="right">
    <b><a href="#table-of-contents">↥ back to top</a></b>
</div>

**Q.** Sensitive columns like `SSN` and `CreditCardNumber` in a `Customers` table must be encrypted so that DBAs cannot view the plaintext values but the application can query them. Which SQL Server feature is designed for this?

- A) Transparent Data Encryption (TDE).
- B) Always Encrypted.
- C) Row-Level Security (RLS).
- D) Dynamic Data Masking.

> **Answer: B**  
> Always Encrypted ensures that encryption and decryption happen exclusively on the client side. The database engine only ever stores and handles ciphertext — even DBAs with full access see only encrypted bytes. TDE encrypts data at rest (entire database files) but DBAs can still query plaintext. Dynamic Data Masking shows masked output to non-privileged users but does not actually encrypt the data.

<div align="right">
    <b><a href="#table-of-contents">↥ back to top</a></b>
</div>

**Q.** A multi-tenant SaaS application stores all tenants' data in one table with a `TenantID` column. You need each tenant to see only their own rows, transparently, without modifying every query. Which feature should you implement?

- A) Column-level encryption.
- B) A view with a WHERE clause for each tenant.
- C) Row-Level Security (RLS) with a security policy and predicate function.
- D) Dynamic Data Masking on the `TenantID` column.

> **Answer: C**  
> Row-Level Security (RLS) enforces row-level filtering at the engine level using a security predicate function and a security policy. It is transparent to queries — the filter is automatically applied regardless of how the table is accessed. This is the recommended approach for multi-tenant data isolation without requiring query changes.

<div align="right">
    <b><a href="#table-of-contents">↥ back to top</a></b>
</div>

**Q.** A junior DBA runs `GRANT CONTROL ON DATABASE::AdventureWorks TO AppUser`. What level of access does `AppUser` now have?

- A) Read-only access to all tables in `AdventureWorks`.
- B) The ability to create tables but not drop the database.
- C) Almost full database-level control: the ability to grant permissions, create and alter objects, and perform most DBA tasks on that database — but not to drop the database without ALTER ANY DATABASE on the server.
- D) Server-level administrative access.

> **Answer: C**  
> `CONTROL` on a database is the highest database-level permission, implying all other database permissions. The grantee can effectively act as a database owner (DBO-equivalent). It does not grant server-level permissions (like creating new databases). Be very careful granting `CONTROL` — it should be reserved for database administrators.

<div align="right">
    <b><a href="#table-of-contents">↥ back to top</a></b>
</div>

---

## 10. Database Design & Normalization

**Q.** A table `Orders` has columns: `OrderID`, `CustomerID`, `CustomerName`, `CustomerCity`, `ProductID`, `ProductName`, `Quantity`, `Price`. A data analyst complains that updating a customer\'s city requires changing many rows. Which normal form is violated, and what is the fix?

- A) 1NF — split repeating groups into separate rows.
- B) 2NF — `CustomerName` and `CustomerCity` depend only on `CustomerID`, not the full key; move them to a `Customers` table.
- C) 3NF — `ProductName` is transitively dependent on `OrderID`; create a `Products` table.
- D) Both B and C — the table violates 2NF and 3NF simultaneously.

> **Answer: D**  
> The table violates multiple normal forms. `CustomerName`/`CustomerCity` depend only on `CustomerID` (partial dependency → 2NF violation if the key is composite `OrderID + ProductID`). `ProductName` depends on `ProductID`, not the full key (also a partial dependency). The fix is to separate `Customers` and `Products` into their own tables, leaving `Orders` with foreign keys.

<div align="right">
    <b><a href="#table-of-contents">↥ back to top</a></b>
</div>

**Q.** A `Person` table has a column `PhoneNumbers NVARCHAR(500)` storing multiple values like "555-1234, 555-5678". Which normal form does this violate?

- A) 2NF — partial dependency.
- B) 3NF — transitive dependency.
- C) 1NF — columns must be atomic (single-valued); multiple values in one column violate atomicity.
- D) BCNF — the column is not a superkey.

> **Answer: C**  
> First Normal Form (1NF) requires that each column contain atomic (indivisible) values and that there are no repeating groups. Storing multiple phone numbers in a comma-separated list violates 1NF. The fix is to create a separate `PersonPhones` table with one phone number per row.

<div align="right">
    <b><a href="#table-of-contents">↥ back to top</a></b>
</div>

**Q.** A developer designs a `Reservations` table. A guest can reserve multiple rooms, and a room can be reserved by multiple guests (on different dates). What is the most appropriate relationship model?

- A) One-to-One between `Guests` and `Rooms`.
- B) One-to-Many from `Guests` to `Rooms`.
- C) Many-to-Many, implemented with a junction table `GuestRoomReservations` containing foreign keys to both `Guests` and `Rooms` plus reservation date columns.
- D) Self-referencing relationship on `Guests`.

> **Answer: C**  
> The relationship is Many-to-Many: one guest may reserve many rooms, and one room may be reserved by many guests. In relational databases, a junction (bridge) table is used to resolve M:N relationships, often with additional attributes like `CheckInDate` and `CheckOutDate`.

<div align="right">
    <b><a href="#table-of-contents">↥ back to top</a></b>
</div>

**Q.** Which SQL Server constraint enforces that a column value in a child table must exist in the parent table\'s primary key, and what happens to child rows when a parent row is deleted with `ON DELETE CASCADE`?

- A) CHECK constraint — child rows are updated to NULL.
- B) UNIQUE constraint — child rows are blocked from deletion.
- C) FOREIGN KEY constraint — child rows are automatically deleted when the parent row is deleted.
- D) DEFAULT constraint — child rows inherit the parent\'s default value.

> **Answer: C**  
> A `FOREIGN KEY` constraint enforces referential integrity. When defined with `ON DELETE CASCADE`, deleting a parent row automatically deletes all child rows that reference it. Without `CASCADE`, the default behavior is to raise an error if child rows exist.

<div align="right">
    <b><a href="#table-of-contents">↥ back to top</a></b>
</div>

---

## 11. Backup & Recovery

**Q.** A DBA takes a full backup of a database on Sunday night and transaction log backups every hour. The database crashes at 10:45 AM on Wednesday. What is the correct restore sequence to recover to the point of failure?

- A) Restore the full backup only.
- B) Restore the full backup, then apply all transaction log backups in order up to 10:45 AM.
- C) Restore the most recent transaction log backup only.
- D) Restore the full backup, then restore the most recent transaction log backup.

> **Answer: B**  
> Point-in-time recovery requires: (1) Restore the full backup (`WITH NORECOVERY`), (2) Apply each transaction log backup in chronological order (`WITH NORECOVERY`), (3) Restore the tail-log backup (the active log captured after the crash), and (4) Apply the final restore `WITH RECOVERY` to bring the database online. Skipping intermediate log backups breaks the log chain.

<div align="right">
    <b><a href="#table-of-contents">↥ back to top</a></b>
</div>

**Q.** A DBA notices the transaction log file (`*.ldf`) has grown to 200 GB despite daily backups. What is the most likely cause?

- A) The recovery model is `SIMPLE` and backups are too frequent.
- B) The recovery model is `FULL` but transaction log backups are not being taken, so the log cannot be truncated.
- C) The database has too many indexes, filling the log faster.
- D) `AUTO_SHRINK` is disabled, preventing log truncation.

> **Answer: B**  
> In `FULL` recovery model, the log is only truncated (space marked as reusable) after a successful transaction log backup. If only full backups are taken, the log grows unboundedly. The fix is to schedule regular transaction log backups. In `SIMPLE` recovery model, the log is truncated automatically at each checkpoint, so it does not grow indefinitely.

<div align="right">
    <b><a href="#table-of-contents">↥ back to top</a></b>
</div>

**Q.** What does `RESTORE DATABASE AdventureWorks FROM DISK='C:\backup\aw.bak' WITH NORECOVERY` accomplish?

- A) Restores the database and makes it immediately available for user connections.
- B) Restores the database data pages but leaves it in a restoring state so additional log or differential backups can be applied.
- C) Verifies the backup file is readable without actually restoring any data.
- D) Restores only the transaction log from the backup file.

> **Answer: B**  
> `WITH NORECOVERY` restores the data but keeps the database in the "Restoring" state, allowing subsequent backups (differential or log) to be applied. `WITH RECOVERY` (the default) brings the database online after the restore, rolls back uncommitted transactions, and prevents further backup application. `WITH VERIFYONLY` checks backup integrity without restoring.

<div align="right">
    <b><a href="#table-of-contents">↥ back to top</a></b>
</div>

**Q.** A company requires a Recovery Point Objective (RPO) of 15 minutes and a Recovery Time Objective (RTO) of 30 minutes for their mission-critical SQL Server database. Which SQL Server high-availability solution best meets both requirements?

- A) Database Mirroring with asynchronous mode.
- B) Log Shipping with a 15-minute log backup schedule.
- C) Always On Availability Groups with synchronous-commit mode and automatic failover.
- D) Full backups every 15 minutes to Azure Blob Storage.

> **Answer: C**  
> Always On Availability Groups with synchronous-commit mode ensures zero data loss (RPO = 0, which is ≤ 15 minutes). Automatic failover minimizes RTO by triggering failover without DBA intervention, typically completing in seconds to minutes (well within 30 minutes). Log shipping has a gap equal to the log backup interval. Database Mirroring is deprecated.

<div align="right">
    <b><a href="#table-of-contents">↥ back to top</a></b>
</div>

---

## 12. Query Optimization & Execution Plans

**Q.** A developer adds a function to the WHERE clause for a date filter:

```sql
SELECT * FROM Orders WHERE YEAR(OrderDate) = 2024;
```

The query does a full table scan despite an index on `OrderDate`. What is the cause and fix?

- A) The index on `OrderDate` must be rebuilt — it is fragmented.
- B) Wrapping `OrderDate` in `YEAR()` makes the predicate non-sargable; the fix is to use a range predicate: `WHERE OrderDate >= '2024-01-01' AND OrderDate < '2025-01-01'`.
- C) Add a computed column index on `YEAR(OrderDate)`.
- D) Both B and C are valid fixes.

> **Answer: D**  
> The root cause is a non-sargable predicate: applying a function to an indexed column prevents the optimizer from using the index seek. The primary fix (B) is to rewrite the predicate as a range comparison that allows an index seek. An alternative (C) is to create a computed column with a persisted index. Both solutions are valid, with B being the simpler and generally preferred approach.

<div align="right">
    <b><a href="#table-of-contents">↥ back to top</a></b>
</div>

**Q.** An execution plan shows a Hash Match join instead of a Nested Loops join for two large tables. Under what conditions does the optimizer typically prefer a Hash Match join?

- A) When both input tables are very small and fit in memory.
- B) When one table is much smaller than the other and has an index.
- C) When both inputs are large, unsorted, and lack useful indexes on the join columns.
- D) When the tables are joined on a primary key to foreign key relationship with an index.

> **Answer: C**  
> The optimizer chooses join algorithms based on estimated row counts and available indexes. Nested Loops are efficient for small outer inputs with an index on the inner table. Merge Joins work on pre-sorted inputs. Hash Joins build an in-memory hash table from one input and probe with the other — preferred when both inputs are large, unordered, and indexes on join keys are absent.

<div align="right">
    <b><a href="#table-of-contents">↥ back to top</a></b>
</div>

**Q.** A stored procedure runs fast on the first execution but takes minutes on subsequent executions for different parameter values. What is this problem called, and what is the quickest fix?

- A) Index fragmentation — rebuild the indexes.
- B) Parameter sniffing — the plan compiled for the first parameter value is suboptimal for other values; add `OPTION (RECOMPILE)` or use `OPTIMIZE FOR`.
- C) Lock escalation — the table locks are blocking re-use of the plan.
- D) Statistics staleness — update statistics on all tables.

> **Answer: B**  
> Parameter sniffing occurs when SQL Server compiles a plan based on the first set of parameter values and caches it for reuse. If subsequent calls use very different parameter values (e.g., a highly selective vs. non-selective value), the cached plan is suboptimal. Fixes include `OPTION (RECOMPILE)` (recompile each execution), `OPTIMIZE FOR` (optimize for a representative value), or breaking the procedure into multiple procedures.

<div align="right">
    <b><a href="#table-of-contents">↥ back to top</a></b>
</div>

**Q.** Which dynamic management view (DMV) is most useful for identifying the top 10 most expensive queries currently in the plan cache by total CPU time?

- A) `sys.dm_exec_connections`
- B) `sys.dm_exec_query_stats` joined with `sys.dm_exec_sql_text`
- C) `sys.dm_os_wait_stats`
- D) `sys.dm_db_index_usage_stats`

> **Answer: B**  
> `sys.dm_exec_query_stats` contains aggregated performance statistics (CPU, I/O, elapsed time, execution count) for cached query plans. Joining it with `sys.dm_exec_sql_text` retrieves the actual query text. `sys.dm_os_wait_stats` shows server-wide wait types. `sys.dm_db_index_usage_stats` shows index access patterns.

<div align="right">
    <b><a href="#table-of-contents">↥ back to top</a></b>
</div>

---

## 13. Temporal Tables & Change Tracking

**Q.** A developer needs to query the state of a `Contracts` table as it was on `'2025-06-15 12:00:00'`. The table is configured as a system-versioned temporal table. Which T-SQL syntax retrieves the historical snapshot?

- A) `SELECT * FROM Contracts WHERE ValidFrom <= '2025-06-15 12:00:00' AND ValidTo > '2025-06-15 12:00:00'`
- B) `SELECT * FROM Contracts FOR SYSTEM_TIME AS OF '2025-06-15T12:00:00'`
- C) `SELECT * FROM Contracts_History WHERE SnapshotDate = '2025-06-15'`
- D) `SELECT * FROM Contracts WITH (HISTORICAL) WHERE RowDate = '2025-06-15'`

> **Answer: B**  
> SQL Server\'s temporal table syntax `FOR SYSTEM_TIME AS OF <datetime>` is the correct and idiomatic way to query the point-in-time state of a system-versioned table. SQL Server automatically queries both the current and history tables to reconstruct the state at the given moment. Option A would also work against the history table manually, but B is the official temporal query syntax.

<div align="right">
    <b><a href="#table-of-contents">↥ back to top</a></b>
</div>

**Q.** What are the two system-generated columns required when creating a system-versioned temporal table in SQL Server?

- A) `CreatedDate` and `ModifiedDate` of type `DATETIME`.
- B) `ValidFrom` and `ValidTo` (or any names) of type `DATETIME2` with `GENERATED ALWAYS AS ROW START/END`.
- C) `RowVersion` and `Timestamp` of type `ROWVERSION`.
- D) `SysStartTime` and `SysEndTime` of type `DATETIMEOFFSET`.

> **Answer: B**  
> Temporal tables require two `DATETIME2` columns marked as `GENERATED ALWAYS AS ROW START` and `GENERATED ALWAYS AS ROW END`. SQL Server automatically populates these to track when each row version was valid. The column names can be anything (common conventions include `ValidFrom`/`ValidTo` or `SysStartTime`/`SysEndTime`), but the type must be `DATETIME2` and they must be in the column definition.

<div align="right">
    <b><a href="#table-of-contents">↥ back to top</a></b>
</div>

**Q.** A developer deletes a row from a temporal table. Where does the deleted row go, and for how long is it retained?

- A) It is permanently deleted from both the current and history tables immediately.
- B) It is moved to the linked history table with its `ValidTo` set to the deletion time; it is retained until the history table is explicitly purged or a retention policy removes it.
- C) It is soft-deleted using an `IsDeleted` flag column.
- D) It is archived to a separate archive database automatically.

> **Answer: B**  
> When a row is deleted from a system-versioned temporal table, SQL Server moves the row to the history table with the `ValidTo` column set to the current UTC time. The row remains in the history table indefinitely unless a history retention policy (configurable in SQL Server 2016+) is applied or the history table is manually cleaned up.

<div align="right">
    <b><a href="#table-of-contents">↥ back to top</a></b>
</div>

---

## 14. Partitioning & Columnstore Indexes

**Q.** A `SalesHistory` table has 5 billion rows with data from 2000 to 2025. Queries always filter on a specific year. A DBA recommends table partitioning by year. What is the primary performance benefit?

- A) Each partition gets its own set of indexes, doubling index performance.
- B) Queries filtering on the partition key (year) can skip partitions that don\'t match — called "partition elimination" — dramatically reducing I/O.
- C) Partitioning compresses each partition automatically, reducing storage by 90%.
- D) Partitioning distributes data across multiple servers automatically.

> **Answer: B**  
> Partition elimination (also called partition pruning) is the key performance benefit. When a query filters on the partition column, the optimizer identifies which partitions satisfy the predicate and scans only those, ignoring all others. For a 5-billion-row table filtered by year, this can reduce I/O by orders of magnitude.

<div align="right">
    <b><a href="#table-of-contents">↥ back to top</a></b>
</div>

**Q.** A DBA wants to archive old data from a partitioned `Orders` table to an archive table instantly without a large data copy operation. Which technique achieves this?

- A) `INSERT INTO OrdersArchive SELECT * FROM Orders WHERE Year < 2020`
- B) `ALTER TABLE Orders SWITCH PARTITION n TO OrdersArchive PARTITION m`
- C) `DROP PARTITION n FROM Orders`
- D) `TRUNCATE TABLE Orders WITH (PARTITION n)`

> **Answer: B**  
> `ALTER TABLE ... SWITCH PARTITION` is a metadata-only operation that reassigns the ownership of a partition\'s data pages from one table (or partition) to another instantaneously — no data movement occurs. Both tables must be on the same filegroup and have identical structure. This is the standard technique for partition-based archiving. Option D (`TRUNCATE ... WITH PARTITION`) deletes the data rather than archiving it.

<div align="right">
    <b><a href="#table-of-contents">↥ back to top</a></b>
</div>

**Q.** A developer sees a "Batch Mode Hash Aggregate" operator in the execution plan of an analytics query. What does this indicate?

- A) The query is blocked by another transaction using hash-based locking.
- B) The aggregation is executing in batch mode (processing up to 900 rows at once) using SIMD instructions, typically because a columnstore index is involved.
- C) The server ran out of memory and is spilling to disk using a hash bucket strategy.
- D) The query is using a hash join, which is slower than a merge join.

> **Answer: B**  
> Batch mode processing was introduced alongside columnstore indexes and processes data in batches of ~900 rows using CPU vector instructions (SIMD), instead of processing one row at a time (row mode). Batch mode operators like "Batch Mode Hash Aggregate" are significantly faster for analytics. SQL Server 2019+ introduced "Batch Mode on Rowstore" so batch mode can appear even without columnstore indexes.

<div align="right">
    <b><a href="#table-of-contents">↥ back to top</a></b>
</div>

---

## 15. New Features in SQL Server 2025

**Q.** SQL Server 2025 introduces native vector data type and vector search capabilities. A developer stores product embeddings (from an AI model) in a `Products` table. Which new function finds the top 5 most similar products to a given embedding vector using cosine similarity?

- A) `SELECT TOP 5 * FROM Products ORDER BY VECTOR_DISTANCE('cosine', Embedding, @queryVector) ASC`
- B) `SELECT TOP 5 * FROM Products ORDER BY COSINE_SIMILARITY(Embedding, @queryVector) DESC`
- C) `SELECT TOP 5 * FROM Products WHERE EMBEDDING_MATCH(Embedding, @queryVector) > 0.9`
- D) `SELECT TOP 5 * FROM Products ORDER BY DOT_PRODUCT(Embedding, @queryVector) DESC`

> **Answer: A**  
> SQL Server 2025 introduces the `VECTOR` data type and the `VECTOR_DISTANCE()` function for computing distances between vector embeddings. `VECTOR_DISTANCE('cosine', col, @vec)` returns the cosine distance (lower = more similar), so ordering `ASC` retrieves the most similar items. This enables Retrieval-Augmented Generation (RAG) and semantic search scenarios natively in T-SQL.

<div align="right">
    <b><a href="#table-of-contents">↥ back to top</a></b>
</div>

**Q.** SQL Server 2025 adds AI-powered query intelligence features. A developer notices a new hint in execution plans: "Adaptive Query Processing: Feedback applied." What does this mean?

- A) A human DBA manually adjusted the query hints.
- B) The Query Store has automatically applied cardinality estimate corrections or degree-of-parallelism adjustments learned from previous executions of the same query.
- C) The query is running in compatibility mode with feedback enabled.
- D) Azure AI services are processing the query externally.

> **Answer: B**  
> Intelligent Query Processing (IQP) in SQL Server 2022/2025 includes features like Memory Grant Feedback, Degree of Parallelism Feedback, and Cardinality Estimation Feedback. These features observe query execution, detect suboptimal estimates, and apply corrections to the cached plan on subsequent executions — all automatically via the Query Store, without DBA intervention.

<div align="right">
    <b><a href="#table-of-contents">↥ back to top</a></b>
</div>

**Q.** SQL Server 2025 supports `JSON_ARRAYAGG()` and `JSON_OBJECTAGG()` as aggregate functions. What does the following query produce?

```sql
SELECT JSON_ARRAYAGG(ProductName ORDER BY ProductName)
FROM Products
WHERE CategoryID = 5;
```

- A) A single row with a JSON object mapping product names to their IDs.
- B) A single row with a JSON array of product names, sorted alphabetically.
- C) Multiple rows, one JSON value per product.
- D) A JSON string formatted as `{ProductName: [...]}`.

> **Answer: B**  
> `JSON_ARRAYAGG()` is a SQL standard aggregate function (added in SQL Server 2025) that aggregates column values into a single JSON array. The `ORDER BY` inside the function controls the order of elements in the array. The result is a single scalar value: a JSON array like `["Bolt","Nut","Screw"]`.

<div align="right">
    <b><a href="#table-of-contents">↥ back to top</a></b>
</div>

**Q.** SQL Server 2025 introduces enhancements to the `TRIM()` function. Which of the following correctly removes leading and trailing pipe (`|`) characters from a string?

- A) `TRIM('|' FROM '|Hello World|')`
- B) `LTRIM(RTRIM('|Hello World|'))`
- C) `REPLACE('|Hello World|', '|', '')`
- D) `SUBSTRING('|Hello World|', 2, LEN('|Hello World|') - 2)`

> **Answer: A**  
> SQL Server 2022+ extended `TRIM()` to accept a character list argument: `TRIM(characters FROM string)`. This removes any leading or trailing occurrences of the specified characters. Option B only removes spaces. Option C removes all pipe characters including those in the middle. Option D is a manual substring approach that only works for exactly one leading/trailing character.

<div align="right">
    <b><a href="#table-of-contents">↥ back to top</a></b>
</div>

**Q.** A DBA wants to use the new `sys.dm_exec_query_feedback` DMV available in SQL Server 2025. What information does this DMV provide?

- A) A list of all queries waiting for user input.
- B) Details about Intelligent Query Processing feedback that has been applied or is pending for cached query plans, including memory grant adjustments and DOP corrections.
- C) A real-time dashboard of active user connections and their query text.
- D) A log of all failed query executions with error codes.

> **Answer: B**  
> `sys.dm_exec_query_feedback` (and related DMVs like `sys.query_store_query_hints`) surfaces information about IQP feedback that the Query Store has collected and applied to cached plans. DBAs can use it to monitor which queries are benefiting from Adaptive Query Processing and what corrections have been made.

<div align="right">
    <b><a href="#table-of-contents">↥ back to top</a></b>
</div>

**Q.** SQL Server 2025 introduces **Ledger tables** with enhanced tamper-evidence capabilities. A developer creates a ledger table. What happens when someone tries to UPDATE a row and then delete the evidence from the transaction log?

- A) The update is blocked — ledger tables are read-only.
- B) The update succeeds, but cryptographic hashes stored in the database ledger make it mathematically detectable if any historical row was altered or deleted after the fact.
- C) The transaction log entry is protected by row-level security, so only the DBA can see it.
- D) SQL Server automatically restores the original row from a hidden snapshot.

> **Answer: B**  
> Ledger tables (introduced in SQL Server 2022, enhanced in 2025) work by storing a cryptographic hash (SHA-256) of each block of transactions in a database ledger. Even with `sysadmin` access, any tampering with historical data — whether in the table, the history table, or the transaction log — is detectable by re-verifying the hash chain using `sp_verify_database_ledger`. This provides court-admissible audit trails.

<div align="right">
    <b><a href="#table-of-contents">↥ back to top</a></b>
</div>
