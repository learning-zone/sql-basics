# SQL Basics

*Click <img src="https://github.com/learning-zone/mysql-interview-questions/blob/master/assets/star.png" width="20" height="20" align="absmiddle" title="Star" /> if you like the project. Pull Request are highly appreciated.*

## Table of Contents

* *[SQL Commands](sql-commands.md)*
* *[SQL Query Practice](sql-query-practice.md)*

<br/>

## Q. What are indexes in a Database?

An index is a database structure that you can use to improve the performance of database activity. A database table can have one or more indexes associated with it. An index is defined by a field expression that you specify when you create the index. Typically, the field expression is a single field name, like EMP_ID.

An index is used to speed up the performance of queries by reducing the number of database pages that have to be visited:

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

## Q. Explain JOIN Query in mySQL?

A `JOIN` clause is used to combine rows from two or more tables, based on a related column between them.  
Take `users` table and `orders` table for example.  

**Users Table:**  

|user_id|name|mobile|
|---|---|---|
|1|John|123|
|2|Joe|124|

**Orders Table:**  

|order_id|user_id|total|created_at|
|---|---|---|---|
|1|1|500|2022-12-19 18:32:00|
|2|1|800|2021-12-03 08:32:00|
|3|2|50|2020-12-13 12:49:00|
|4|1|80|2021-12-15 21:19:00|

So to get the list of orders with names and mobile nos. for each order, we can join `orders` and `users` on the basis of `user_id`.  

```sql
SELECT 
   o.*, 
   u.name, 
   u.mobile 
FROM
 ordes o 
 JOIN users u ON o.user_id = u.user_id;
```

<div align="right">
    <b><a href="#table-of-contents">↥ back to top</a></b>
</div>

## Q. Explain the different types of joins?

Using Join in a query, we can retrieve referenced columns or rows from multiple tables.

Following are different types of Joins:

1. JOIN: Return details from tables if there is at least one matching row in both tables.
2. LEFT JOIN: It will return all rows from the left table, even if there are no matching row in the right table.
3. RIGHT JOIN: It will return all rows from the right table, even if there is no matching row in the left table.
4. FULL JOIN: It will return rows when there is a match in either of tables.

<div align="right">
    <b><a href="#table-of-contents">↥ back to top</a></b>
</div>

## Q. What are Self Join and Cross Join?

- When we want to join a table to itself then SELF JOIN is used.
- We can give one or more aliases to eliminate the confusion.
- A self join can be used as any type, if both the tables are same.
- The simple example where we can use SELF JOIN is if in a company have a hierarchal reporting structure and an employee reports to another.
- A cross join give the number of rows in the first table multiplied by the number of rows in second table.
- The simple example where we can use CROSS JOIJ is if in an organization wants to combine every Employee with family table to see each Employee with each family member.

<div align="right">
    <b><a href="#table-of-contents">↥ back to top</a></b>
</div>

## Q. How to query data from multiple tables?

|Sl.No|Query            | Description                                       |
|-----|-----------------|---------------------------------------------------|
| 01. |SELECT c1, c2 FROM t1 INNER JOIN t2 on condition|Select columns c1 and c2 from a table named t1 and perform an inner join between t1 and t2  |
| 02. |SELECT c1, c2 FROM t1 LEFT JOIN t2 on condition|Select columns c1 and c2 from a table named t1 and perform a left join between t1 and t2|
| 03. |SELECT c1, c2 FROM t1 RIGHT JOIN t2 on condition|Select columns c1 and c2 from a table named t1 and perform a right join between t1 and t2|
| 04. |SELECT c1, c2 FROM t1 FULL OUTER JOIN t2 on condition|Select columns c1 and c2 from a table named t1 and perform a full outer join between t1 and t2|
| 05. |SELECT c1, c2 FROM t1 CROSS JOIN t2 |Select columns c1 and c2 from a table named t1 and produce a Cartesian product of rows in tables|
| 06. |SELECT c1, c2 FROM t1, t2 |Select columns c1 and c2 from a table named t1 and produce a Cartesian product of rows in tables|
| 07. |SELECT c1, c2 FROM t1 A INNER JOIN t2 B on condition |Select columns c1 and c2 from a table named t1 and joint it to itself using an INNER JOIN clause|

<div align="right">
    <b><a href="#">↥ back to top</a></b>
</div>

## Q. How do you find third highest salary

```sql
SELECT * from employees order by salary limit 2,1;
```

<div align="right">
    <b><a href="#table-of-contents">↥ back to top</a></b>
</div>

## Q. What is difference between CHAR and VARCHAR in MySQL?

