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
    <b><a href="#table-of-contents">↥ back to top</a></b>
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
SHOW INDEX FROM table_name;
ALTER TABLE `table_name` ADD INDEX(`column_name`);
DROP INDEX index_name ON tbl_name;
```

<div align="right">
    <b><a href="#table-of-contents">↥ back to top</a></b>
</div>

## Q. What are the types of indexes in sql?

## Q. What is transactions in SQL?

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


---Example - 02 INSERT Query using Transaction

CREATE TABLE test (
    id SERIAL,
    data VARCHAR(256)
);

-- Insert 1,000 times ...
INSERT INTO test ( data ) VALUES ( 'this is a good sized line of text.' );


--- Insert 1000 times using Transaction
START TRANSACTION;

INSERT INTO test ( data ) VALUES ( 'this is a good sized line of text.' );
COMMIT;
```

<div align="right">
    <b><a href="#table-of-contents">↥ back to top</a></b>
</div>

## Q. What is Views in SQL?

A view is a virtual table that is a result of a query. They can be extremely useful and are often used as a security mechanism, letting users access the data through the view, rather than letting them access the underlying base table:

|Sl.No|Query                                                     | Description                                       |
|-----|----------------------------------------------------------|---------------------------------------------------|
| 01. |CREATE VIEW view1 AS SELECT c1, c2 FROM t1 WHERE condition|Create a view, comprising of columns c1 and c2 from a table named t1 where a certain condition has been met.|

<div align="right">
    <b><a href="#table-of-contents">↥ back to top</a></b>
</div>

## Q. What is View in SQL?

```sql
---Example - 01 : Creating a View

SELECT id, album_id, title, track_number, duration DIV 60 AS m, duration MOD 60 AS s
  FROM track;

CREATE VIEW trackView AS
  SELECT id, album_id, title, track_number, duration DIV 60 AS m, duration MOD 60 AS s
    FROM track;
SELECT * FROM trackView;



---Exmaple - 02 : Joined view

SELECT a.artist AS artist,
    a.title AS album,
    t.title AS track,
    t.track_number AS trackno,
    t.duration DIV 60 AS m,
    t.duration MOD 60 AS s
  FROM track AS t
  JOIN album AS a
    ON a.id = t.album_id
;


CREATE VIEW joinedAlbum AS
  SELECT a.artist AS artist,
      a.title AS album,
      t.title AS track,
      t.track_number AS trackno,
      t.duration DIV 60 AS m,
      t.duration MOD 60 AS s
    FROM track AS t
    JOIN album AS a
      ON a.id = t.album_id
;

SELECT * FROM joinedAlbum;
SELECT * FROM joinedAlbum WHERE artist = 'Jimi Hendrix';


---Example - 03 : Drop View

DROP VIEW IF EXISTS joinedAlbum;
```

<div align="right">
    <b><a href="#table-of-contents">↥ back to top</a></b>
</div>

## Q. What are the triggers in SQL?

A trigger is a special type of stored procedure that automatically executes when a user tries to modify data through a DML event (data manipulation language). A DML event is an INSERT, UPDATE or DELETE statement on a table or view:

```sql
CREATE OR MODIFY TRIGGER trigger_name
WHEN EVENT

ON table_name TRIGGER_TYPE

EXECUTE stored_procedure
```

WHEN:
* BEFORE – invoke before the event occurs
* AFTER – invoke after the event occurs

EVENT:
* INSERT – invoke for insert
* UPDATE – invoke for update
* DELETE – invoke for delete

TRIGGER_TYPE:
* FOR EACH ROW
* FOR EACH STATEMENT

```sql
!-- Delete a specific trigger
DROP TRIGGER trigger_name
```

<div align="right">
    <b><a href="#table-of-contents">↥ back to top</a></b>
</div>

## Q. What is Trigger in SQL?

**Example - 01:** Updating a table with a trigger

```sql
CREATE TABLE widgetCustomer ( id SERIAL, name VARCHAR(255), last_order_id BIGINT );
CREATE TABLE widgetSale ( id SERIAL, item_id BIGINT, customer_id BIGINT, quan INT, price DECIMAL(9,2) );

INSERT INTO widgetCustomer (name) VALUES ('Bob');
INSERT INTO widgetCustomer (name) VALUES ('Sally');
INSERT INTO widgetCustomer (name) VALUES ('Fred');

SELECT * FROM widgetCustomer;

CREATE TRIGGER newWidgetSale AFTER INSERT ON widgetSale
    FOR EACH ROW
    UPDATE widgetCustomer SET last_order_id = NEW.id WHERE id = NEW.customer_id
;

INSERT INTO widgetSale (item_id, customer_id, quan, price) VALUES (1, 3, 5, 19.95);
INSERT INTO widgetSale (item_id, customer_id, quan, price) VALUES (2, 2, 3, 14.95);
INSERT INTO widgetSale (item_id, customer_id, quan, price) VALUES (3, 1, 1, 29.95);
SELECT * FROM widgetSale;
SELECT * FROM widgetCustomer;
```

<div align="right">
    <b><a href="#table-of-contents">↥ back to top</a></b>
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
    <b><a href="#table-of-contents">↥ back to top</a></b>
</div>

## Q. What is stored procedure in SQL?

A stored procedure is a set of SQL statements with an assigned name that can then be easily reused and share by multiple programs:

|Sl.No|Query                               | Description                                       |
|-----|------------------------------------|---------------------------------------------------|
| 01. |CREATE PROCEDURE procedure_name  @variable AS datatype = value AS -- Comments SELECT * FROM tGO |Create a procedure called procedure_name, create a local variable and then select from table t|

<div align="right">
    <b><a href="#table-of-contents">↥ back to top</a></b>
</div>

## Q. What is the difference between Cluster and Non-Cluster Index?
