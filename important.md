# Important SQL Interview Questions

<br/>

## Q. What is difference between Correlated subquery and nested subquery?

Correlated subqueries are used for row-by-row processing. Each subquery is executed once for every row of the outer query.

A correlated subquery is evaluated once for each row processed by the parent statement. The parent statement can be a SELECT, UPDATE, or DELETE statement.

**Example:**

```sql
--- Correlated Subquery
SELECT e.EmpFirstName, e.Salary, e.DeptId 
FROM Employee e 
WHERE e.Salary = (SELECT max(Salary) FROM Employee ee WHERE ee.DeptId = e.DeptId)
```

```sql
--- Nested Subquery
SELECT EmpFirstName, Salary, DeptId 
FROM Employee 
WHERE (DeptId, Salary) IN (SELECT DeptId, max(Salary) FROM Employee group by DeptId)
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
-- Create Index
CREATE INDEX <index_name> ON <table_name> (column1, column2, ...)

-- Show Index
SHOW INDEX FROM <table_name>;

-- Alter Index
ALTER TABLE <table_name> ADD INDEX(`column_name`);

-- Drop Index
DROP INDEX index_name ON <table_name>;
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
-- Exmaple - 01

CREATE TABLE widgetInventory (
    id SERIAL,
    description VARCHAR(255),
    onhand INTEGER NOT NULL
);

CREATE TABLE widgetSales (
    id SERIAL,
    inv_id INTEGER,
    quan INTEGER,
    price INTEGER
);

INSERT INTO widgetInventory ( description, onhand ) VALUES  ( 'rock', 25 );
INSERT INTO widgetInventory ( description, onhand ) VALUES  ( 'paper', 25 );
INSERT INTO widgetInventory ( description, onhand ) VALUES  ( 'scissors', 25 );


START TRANSACTION;
INSERT INTO widgetSales ( inv_id, quan, price ) VALUES ( 1, 5, 500 );
UPDATE widgetInventory SET onhand = ( onhand - 5 ) WHERE id = 1;
COMMIT;

SELECT * FROM widgetInventory;
SELECT * FROM widgetSales;

START TRANSACTION;
INSERT INTO widgetInventory ( description, onhand ) VALUES ( 'toy', 25 );
ROLLBACK;
SELECT * FROM widgetInventory;
SELECT * FROM widgetSales;
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

CREATE VIEW trackView AS
  SELECT id, album_id, title, track_number, duration DIV 60 AS m, duration MOD 60 AS s
    FROM track;
SELECT * FROM trackView;
```

<div align="right">
    <b><a href="#">↥ back to top</a></b>
</div>

## Q. What are the triggers in SQL?

A trigger is a stored procedure in database which automatically invokes whenever a special event in the database occurs. For example, a trigger can be invoked when a row is inserted into a specified table or when certain table columns are being updated.

**Syntax:**

```sql
CREATE [OR REPLACE ] TRIGGER <trigger_name>
{BEFORE | AFTER | INSTEAD OF }
{INSERT [OR] | UPDATE [OR] | DELETE}
ON <table_name>
[FOR EACH ROW]
WHEN (condition)
[trigger_body]
```

**Example - 01:**

```sql
CREATE TRIGGER employee_name 
after INSERT 
on 
employee 
for each row 
BEGIN 
   UPDATE employee set full_name = first_name || ' ' || last_name;
END;
```

<div align="right">
    <b><a href="#">↥ back to top</a></b>
</div>

## Q. What are cursors and when they are useful?

When we execute any SQL operations, SQL Server opens a work area in memory which is called Cursor. When it is required to perform the row by row operations which are not possible with the set-based operations then cursor is used.

There are two of cursors:

**1. Implicate Cursor:**

* SQL Server automatically manages cursors for all data manipulation statements. These cursors are called implicit cursors.

**2. Explicit Cursor:**

* When the programmer wants to perform the row by row operations for the result set containing more than one row, then he explicitly declare a cursor with a name.
* They are managed by OPEN, FETCH and CLOSE.
* %FOUND, %NOFOUND, %ROWCOUNT and %ISOPEN attributes are used in both types of cursors.

<div align="right">
    <b><a href="#">↥ back to top</a></b>
</div>

## Q. What is stored procedure in SQL?

A stored procedure is a set of SQL statements with an assigned name that can then be easily reused and share by multiple programs:

|Sl.No|Query                               | Description                                       |
|-----|------------------------------------|---------------------------------------------------|
| 01. |CREATE PROCEDURE procedure_name  @variable AS datatype = value AS -- Comments SELECT * FROM tGO |Create a procedure called procedure_name, create a local variable and then select from table t|

<div align="right">
    <b><a href="#">↥ back to top</a></b>
</div>

## Q. What is the difference between Cluster and Non-Cluster Index?