Both of them are used for string type data. `char` has fixed length and if the inserted data is less than the defined length, required no. of blank spaces are added as padding. `varchar` has variable length and no padding is used to fill up the left out space. So technically, varchar will save space.

<div align="right">
    <b><a href="#table-of-contents">↥ back to top</a></b>
</div>

## Q. What are the two principles of relational database model?

The two principal rules for the relational model are as follows:

- Entity integrity: this is used to maintain the integrity at entity level
- Referential integrity: it is used to maintain integrity on all the values which have been referenced.

The differences between them are as follows:

- Entity integrity tells that in a database every entity should have a unique key; on the other hand referential integrity tells that in the database every table values for all foreign keys will remain valid.
- Referential integrity is based on entity integrity but it is not the other way around.
- For example: if a table is present and there is a set of column out of which one column has parent key set then to ensure that the table doesn'\t contain any duplicate values, a unique index is defined on the column that contains the parent key.

<div align="right">
    <b><a href="#table-of-contents">↥ back to top</a></b>
</div>

## Q. What is the difference between primary and foreign key?

- Primary key uniquely identify a relationship in a database, whereas foreign key is the key that is in other relation and it has been referenced from the primary key from other table.
- Primary key remains one only for the table, whereas there can be more than one foreign key.
- Primary key is unique and won'\t be shared between many tables, but foreign key will be shared between more than one table and will be used to tell the relationship between them.

<div align="right">
    <b><a href="#table-of-contents">↥ back to top</a></b>
</div>

## Q. Why stored procedures are called as executable code?

Stored procedure stored inside the database. This also includes the executable code that usually collects and customizes the operations like insert, encapsulation, etc. These stored procedures are used as APIs for simplicity and security purposes. The implementation of it allows the developers to have procedural extensions to the standard SQL syntax. Stored procedure doesn'\t come as a part of relational database model, but can be included in many implementations commercially.

<div align="right">
    <b><a href="#table-of-contents">↥ back to top</a></b>
</div>

## Q. What is an index represent in relational database model?

- Index is a way to provide quick access to the data and structure. It has indexes maintain and can be created to combine attributes on a relation. Index allows the queries to filter out the searches faster and matching data can be found earlier with simplicity. 

- For example: It is same as the book where by using the index you can directly jump to a defined section. In relational database there is a provision to give multiple indexing techniques to optimize the data distribution.

<div align="right">
    <b><a href="#table-of-contents">↥ back to top</a></b>
</div>

## Q. What are the relational operations that can be performed on the database?

There are many relational operators that are used to perform actions on relational database. These operators are as follows:

1. Union operator that combines the rows of two relations and doesn'\t include any duplicate. It also removes the duplicates from the result.
2. Intersection operator provides a set of rows that two relations have in common.
3. Difference operator provide the output by taking two relations and producing the difference of rows from first that don'\t exist in second.
4. Cartesian product is done on two relations. It acts as a cross join operator.

<div align="right">
    <b><a href="#table-of-contents">↥ back to top</a></b>
</div>

## Q. What do you understand by database Normalization?

- Normalization is very essential part of relational model. 
- Normal forms are the common form of normalization. 
- It helps in reducing redundancy to increase the information overall. 
- It has some disadvantages as it increases complexity and have some overhead of processing.
- It consists of set of procedures that eliminates the domains that are non-atomic and redundancy of data that prevents data manipulation and loss of data integrity.

<div align="right">
    <b><a href="#table-of-contents">↥ back to top</a></b>
</div>

## Q. What are the different types of normalization that exists in the database?

There are 9 normalizations that are used inside the database. These are as follows:

1. First normal form: in this table represents a relation that has no repeating groups.
2. Second normal form: non- prime attributes are not functional dependent on subset of any candidate key.
3. Third normal form: in a table every non- prime attribute is non-transitively dependent on every candidate key
4. Elementary key normal form: superkey dependency or elementary key dependency effects the functional dependency in a table.
5. Boyce codd normal form: “every non-trivial functional dependency in the table is dependent on superkey”.
6. Fourth normal form: “Every non-trivial multivalued dependency in the table is a dependent on a superkey”.
7. Fifth normal form (5NF): “Every non-trivial join dependency in the table is implied by the superkeys of the table”.
8. Domain/key normal form (DKNF): “Every constraint on the table is a logical consequence of the table's domain constraints and key constraints”.
9. Sixth normal form (6NF): “Table features no non-trivial join dependencies at all”.

<div align="right">
    <b><a href="#table-of-contents">↥ back to top</a></b>
</div>

## Q. How de-normalization is different from normalization?

