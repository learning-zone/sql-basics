
## MySQL Queries

#### Basic Keywords

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


#### Reporting Aggregate functions

In database management, an aggregate function is a function where the values of multiples rows are grouped to form a single value. 

|Sl.No |Function   | Description                                       |
|------|-----------|---------------------------------------------------|
|  01. |COUNT	   |Return the number of rows in a certain table/view  |
|  02. |SUM	   |Accumulate the values|
|  03. |AVG	   |Returns the average for a group of values|
|  04. |MIN	   |Returns the smallest value of the group|
|  05. |MAX	   |Returns the largest value of the group|


#### Querying data from a table

|Sl.No |Query            | Description                                       |
|------|-----------------|---------------------------------------------------|
| 01.  |SELECT c1 FROM t |Select data in column c1 from a table named t      |
| 02.  |SELECT * FROM t	 |Select all rows and columns from a table named t   |
| 03.  |SELECT c1 FROM t WHERE c1 = ‘test’|Select data in column c1 from a table named t where the value in c1 = ‘test’
| 05.  |SELECT c1 FROM t ORDER BY c1 ASC (DESC)|Select data in column c1 from a table name t and order by c1, either in ascending (default) or descending order |
| 07.  |SELECT c1 FROM t ORDER BY c1LIMIT n OFFSET offset|Select data in column c1 from a table named t and skip offset of rows and return the next n rows|
| 08.  |SELECT c1, aggregate(c2) FROM t GROUP BY c1|Select data in column c1 from a table named t and group rows using an aggregate function |
| 09.  |SELECT c1, aggregate(c2) FROM t GROUP BY c1 HAVING condition|Select data in column c1 from a table named t and group rows using an aggregate function and filter these groups using ‘HAVING’ clause|
