
# MySQL Queries

## Basic Keywords

|Sl.No |Keyword   | Description                                       |
|------|----------|---------------------------------------------------|
|  01. |SELECT	  |Used to state which columns to query. Use * for all|
|  02. |FROM 	  |Declares which table/view etc to select from|
|  03. |WHERE	  |Introduces a condition|
|  04. |=	  |Used for comparing a value to a specified input|
|  05. |LIKE	  |Special operator used with the WHERE clause to search for a specific pattern in a column|
|  06. |GROUP BY  |Arranges identical data into groups|
|  07. |HAVING	  |Specifies that only rows where aggregate values meet the specified conditions should be returned. Used because the WHERE keyword cannot be used with aggregate functions|
|  08. |INNER JOIN|Returns all rows where key record of one table is equal to key records of another|
|  09. |LEFT JOIN |Returns all rows from the ‘left’ (1st) table with the matching rows in the right (2nd)|
|  10. |RIGHT JOIN|Returns all rows from the ‘right’ (2nd) table with the matching rows in the left (1st)|
|  11. |FULL OUTER JOIN|Returns rows that match either in the left or right table|

<div align="right">
    <b><a href="#">↥ back to top</a></b>
</div>

## Reporting Aggregate functions

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

## Querying data from a table

|Sl.No |Query            | Description                                       |
|------|-----------------|---------------------------------------------------|
| 01.  |SELECT c1 FROM t |Select data in column c1 from a table named t      |
| 02.  |SELECT * FROM t	 |Select all rows and columns from a table named t   |
| 03.  |SELECT c1 FROM t WHERE c1 = ‘test’|Select data in column c1 from a table named t where the value in c1 = ‘test’
| 05.  |SELECT c1 FROM t ORDER BY c1 ASC (DESC)|Select data in column c1 from a table name t and order by c1, either in ascending (default) or descending order |
| 07.  |SELECT c1 FROM t ORDER BY c1LIMIT n OFFSET offset|Select data in column c1 from a table named t and skip offset of rows and return the next n rows|
| 08.  |SELECT c1, aggregate(c2) FROM t GROUP BY c1|Select data in column c1 from a table named t and group rows using an aggregate function |
| 09.  |SELECT c1, aggregate(c2) FROM t GROUP BY c1 HAVING condition|Select data in column c1 from a table named t and group rows using an aggregate function and filter these groups using ‘HAVING’ clause|


<div align="right">
    <b><a href="#">↥ back to top</a></b>
</div>

## Querying data from multiple tables

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

## Using SQL Operators

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

## Data modification

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

## Views

A view is a virtual table that is a result of a query. They can be extremely useful and are often used as a security mechanism, letting users access the data through the view, rather than letting them access the underlying base table:

|Sl.No|Query                                                     | Description                                       |
|-----|----------------------------------------------------------|---------------------------------------------------|
| 01. |CREATE VIEW view1 AS SELECT c1, c2 FROM t1 WHERE condition|Create a view, comprising of columns c1 and c2 from a table named t1 where a certain condition has been met.|

<div align="right">
    <b><a href="#">↥ back to top</a></b>
</div>

## Indexes

An index is used to speed up the performance of queries by reducing the number of database pages that have to be visited:

|Sl.No|Query                               | Description                                       |
|-----|------------------------------------|---------------------------------------------------|
| 01. |CREATE INDEX index_nameON t(c1, c2) |Create an index on columns c1 and c2 of the table t |
| 02. |CREATE UNIQUE INDEX index_name ON t(c3, c4) |Create a unique index on columns c3 and c4 of the table t |
| 03. |DROP INDEX index_name |Drop an index |

<div align="right">
    <b><a href="#">↥ back to top</a></b>
</div>

## Stored Procedure

A stored procedure is a set of SQL statements with an assigned name that can then be easily reused and share by multiple programs:

|Sl.No|Query                               | Description                                       |
|-----|------------------------------------|---------------------------------------------------|
| 01. |CREATE PROCEDURE procedure_name  @variable AS datatype = value AS -- Comments SELECT * FROM tGO |Create a procedure called procedure_name, create a local variable and then select from table t|