- Analytical processing databases are not very normalized. The operations which are used are read most databases. 
- It is used to extract the data that are ancient and accumulated over long period of time. For this purpose de-normalization occurs that provide smart business applications.
- Dimensional tables in star schema are good example of de-normalized data. 
- The de-normalized form must be controlled while extracting, transforming, loading and processing. 
- There should be constraint that user should not be allowed to view the state till it is consistent.
- It is used to increase the performance on many systems without RDBMS platform.

<div align="right">
    <b><a href="#table-of-contents">↥ back to top</a></b>
</div>

## Q. What is the type of de-normalization?

Non-first normal form (NFA) 

– It describes the definition of the database design which is different from the first normal form.
- It keeps the values in structured and specialized types with their own domain specific languages. 
- The query language used in this is extended to incorporate more support for relational domain values by adding more operators.

<div align="right">
    <b><a href="#table-of-contents">↥ back to top</a></b>
</div>

## Q. How many levels of data abstraction are available?

There are three levels of data abstraction available in database model and these are as follows:

1. Physical level: It is the lowest level that describes how data is stored inside the database.
2. Logical level: It is the next higher level in the hierarchy that provides the abstraction. It describes what data are stored and the relationship between them.
3. View level: It is the highest level in hierarchy that describes part of the entire database. It allows user to view the database and do the query.

<div align="right">
    <b><a href="#table-of-contents">↥ back to top</a></b>
</div>

## Q. What do you understand by Data Independence?

Data independence tells about the independence of the data inside the application. It usually deals with the storage structure and represents the ability to modify the schema definition. It doesn'\t affect the schema definition which is being written on the higher level. 

There are two types of data independence:

1. Physical data independence: It allows the modification to be done in physical level and doesn'\t affect the logical level.
2. Logical data independence: It allow the modification to be done at logical level and affects the view level. 

NOTE: Logical Data Independence is more difficult to achieve.

<div align="right">
    <b><a href="#table-of-contents">↥ back to top</a></b>
</div>

## Q. How view is related to data independence?

- View is a virtual table that doesn'\t really exist, but it remains present so that user can view their data.
- It is derived from the base table. The view is stored in the data dictionary and represents the file directly. 
- The base table updation or reconstruction is not being reflected in views.
- It is related to the logical data independence as it is at the logical level and not at the physical level.

<div align="right">
    <b><a href="#table-of-contents">↥ back to top</a></b>
</div>

## Q. Why E-R models are used?

E-R model stands for entity-relationship model and it is used to represent a model with their relationships. This is an object oriented approach and it is based on real world that consists of objects which are called entities and relationship between them. Entities are further used inside the database in the form of attributes.

<div align="right">
    <b><a href="#table-of-contents">↥ back to top</a></b>
</div>

## Q. What is the purpose of acid properties?

- ACID stands for Atomicity, Consistency, Isolation and durability and it plays an important role in the database. 
- These properties allow the database to be more convenient to access and use. This allows data to be shared more safely in between the tables.
- If these properties are not being implemented then the data will become inconsistent and inaccurate. 
- It helps in maintaining the accuracy of the data in the database.

<div align="right">
    <b><a href="#table-of-contents">↥ back to top</a></b>
</div>

## Q. What do you understand by cardinality and why it is used?

- Cardinality is important and used to arrange the data inside the database. 
- It is related to the design part and need to be properly used in database. 
- It is used in E-R diagrams and used to show the relationship between entities/tables. 
- It has many forms like the basic is one to one, which associate one entity with another.
- Second is one to many: which relates one entity with many entities in a table.
- Third is many to many M: N that allows many entities to be related to many more.
- Last is many to one that allows the many entities to be associated with one entity.

<div align="right">
    <b><a href="#table-of-contents">↥ back to top</a></b>
</div>

## Q. What is Index?

- A pointer to data having physical representation is called as Index.
- Record can be located quickly and efficiently by creating Indices on existing tables.
- Each index in a table has some valid name and we can have more than one index in different columns of a table.
- We can speed up queries by setting up index in a column of a table.
- In a table , each row is examined by sql server to fulfil our query is known as table scan and it only happen when there is no index available to help the query.
- On large tables, the table scan has huge impact on performance.
- Clustered and Non clustered indexes are the most widely used indexes in a database.

<div align="right">
    <b><a href="#table-of-contents">↥ back to top</a></b>
</div>

## Q. What is Trigger?

