
01. Import ".sql" file from command prompt

mysql > SOURCE C://database.sql;     

02. MySQL Performance Queries

mysql > OPTIMIZE TABLE table_name;
mysql > SHOW TABLE STATUS;  //Displays description of the table
mysql > DESC table_name;
mysql > SHOW VARIABLES;
mysql > SHOW STATUS;
mysql > SHOW GLOBAL STATUS;
mysql > SHOW TABLES FROM INFORMATION_SCHEMA;
mysql > EXPLAIN SELECT * FROM table_name
mysql > SHOW TABLE STATUS FROM database_name;
mysql > SHOW FULL PROCESSLIST;  //Shows you which threads are running
mysql > SHOW VARIABLES WHERE Variable_name = 'hostname';  //IP Address of the Mysql Host

03. Indexing

mysql > SHOW INDEX FROM table_name;
mysql > ALTER TABLE `table_name` ADD INDEX(`column_name`);
mysql > DROP INDEX index_name ON tbl_name;

04. Table Related Queries


mysql > SELECT max(RIGHT(`field_name`,4)) FROM `table_name`;
mysql > SELECT UCASE(column_name) FROM table_name;  // Converts to upper case
mysql > SELECT * FROM TABLE ORDER BY ABS(VALUE - $MYVALUE) LIMIT 1 //Select nearest value
mysql > SELECT sentence, wordcount(sentence) as "Words" from test;
mysql > SELECT * FROM table_name ORDER BY field_name LIMIT 5 OFFSET 5;  //Useful in pagination
mysql > SELECT *,  COUNT(field_name)  FROM table_name GROUP BY field_name HAVING ( COUNT(field_name) > 1 ) //Find duplicate entries

mysql > ALTER TABLE table_name AUTO_INCREMENT =1
mysql > ALTER TABLE `table_name` DROP PRIMARY KEY 
mysql > ALTER TABLE `table_name` ENGINE = InnoDB
mysql > ALTER TABLE table_name CHANGE `id` `id` INT( 11 ) NOT NULL AUTO_INCREMENT 
mysql > ALTER TABLE `table_name` ADD `id` INT NOT NULL AUTO_INCREMENT PRIMARY KEY FIRST ;
mysql > ALTER TABLE table_name ADD column_name datatype AFTER column_name 
mysql > ALTER TABLE table_name DROP COLUMN column_name  
mysql > ALTER TABLE table_name MODIFY column_name datatype
mysql > ALTER TABLE table_name CHANGE oldname newname datatype

mysql > RENAME TABLE `table_name_old` TO `table_name_new`

mysql > UPDATE mytable SET city = REPLACE(city, 'ï', 'i')   //Update particular character
mysql > UPDATE swap_test SET x=y, y=@temp where @temp:=x;   //Swaping field value
mysql > UPDATE table_name SET field_name1=field_name2;      //COPYING
mysql > UPDATE table_name SET field_name = UPPER(field_name)

mysql > TRUNCATE TABLE table_name;
mysql > DROP TABLE table_name;
mysql > 

05. Date and time

mysql > SHOW VARIABLE LIKE '%time_zone%';
mysql > SELECT NOW(); //Current timestamp
mysql > SELECT DAYNAME(NOW()); //Current day
mysql > SELECT SUBTIME('1:30:00', '00:15:00'); //Subtract time
mysql > SELECT DATE_FORMAT(NOW(), '%W, %D of %M, %Y'); //Date Format 
mysql > SELECT TIMEDIFF('2007-10-05 12:10:18','2007-10-05 16:14:59') AS length;
mysql > SELECT * FROM `table_name` WHERE DATE_FORMAT(field_name, "%Y-%m-%d") = '2010-01-01'"


06. MySQL Miscellaneous Queries

mysql > SELECT uuid(); //Use to generate unique id 
mysql > SELECT * FROM `TABLENAME` WHERE `field` REGEXP '^-?[0-9]+$' //Get numeric values 
mysql > SELECT CONCAT('w3resource','.','com'); //w3resource.com
mysql > CREATE TABLE table_bit (id SERIAL, a BIT(3), b BIT(8), c BIT(16)); //bit datatype
mysql > CREATE TABLE table_enum (id SERIAL, status ENUM('Active', 'Deactive')); //Enum datatype
mysql > SELECT CHAR_LENGTH(field_name) AS Length FROM `table_name`; //Get the length 
mysql > SELECT * FROM `table_name` WHERE LENGTH(field_name) < 10
mysql > INSERT INTO table_name (`col1`, `col2`, `col3`, `...`, `coln`) SELECT `col1`, `col2`, `col3`, `...`, `coln` FROM table_name //Copying the previous rows to the next rows
mysql > SELECT COUNT(DISTINCT column) FROM table;
mysql > SELECT field_name, LEFT(field_name, 3), RIGHT(field_name, 3), MID(field_name, 2, 3) FROM `table_name`;
mysql > SELECT CASE WHEN a THEN 'true' ELSE 'false' END AS boolA, CASE WHEN b THEN 'true' ELSE 'false' END AS boolB FROM table_name; //Flow control with CASE


 