<div align="right">
    <b><a href="#">↥ back to top</a></b>
</div>

## Triggers

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

**03. Indexing:**

```sql
SHOW INDEX FROM table_name;
ALTER TABLE `table_name` ADD INDEX(`column_name`);
DROP INDEX index_name ON tbl_name;
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

## Stored Routine

```sql
/***
A stored routine is a set of SQL statements that are stored on the database server and can be used by any client 
with permission to use them. This provides a number of benefits. 

1. Database operations are normalized so various applications will operate uniformly, even when written in different 
   languages and operating on different platforms. 
   
2. Stored routines are easy to maintain, because they're all in one place rather than distributed among different applications.

3. Traffic is reduced between the client and server, because data is processed on the server.

4. security is enhanced by allowing clients to run with reduced permissions while still being able to perform necessary 
   database operations. 
   
There are also some disadvantages. 

1. Migration to a different server platform can be difficult as stored routines tend to use a lot of platform specific 
   features and codes. 
   
2. stored procedures can be difficult to debug and maintain. 

There are two different kinds of stored routines. 

a) Stored functions return a value, and are used in the context of an expression.

b) Stored procedures are called separately, using the call statement, and may return result sets or set variables. 

***/



---Example - 01 : Stored Functions

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



---Example - 02 : Stored Procedures

DROP PROCEDURE IF EXISTS list_albums;

DELIMITER //
CREATE PROCEDURE list_albums ()
BEGIN
    SELECT * FROM album;
END
//

DELIMITER ;
CALL list_albums();


---Example - 03 : Stored Procedures with parameter

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


---Example - 03 : Drop Stored Procedures & Stored Functions

DROP FUNCTION IF EXISTS track_len;
DROP PROCEDURE IF EXISTS total_duration;
```

<div align="right">
    <b><a href="#">↥ back to top</a></b>
</div>

## Transactions

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

## Trigger

```sql
-- Example - 01: Updating a table with a trigger


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

## View

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

## Queries