- A Trigger is a process of firing an action when some event like Insert, Update or Delete occurs.
- A trigger can'\t be called or even executed rather they are automatically become active by the DBMS whenever some modification in associated table occur.
- Triggers are event driven and can attached to particular table in a database.
- Triggers are implicitly executed and stored procedures are also executed by triggers.
- Referential integrity is maintained by the trigger and they are managed and stored by DBMS.
- Triggers can be nested also, in which Insert, Update or Delete logic can be fired from the trigger itself.

<div align="right">
    <b><a href="#table-of-contents">↥ back to top</a></b>
</div>

## Q. What is a NOLOCK?

- NOLOCK is used to improve concurrency on a busy system.
- On data read, no lock can be taken on SELECT statement.
- When some other process is updating the data on the same time you are reading it is known as dirty read.
- Read (Shared) locks are taken by SELECT Statements.
- Simultaneous access of multiple SELECT statements is allowed in Shared lock but modification process is not allowed.
- The result to your system is blocking.
- Update will start on completion of all the reads.

<div align="right">
    <b><a href="#table-of-contents">↥ back to top</a></b>
</div>

## Q. What is the STUFF function and how does it differ from the REPLACE function?

- Using STUFF function we can overwrite the specified characters of a string.
The syntax of STUFF function is:
STUFF (stringToChange, startIndex, length, new_characters )

where stringToChange is the string which will have the characters those we want to overwrite, startIndex is the starting position, length is the number of characters in the string that are to be overwrited, and new_characters are the new characters to write into the string.

- While REPLACE function is used to replace specified character at all its existing occurrences.
- The syntax of REPLACE function is REPLACE (string_to_change, string_to_Replace, new_tring).
- Every occurrence of string_to_change will be replaced by new_string.

<div align="right">
    <b><a href="#table-of-contents">↥ back to top</a></b>
</div>

## Q. What are the advantages of using Stored Procedures?

- Procedure can reduce network traffic and latency, and can enhance application performance.
- Procedure execution plans can be reused, staying cached in the management tool's memory, reducing its overhead.
- Procedures provide the benefit of code reuse.
- The logic can be encapsulated using procedures and can help to change procedure's code without interacting to application.
- Procedures give more security to our data.

<div align="right">
    <b><a href="#table-of-contents">↥ back to top</a></b>
</div>

## Q. What is RANK function?

- RANK function can be used to give a rank to each row returned from a SELECT statment.
- For using this function first specify the function name, followed by the empty parentheses.
- Then mention the OVER function. For this function, you have to pass an ORDER BY clause as an argument. The clause identifies the column on which you are going to apply the RANK function.

For Example:
SELECT RANK() OVER(ORDER BY BirthDate DESC) AS [RowNumber], FirstName, BirthDate FROM EmpDetails
- In the result you will see that the eldest employee got the first rank and the youngest employee got the last rank. Here the rows with equal age will get same ranks.
- The rank depends on the row's position in the result set, but not on the sequential number of the row.

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

## Q. What is difference between Truncate and Delete in SQL?

* TRUNCATE is a DDL (data definition language) command whereas DELETE is a DML (data manipulation language) command.
* We can'\t execute a trigger with TRUNCATE whereas with DELETE command, a trigger can be executed.
* We can use any condition in WHERE clause using DELETE but it is not possible with TRUNCATE.
* If table is referenced by any foreign key constraints then TRUNCATE cannot work.
* TRUNCATE is faster than DELETE, because when you use DELETE to delete the data, at that time it store the whole data in rollback space from where you can get the data back after deletion, whereas TRUNCATE will not store data in rollback space and will directly delete it. You can'\t get the deleted data back when you use TRUNCATE.

<div align="right">
    <b><a href="#table-of-contents">↥ back to top</a></b>
</div>

## Q. What are COMMIT and ROLLBACK in SQL?

COMMIT statement is used to end the current transaction and once the COMMIT statement is exceucted the transaction will be permanent and undone.


**Example:**:

```sql
BEGIN
UPDATE EmpDetails SET EmpName = ‘Arpit’ where Dept = ‘Developer’
COMMIT;
END;
```

-ROLLBACK statement is used to end the current transaction and undone the changes which was made by that transaction.
- Syntax: ROLLBACK [TO] Savepoint_name;

**Example:**:

```sql
BEGIN
Statement1;
SAVEPOINT mysavepoint;
BEGIN
Statement2;
EXCEPTION
WHEN OTHERS THEN
ROLLBACK TO mysavepoint;
Statement5;
END;
END;
```

<div align="right">
    <b><a href="#table-of-contents">↥ back to top</a></b>
</div>

## Q. What is a WITH(NOLOCK)?

