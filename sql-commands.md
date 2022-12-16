# SQL Commands 

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

## COUNT

```sql
SELECT COUNT(column_name)
FROM table_name;
```

`COUNT()` is a function that takes the name of a column as an argument and counts the number of rows where the column is not `NULL`.

<div align="right">
    <b><a href="#">↥ back to top</a></b>
</div>

## CREATE TABLE

```sql
CREATE TABLE table_name (column_1 datatype, column_2 datatype, column_3 datatype);
```

`CREATE TABLE` creates a new table in the database. It allows you to specify the name of the table and the name of each column in the table.

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

## INSERT

```sql
INSERT INTO table_name (column_1, column_2, column_3) VALUES (value_1, 'value_2', value_3);
```

`INSERT` statements are used to add a new row to a table.

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

## LIMIT

```sql
SELECT column_name(s)
FROM table_name
LIMIT number;
```

`LIMIT` is a clause that lets you specify the maximum number of rows the result set will have.

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

## SUM

```sql
SELECT SUM(column_name)
FROM table_name;
```

`SUM()` is a function that takes the name of a column as an argument and returns the sum of all the values in that column.

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
