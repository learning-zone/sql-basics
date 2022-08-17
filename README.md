# MySQL Interview Questions

*Click <img src="https://github.com/learning-zone/mysql-interview-questions/blob/master/assets/star.png" width="20" height="20" align="absmiddle" title="Star" /> if you like the project. Pull Request are highly appreciated.*

## Table of Contents

* *[MySQL Queries](mysql-queries.md)*
* *[MySQL Basics](sql-commands.md)*
* *[RDBMS Questions](rdbms-questions.md)*

## Q. What are indexes in a Database? What are the types of indexes?

An index is a database structure that you can use to improve the performance of database activity. A database table can have one or more indexes associated with it. An index is defined by a field expression that you specify when you create the index. Typically, the field expression is a single field name, like EMP_ID.

<div align="right">
    <b><a href="#table-of-contents">↥ back to top</a></b>
</div>

## Q. What are the different tables present in MySQL

Note that MySQL supports two different kinds of tables: transaction-safe tables (InnoDB and BDB) and non-transaction-safe tables (HEAP, ISAM, MERGE, and MyISAM). Advantages of transaction-safe tables (TST): Safer.

<div align="right">
    <b><a href="#table-of-contents">↥ back to top</a></b>
</div>

## Q. Explain JOIN Query in mySQL

A `JOIN` clause is used to combine rows from two or more tables, based on a related column between them.  
Take `users` table and `orders` table for example.  
Users  

|user_id|name|mobile|
|---|---|---|
|1|John|123|
|2|Joe|124|

Orders  

|order_id|user_id|total|created_at|
|---|---|---|---|
|1|1|500|2021-12-19 18:32:00|
|2|1|800|2021-12-03 08:32:00|
|3|2|50|2021-12-13 12:49:00|
|4|1|80|2021-12-15 21:19:00|

So to get the list of orders with names and mobile nos. for each order, we can join `orders` and `users` on the basis of `user_id`.  

```sql
select o.*, u.name, u.mobile from ordes o join users u on o.user_id = u.user_id;
```

<div align="right">
    <b><a href="#table-of-contents">↥ back to top</a></b>
</div>

## Q. How do you find third highest salary

```sql
select * from employees order by salary limit 2,1;
```

<div align="right">
    <b><a href="#table-of-contents">↥ back to top</a></b>
</div>

## Q. Difference between CHAR and VARCHAR in MySQL?

Both of them are used for string type data. `char` has fixed length and if the inserted data is less than the defined length, required no. of blank spaces are added as padding. `varchar` has variable length and no padding is used to fill up the left out space. So technically, varchar will save space.

<div align="right">
    <b><a href="#table-of-contents">↥ back to top</a></b>
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