- WITH(NOLOCK) is used to unlock the data which is locked by the transaction that is not yet committed. This command is used before SELECT statement.
- When the transaction is committed or rolled back then there is no need to use NOLOCK function because the data is already released by the committed transaction.
- Syntax: WITH(NOLOCK)

**Example:**:

```sql
SELECT * FROM EmpDetails WITH(NOLOCK)
WITH(NOLCOK) is similar as READ UNCOMMITTED.
```

<div align="right">
    <b><a href="#table-of-contents">↥ back to top</a></b>
</div>

## Q. What is difference between Co-related sub query and nested sub query?

- Correlated subquery executes single time for every row which is selected by the outer query.
- It has a reference to a value from the row selected by the outer query.
- Nested subquery executes only once for the entire nesting (outer) query. It does not contain any reference to the outer query row.

- For example,
- Correlated Subquery:
select e.EmpFirstName, e.Salary, e.DeptId from Employee e where e.Salary = (select max(Salary) from Employee ee where ee.DeptId = e.DeptId)

- Nested Subquery:
select EmpFirstName, Salary, DeptId from Employee where (DeptId, Salary) in (select DeptId, max(Salary) from Employee group by DeptId)

<div align="right">
    <b><a href="#table-of-contents">↥ back to top</a></b>
</div>

## Q. Differentiate UNION, MINUS, UNION ALL and INTERSECT?

- INTERSECT - It will give all the distinct rows from both select queries.
- MINUS - It will give distinct rows returned by the first query but not by the second query.
- UNION - It will give all distinct rows selected by either first query or second query.
- UNION ALL - It will give all rows returned by either query with all duplicate records.

<div align="right">
    <b><a href="#table-of-contents">↥ back to top</a></b>
</div>

## Q. What is DDL, DML and DCL?

SQL commands can be divided in three large subgroups.

1) DDL: The SQL commands which deals with database schemas and information of how the data will be generated in database are classified as Data Definition Language.
-For example: CREATE TABLE or ALTER TABLE belongs to DDL.

2) DML: The SQL commands which deals with data manipulation are classified as Data Manipulation Language.
For example: SELECT, INSERT, etc.

3) DCL: The SQL commands which deal with rights and permission over the database are classified as DCL.
For example: GRANT, REVOKE

<div align="right">
    <b><a href="#table-of-contents">↥ back to top</a></b>
</div>

## Q. What are the reasons of poor performance of query?

Following are the reasons for the poor performance of a query:

- No indexes.
- Excess recompilations of stored procedures.
- Procedures and triggers without SET NOCOUNT ON.
- Poorly written query with unnecessarily complicated joins.
- Highly normalized database design.
- Excess usage of cursors and temporary tables.
- Queries with predicates that use comparison operators between different columns of the same table.
- Queries with predicates that use operators, and any one of the following are true: 
- There are no statistics on the columns involved on either side of the operators.
- The distribution of values in the statistics is not uniform, but the query seeks a highly selective value set. This situation can be especially true if the operator is anything other than the equality (=) operator.
- The predicate uses the not equal to (!=) comparison operator or the NOT logical operator.
- Queries that use any of the SQL Server built-in functions or a scalar-valued, user-defined function whose argument is not a constant value.
- Queries that involve joining columns through arithmetic or string concatenation operators.
- Queries that compare variables whose values are not known when the query is compiled and optimized.

<div align="right">
    <b><a href="#table-of-contents">↥ back to top</a></b>
</div>

## Q. What are the MySQL Engines?

**1. InnoDB:**

The default storage engine in MySQL 8.0. InnoDB is a transaction-safe (ACID compliant) storage engine for MySQL
that has commit, rollback, and crash-recovery capabilities to protect user data. InnoDB row-level locking
(without escalation to coarser granularity locks) and Oracle-style consistent nonlocking reads increase multi-user 
concurrency and performance. InnoDB stores user data in clustered indexes to reduce I/O for common queries based on primary keys.

To maintain data integrity, InnoDB also supports FOREIGN KEY referential-integrity constraints. 

**2. MyISAM:**

These tables have a small footprint. Table-level locking limits the performance in read/write workloads, so it is often used in read-only or read-mostly workloads in Web and data warehousing configurations.

**3. Memory:**

Stores all data in RAM, for fast access in environments that require quick lookups of non-critical data. This engine 
was formerly known as the HEAP engine. Its use cases are decreasing; InnoDB with its buffer pool memory area provides a 
general-purpose and durable way to keep most or all data in memory, and NDBCLUSTER provides fast key-value lookups for huge distributed data sets.

**4. CSV:**