```sql
-- 1> Write a SQL query to find the nth highest salary from employee table. 
-- Example: finding 3rd highest salary from employee table
select * from employee order by salary desc;
--- Limit N-1,1
select distinct salary from employee order by salary desc limit 2, 1;

-- 2> Write a SQL query to find top n records?
-- Example: finding top 5 records from employee table
select * from employee order by salary desc limit 5;

-- 3> Write a SQL query to find the count of employees working in department 'Admin'
select count(*) from employee where department = 'Admin';

-- 4> Write a SQL query to fetch department wise count employees sorted by department count in desc order.
select * from employee;

select department, count(*) as employeecount 
from employee
group by department
order by employeecount desc;

-- 5>  Write a query to fetch only the first name(string before space) from the FullName column of user_name table.
select distinct(substring_index(full_names, ' ', 1)) first_name from user_name;

-- 6> Write a SQL query to find all the employees from employee table who are also managers
select e1.first_name, e2.last_name from employee e1 
join employee e2
on e1.employee_id = e2.manager_id;

-- 7> Write a SQL query to find all employees who have bonus record in bonus table
select * from employee;
select * from bonus;

select * from employee where employee_id in (select employee_ref_id from bonus where employee.employee_id = bonus.employee_ref_id);
-- This can also be used using left join.
select e.* from employee e join bonus b on e.employee_id = b.employee_ref_id;

-- 8> Write a SQL query to find only odd rows from employee table
select * from employee where MOD(employee_id,2)<>0;

-- 9> Write a SQL query to fetch first_name from employee table in upper case
select upper(first_name) as First_Name from employee;

-- 10> Write a SQL query to get combine name (first name and last name) of employees from employee table
select concat(first_name, ' ' ,last_name) as Name from employee;

-- 11> Write a SQL query to print details of employee of employee 'Jennifer' and 'James'.
select * from employee where first_name in ('Jennifer', 'James');

-- 12> Write a SQL query to fetch records of employee whose salary lies between 
select first_name, last_name, salary from employee where salary between 100000 and 500000;

-- 13> Write a SQL query to get records of employe who have joined in Jan 2017
select * from employee;

select first_name, last_name, joining_date from employee where year(joining_date)=2017 and month(joining_date) = 1;
-- incase you have an index on the joining_date column, it will not be used as index is not used when the indexed column is used in a function.
-- So, prefer this query instead which will use a range scan.
select first_name, last_name, joining_date from employee where joining_date between '2017-01-01' and '2017-02-01';

-- 14> Write a SQL query to get the list of employees with the same salary
select e1.first_name, e2.last_name from employee e1, employee e2 where e1.salary = e2.salary and e1.employee_id != e2.employee_id; 

-- 15> Write a SQL query to show all departments along with the number of people working there. 
select * from employee;

select department, count(*) as 'Number of employees' from employee 
group by department 
order by count(department);

-- 16> Write a SQL query to show the last record from a table.
select * from employee where employee_id = (select max(employee_id) from employee);

-- 17> Write a SQL query to show the first record from a table.
select * from employee where employee_id = (select min(employee_id) from employee);

-- 18> Write a SQL query to get last five records from a employee table.
(select * from employee order by employee_id desc limit 5) order by employee_id;

-- 19> Write a SQL query to find employees having the highest salary in each department. 
select first_name, last_name, department, max(salary) as 'Max Salary'from employee group by department order by max(salary);

-- 20> Write a SQL query to fetch three max salaries from employee table.
select distinct salary from employee order by salary desc limit 3 ;
-- OR-----
select distinct Salary from employee e1 WHERE 3 >= (SELECT count(distinct Salary) from employee e2 WHERE e1.Salary <= e2.Salary) order by e1.Salary desc;

-- 21> Write a SQL query to fetch departments along with the total salaries paid for each of them.
select department, sum(salary) as 'Total Salary' from employee group by department order by sum(salary);

-- 22> Write a SQL query to find employee with highest salary in an organization from employee table.
select first_name, last_name from employee where salary = (select max(salary) from employee);

-- 23>     Write an SQL query that makes recommendations using the  pages that your friends liked. 
-- Assume you have two tables: a two-column table of users and their friends, and a two-column table of 
-- users and the pages they liked. It should not recommend pages you already like.

-- 24> write a SQL query to find employee (first name, last name, department and bonus) with highest bonus.
select first_name, last_name, department, max(bonus_amount) from employee e
join bonus b
on e.employee_id = b.employee_ref_id
group by department
order by max(bonus_amount) desc limit 1;

-- 25> write a SQL query to find employees with same salary
select e1.first_name, e1.last_name, e1.salary from employee e1, employee e2
where e1.salary = e2.salary
and e1.employee_id != e2.employee_id;

-- 26> Write SQL to find out what percent of students attend school on their birthday from attendance_events and all_students tables?
select * from all_students;
select * from attendance_events;

select (count(attendance_events.student_id) * 100 / (select count(student_id) from attendance_events)) as Percent
from attendance_events 
join all_students 
on all_students.student_id = attendance_events.student_id
where month(attendance_events.date_event) = month(all_students.date_of_birth)
and day(attendance_events.date_event) = day(all_students.date_of_birth);

-- 27> Given timestamps of logins, figure out how many people on Facebook were active all seven days
--  of a week on a mobile phone from login info table?

select * from login_info;

select a.login_time, count(distinct a.user_id) from 
login_info a
Left join login_info b
on a.user_id = b.user_id
where a.login_time = b.login_time - interval 1 day
group by 1;

-- 28> Write a SQL query to find out the overall friend acceptance rate for a given date from user_action table.
select * from user_action;

select count(a.user_id_who_sent)*100 / (select count(user_id_who_sent) from user_action) as percent
from user_action a
join user_action b
on a.user_id_who_sent = b.user_id_who_sent and a.user_id_to_whom = b.user_id_to_whom
where a.date_action = '2018-05-24' and b.action = "accepted";

-- 29> How many total users follow sport accounts from tables all_users, sport_accounts, follow_relation?
select * from all_users;
select * from sport_accounts;
select * from follow_relation;

select count(distinct c.follower_id) as count_all_sports_followers 
from  sport_accounts a
join all_users b
on a.sport_player_id = b.user_id
join follow_relation c
on b.user_id = c.target_id;

-- 30> How many active users follow each type of sport?

select b.sport_category, count(a.user_id)
from all_users a
join sport_accounts b
on a.user_id = b.sport_player_id
join follow_relation c
on a.user_id = c.follower_id
where a.active_last_month =1
group by b.sport_category;

-- 31> What percent of active accounts are fraud from ad_accounts table?
select * from ad_accounts;

select count(distinct a.account_id)/(select count(account_id) from ad_accounts where account_status= "active") as 'percent' 
from ad_accounts a
join ad_accounts b
on a.account_id = b.account_id
where a.account_status = 'fraud' and b.account_status='active';

-- 32> How many accounts became fraud today for the first time from ad_accounts table?

select count(account_id) 'First time fraud accounts' from (
select distinct a.account_id, count(a.account_status) 
from ad_accounts a
join ad_accounts b
on a.account_id = b.account_id
where b.date = curdate() and a.account_status = 'fraud'
group by account_id
having count(a.account_status) = 1) ad_accnt;

-- 33> Write a SQL query to determine avg time spent per user per day from user_details and event_session_details
select * from event_session_details;
select * from user_details;

select date, user_id, sum(timespend_sec)/count(*) as 'avg time spent per user per day'
from event_session_details
group by 1,2
order by 1;

-- or --

select date, user_id, avg(timespend_sec)
from event_session_details
group by 1,2
order by 1;

-- 34> write a SQL query to find top 10 users that sent the most messages from messages_detail table.
select * from messages_detail;

select user_id, messages_sent
from messages_detail
order by messages_sent desc
limit 10;

-- 35> Write a SQL query to find disctinct first name from full user name from usere_name table
select * from user_name;

select distinct(substring_index(full_names, ' ', 1)) first_name from user_name;

-- 36> You have a table with userID, appID, type and timestamp. type is either 'click' or 'impression'. 
-- Calculate the click through rate from dialoglog table. Now do it in for each app.
-- click through rate is defined as (number of clicks)/(number of impressions)
select * from dialoglog;

select app_id
        , ifnull(sum(case when type = 'click' then 1 else 0 end)*1.0
        / sum(case when type = 'impression' then 1 else 0 end), 0 )AS 'CTR(click through rate)'
from dialoglog
group by app_id;

-- 37> Given two tables Friend_request (requestor_id, sent_to_id, time),  
-- Request_accepted (acceptor_id, requestor_id, time). Find the overall acceptance rate of requests.
-- Overall acceptate rate of requests = total number of acceptance / total number of requests.
select * from friend_request;
select * from request_accepted;

select ifnull(round(
(select count(*) from (select distinct acceptor_id, requestor_id from request_accepted) as A)
/ 
(select count(*) from (select distinct requestor_id, sent_to_id from friend_request ) as B), 2),0
) as basic;

-- 38> from a table of new_request_accepted, find a user with the most friends.
select * from new_request_accepted;

select id from
(
select id, count(*) as count
from (
select requestor_id as id from new_request_accepted
union all
select acceptor_id as id from new_request_accepted) as a
group by 1
order by count desc
limit 1) as table1;

-- 39> from the table count_request, find total count of requests sent and total count of requests sent failed 
-- per country
select * from count_request;

select country_code, Total_request_sent, Total_percent_of_request_sent_failed, 
cast((Total_request_sent*Total_percent_of_request_sent_failed)/100 as decimal) as Total_request_sent_failed
from
( 
select country_code, sum(count_of_requests_sent) as Total_request_sent,
cast(replace(ifnull(sum(percent_of_request_sent_failed),0), '%','') as decimal(2,1)) as Total_percent_of_request_sent_failed
from count_request
group by country_code
) as Table1;

-- 40> create a histogram of duration on x axis, no of users on y axis which is populated by volume in each bucket
-- from event_session_details
select * from event_session_details;

select floor(timespend_sec/500)*500 as bucket,
count(distinct user_id) as count_of_users
from event_session_details
group by 1;

-- 41> Write SQL query to calculate percentage of confirmed messages from two tables : 
-- confirmation_no (phone numbers that facebook sends the confirmation messages to) and 
-- confirmed_no (phone numbers that confirmed the verification)

select round((count(confirmed_no.phone_number)/count(confirmation_no.phone_number))*100, 2)
from confirmation_no
left join confirmed_no
on confirmed_no.phone_number= confirmation_no.phone_number;

-- 42> Write SQL query to find number of users who had 4 or more than 4 interactions on 2013-03-23 date 
-- from user_interaction table (user_1, user_2, date). 
-- assume there is only one unique interaction between a pair of users per day

select * from user_interaction;

select table1.user_id, sum(number_of_interactions) as Number_of_interactions
from
(
select user_1 as user_id, count(user_1) as number_of_interactions from user_interaction
group by user_1
union all
select user_2 as user_id, count(user_2) as number_of_interactions from user_interaction
group by user_2) table1
group by table1.user_id
having sum(number_of_interactions) >= 4;

-- 43> write a sql query to find the names of all salesperson that have order with samsonic from 
-- the table: salesperson, customer, orders

select s.name
from salesperson s
join orders o on s.id = o.salesperson_id
join customer c on o.cust_id = c.id
where c.name = 'Samsonic';

-- 44> write a sql query to find the names of all salesperson that do not have any order with Samsonic from the table: salesperson, customer, orders

select s.Name 
from Salesperson s
where s.ID NOT IN(
select o.salesperson_id from Orders o, Customer c
where o.cust_id = c.ID 
and c.Name = 'Samsonic');

-- 45> Wrie a sql query to find the names of salespeople that have 2  or more orders.
select s.name as 'salesperson', count(o.number) as 'number of orders'
from salesperson s
join orders o on s.id = o.salesperson_id
group by s.name
having count(o.number)>=2;

-- 46> Given two tables:  User(user_id, name, phone_num) and UserHistory(user_id, date, action), 
-- write a sql query that returns the name, phone number and most recent date for any user that has logged in 
-- over the last 30 days 
-- (you can tell a user has logged in if action field in UserHistory is set to 'logged_on')

select user.name, user.phone_num, max(userhistory.date)
from user,userhistory
where user.user_id = userhistory.user_id
and userhistory.action = 'logged_on'
and userhistory.date >= date_sub(curdate(), interval 30 day)
group by user.name;

-- 47> Given two tables:  User(user_id, name, phone_num) and UserHistory(user_id, date, action), 
-- Write a SQL query to determine which user_ids in the User table are not contained in the UserHistory table 
-- (assume the UserHistory table has a subset of the user_ids in User table). Do not use the SQL MINUS statement. 
-- Note: the UserHistory table can have multiple entries for each user_id. 
select user.user_id
from user
left join userhistory
on user.user_id = userhistory.user_id
where userhistory.user_id is null;

-- 48> from a given table compare(numbers int(4)), write a sql query that will return the maximum value 
-- from the numbers without using 
-- sql aggregate like max or min

select numbers
from compare
order by numbers desc
limit 1;

-- 49> Write a SQL query to find out how many users inserted more than 1000 but less than 2000 images in their presentations from event_log table
-- There is a startup company that makes an online presentation software and they have event_log table that records every time a user inserted 
-- an image into a presentation. one user can insert multiple images

select count(*) from 
(select user_id, count(event_date_time) as image_per_user
from event_log
group by user_id) as image_per_user
where image_per_user <2000 and image_per_user>1000;

-- 50> select the most recent login time by values from the login_info table

select * from login_info
where login_time in (select max(login_time) from login_info
group by user_id)
order by login_time desc limit 1;
```

<div align="right">
    <b><a href="#">↥ back to top</a></b>
</div>