Its tables are really text files with comma-separated values. CSV tables let you import or dump data in CSV format, to exchange data with scripts and applications that read and write that same format. Because CSV tables are not indexed, you typically keep the data in InnoDB tables during normal operation, and only use CSV tables during the import or export stage.

**5. Archive:**

These compact, unindexed tables are intended for storing and retrieving large amounts of seldom-referenced historical, archived, or security audit information.

**6. Blackhole:**

The Blackhole storage engine accepts but does not store data, similar to the Unix /dev/null device. Queries always return an empty set. These tables can be used in replication configurations where DML statements are sent to slave servers, but the master server does not keep its own copy of the data.

**7. NDB:**

This clustered database engine is particularly suited for applications that require the highest possible degree 
of uptime and availability.

**8. Merge:**

Enables a MySQL DBA or developer to logically group a series of identical MyISAM tables and reference them as one object. Good for VLDB environments such as data warehousing.

**9. Federated:**

Offers the ability to link separate MySQL servers to create one logical database from many physical servers. Very good for distributed or data mart environments.

**10. Example:**

This engine serves as an example in the MySQL source code that illustrates how to begin writing new storage engines. 
It is primarily of interest to developers. The storage engine is a “stub” that does nothing. You can create tables with this engine, but no data can be stored in them or retrieved from them.

<div align="right">
    <b><a href="#table-of-contents">↥ back to top</a></b>
</div>

## Q. What are the reporting aggregate functions available in SQL?

In database management, an aggregate function is a function where the values of multiples rows are grouped to form a single value.

|Sl.No |Function   | Description                                       |
|------|-----------|---------------------------------------------------|
|  01. |COUNT	   |Return the number of rows in a certain table/view  |
|  02. |SUM	   |Accumulate the values|
|  03. |AVG	   |Returns the average for a group of values|
|  04. |MIN	   |Returns the smallest value of the group|
|  05. |MAX	   |Returns the largest value of the group|

<div align="right">
    <b><a href="#">↥ back to top</a></b>
</div>

## Q. Explain SQL Operators?

|Sl.No|Query                                           | Description                                       |
|-----|------------------------------------------------|---------------------------------------------------|
| 01. |SELECT c1 FROM t1 UNION [ALL] SELECT c1 FROM t2 |Select column c1 from a table named t1 and column c1 from a table named t2 and combine the rows from these two queries |
| 02. |SELECT c1 FROM t1 INTERSECT SELECT c1 FROM t2 |Select column c1 from a table named t1 and column c1 from a table named t2 and return the intersection of two queries |
| 03. |SELECT c1 FROM t1 MINUS SELECT c1 FROM t2 |Select column c1 from a table named t1 and column c1 from a table named t2 and subtract the 2nd result set from the 1st|
| 04. |SELECT c1 FROM t WHERE c1 [NOT] LIKE pattern |Select column c1 from a table named t and query the rows using pattern matching % |
| 05. |SELECT c1 FROM t WHERE c1 [NOT] in test_list |Select column c1 from a table name t and return the rows that are (or are not) in test_list |
| 06. |SELECT c1 FROM t WHERE c1 BETWEEN min AND max |Select column c1 from a table named t and return the rows where c1 is between min and max|
| 07. |SELECT c1 FROM t WHERE c1 IS [NOT] NULL|Select column c1 from a table named t and check if the values are NULL or not |

<div align="right">
    <b><a href="#">↥ back to top</a></b>
</div>

## Explain data modification commands in SQL?

|Sl.No|Query            | Description                                       |
|-----|-----------------|---------------------------------------------------|
| 01. |INSERT INTO t(column_list) VALUES(value_list)|Insert one row into a table named t|
| 02. |INSERT INTO t(column_list) VALUES (value_list), (value_list), … |Insert multiple rows into a table named t|
| 03. |INSERT INTO t1(column_list) SELECT column_list FROM t2 |Insert rows from t2 into a table named t1|
| 04. |UPDATE tSET c1 = new_value	|Update a new value in table t in the column c1 for all rows|
| 05. |UPDATE tSET c1 = new_value, c2 = new_value WHERE condition|Update values in column c1 and c2 in table t that match the condition|
| 06. |DELETE FROM t |Delete all the rows from a table named t|
| 07. |DELETE FROM tWHERE condition	|Delete all rows from that a table named t that match a certain condition|

<div align="right">
    <b><a href="#">↥ back to top</a></b>
</div>

## Q. What is Views in SQL?

A view is a virtual table that is a result of a query. They can be extremely useful and are often used as a security mechanism, letting users access the data through the view, rather than letting them access the underlying base table:

|Sl.No|Query                                                     | Description                                       |
|-----|----------------------------------------------------------|---------------------------------------------------|
| 01. |CREATE VIEW view1 AS SELECT c1, c2 FROM t1 WHERE condition|Create a view, comprising of columns c1 and c2 from a table named t1 where a certain condition has been met.|

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
    <b><a href="#">↥ back to top</a></b>
</div>

## Basic Queries

**01. Import ".sql" file from command prompt:**

```sql
SOURCE C://database.sql;
```

<div align="right">
    <b><a href="#">↥ back to top</a></b>
</div>

**02. MySQL Performance Queries:**

```sql
OPTIMIZE TABLE table_name;

--Displays description of the table
SHOW TABLE STATUS;  
DESC table_name;
SHOW VARIABLES;
SHOW STATUS;
SHOW GLOBAL STATUS;
SHOW TABLES FROM INFORMATION_SCHEMA;
EXPLAIN SELECT * FROM table_name
SHOW TABLE STATUS FROM database_name;

--Shows you which threads are running
SHOW FULL PROCESSLIST;  

--IP Address of the Mysql Host
SHOW VARIABLES WHERE Variable_name = 'hostname';  
```

<div align="right">
    <b><a href="#">↥ back to top</a></b>
</div>

**04. Table Related Queries:**

```sql
SELECT max(RIGHT(`field_name`,4)) FROM `table_name`;

-- Converts to upper case
SELECT UCASE(column_name) FROM table_name;  

--Select nearest value
SELECT * FROM TABLE ORDER BY ABS(VALUE - $MYVALUE) LIMIT 1 
SELECT sentence, wordcount(sentence) as "Words" from test;

--Useful in pagination
SELECT * FROM table_name ORDER BY field_name LIMIT 5 OFFSET 5;  

--Find duplicate entries
SELECT *,  COUNT(field_name)  FROM table_name GROUP BY field_name HAVING ( COUNT(field_name) > 1 ) 

ALTER TABLE table_name AUTO_INCREMENT =1
ALTER TABLE `table_name` DROP PRIMARY KEY 
ALTER TABLE `table_name` ENGINE = InnoDB
ALTER TABLE table_name CHANGE `id` `id` INT( 11 ) NOT NULL AUTO_INCREMENT 
ALTER TABLE `table_name` ADD `id` INT NOT NULL AUTO_INCREMENT PRIMARY KEY FIRST ;
ALTER TABLE table_name ADD column_name datatype AFTER column_name 
ALTER TABLE table_name DROP COLUMN column_name  
ALTER TABLE table_name MODIFY column_name datatype
ALTER TABLE table_name CHANGE oldname newname datatype

RENAME TABLE `table_name_old` TO `table_name_new`

--Update particular character
UPDATE mytable SET city = REPLACE(city, 'ï', 'i')   

--Swaping field value
UPDATE swap_test SET x=y, y=@temp where @temp:=x;   

--COPYING
UPDATE table_name SET field_name1=field_name2;      
UPDATE table_name SET field_name = UPPER(field_name)

TRUNCATE TABLE table_name;
DROP TABLE table_name;
```

<div align="right">
    <b><a href="#">↥ back to top</a></b>
</div>

**05. Date and time:**

```sql
SHOW VARIABLE LIKE '%time_zone%';

--Current timestamp
SELECT NOW(); 

--Current day
SELECT DAYNAME(NOW()); 

--Subtract time
SELECT SUBTIME('1:30:00', '00:15:00'); 

--Date Format 
SELECT DATE_FORMAT(NOW(), '%W, %D of %M, %Y'); 
SELECT TIMEDIFF('2007-10-05 12:10:18','2007-10-05 16:14:59') AS length;
SELECT * FROM `table_name` WHERE DATE_FORMAT(field_name, "%Y-%m-%d") = '2010-01-01'"
```

<div align="right">
    <b><a href="#">↥ back to top</a></b>
</div>

**06. MySQL Miscellaneous Queries:**

```sql
--Use to generate unique id
SELECT uuid();  

--Get numeric values 
SELECT * FROM `TABLENAME` WHERE `field` REGEXP '^-?[0-9]+$' 

--w3resource.com
SELECT CONCAT('w3resource','.','com'); 

--bit datatype
CREATE TABLE table_bit (id SERIAL, a BIT(3), b BIT(8), c BIT(16)); 

--Enum datatype
CREATE TABLE table_enum (id SERIAL, status ENUM('Active', 'Deactive'));

--Get the length 
SELECT CHAR_LENGTH(field_name) AS Length FROM `table_name`; 
SELECT * FROM `table_name` WHERE LENGTH(field_name) < 10

--Copying the previous rows to the next rows
INSERT INTO table_name (`col1`, `col2`, `col3`, `...`, `coln`) SELECT `col1`, `col2`, `col3`, `...`, `coln` FROM table_name 
SELECT COUNT(DISTINCT column) FROM table;
SELECT field_name, LEFT(field_name, 3), RIGHT(field_name, 3), MID(field_name, 2, 3) FROM `table_name`;

--Flow control with CASE
SELECT CASE WHEN a THEN 'true' ELSE 'false' END AS boolA, CASE WHEN b THEN 'true' ELSE 'false' END AS boolB FROM table_name; 
```

<div align="right">
    <b><a href="#">↥ back to top</a></b>
</div>

## Q. What is Stored Routine in SQL?

A stored routine is a set of SQL statements that are stored on the database server and can be used by any client 
with permission to use them. This provides a number of benefits. 

1. Database operations are normalized so various applications will operate uniformly, even when written in different 
   languages and operating on different platforms.
2. Stored routines are easy to maintain, because they're all in one place rather than distributed among different applications.
3. Traffic is reduced between the client and server, because data is processed on the server.
4. security is enhanced by allowing clients to run with reduced permissions while still being able to perform necessary
database operations.

There are two different kinds of stored routines.

a) Stored functions return a value, and are used in the context of an expression.
b) Stored procedures are called separately, using the call statement, and may return result sets or set variables. 

**Example 01:** Stored Functions

```sql
DROP FUNCTION IF EXISTS track_len;

CREATE FUNCTION track_len(seconds INT)
RETURNS VARCHAR(16) DETERMINISTIC
    RETURN CONCAT_WS(':', seconds DIV 60, LPAD(seconds MOD 60, 2, '0' ));

SELECT title, track_len(duration) FROM track;

SELECT a.artist AS artist,
    a.title AS album,
    t.title AS track,
    t.track_number AS trackno,
    track_len(t.duration) AS length
  FROM track AS t
  JOIN album AS a
    ON a.id = t.album_id
  ORDER BY artist, album, trackno
;
```

**Example 02:** Stored Procedures

```sql
DROP PROCEDURE IF EXISTS list_albums;

DELIMITER //
CREATE PROCEDURE list_albums ()
BEGIN
    SELECT * FROM album;
END
//

DELIMITER ;
CALL list_albums();
```

**Example 03:** Stored Procedures with parameter

```sql
DROP PROCEDURE IF EXISTS list_albums;

DELIMITER //
CREATE PROCEDURE list_albums (a VARCHAR(255))
  BEGIN
    SELECT a.artist AS artist,
        a.title AS album,
        t.title AS track,
        t.track_number AS trackno,
        track_len(t.duration) AS length
      FROM track AS t
      JOIN album AS a
        ON a.id = t.album_id
      WHERE a.artist LIKE a
      ORDER BY artist, album, trackno
    ;
  END //

DELIMITER ;
CALL list_albums('%hendrix%');
```

**Example 04:** Drop Stored Procedures & Stored Functions

```sql
DROP FUNCTION IF EXISTS track_len;
DROP PROCEDURE IF EXISTS total_duration;
```

<div align="right">
    <b><a href="#">↥ back to top</a></b>
</div>

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
    <b><a href="#">↥ back to top</a></b>
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
    <b><a href="#">↥ back to top</a></b>
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
    <b><a href="#">↥ back to top</a></b>
</div>

#### Q. Give string types available for column
#### Q. What are the nonstandard string types
#### Q. What are all the Common SQL Function
#### Q. How to prevent from database attacks/SQL Injection
#### Q. How many TRIGGERS are possible in MySql
#### Q. What are Heap tables
#### Q. What is the difference between BLOB AND TEXT
#### Q. Explain advantages of MyISAM over InnoDB
#### Q. What are the differences between MySQL_fetch_array(), MySQL_fetch_object(), MySQL_fetch_row()
#### Q. How to find the unique values if the value in the column is repeated
#### Q. How to use REGEXP in SQL Query?
#### Q. What are the types of indexes in sql?
#### Q. Explain SELECT, LIKE, IN, Regular-Expression, Datatypes, Sub-Query in mySQL
#### Q. Explain Stored Procedure, View, Event, triggers
#### Q. Explain Transaction in SQL?
#### Q. What is difference between procedures and triggers
#### Q. What is the default index created on primary key in sql server?
#### Q. How to test performance of database?

<div align="right">
    <b><a href="#table-of-contents">↥ back to top</a></b>
</div>
