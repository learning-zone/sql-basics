
## Database Query



#### MYSQL TIPS AND TWEAKS

|Sl.No.|  Query                             | Description                      |
|------|------------------------------------|----------------------------------|
| 01.  |SHOW VARIABLES LIKE 'AUTOCOMMIT';   |                                  |
| 02.  |SHOW TABLE STATUS LIKE 'table_name' |                                  |
| 03.  |SHOW SESSION STATUS LIKE 'Select%'; |                                  |
| 04.  |SHOW SESSION STATUS LIKE 'Handler%';|                                  |
| 05.  |SHOW SESSION STATUS LIKE 'Sort%';   |                                  |
| 06.  |SHOW SESSION STATUS LIKE 'Created%';|                                  |
| 07.  |SHOW PROFILES;                      |                                  |
| 08.  |SHOW PROFILE CPU FOR QUERY 1;       |                                  |
| 09.  |SHOW PROCESSLIST;                   |                                  |


#### MYSQL Statements and clauses

|Sl.No.|  Query                |
|------|-----------------------|
| 01. |ALTER DATABASE       |
| 02. |ALTER TABLE          |
| 03. |ALTER VIEW           |
| 04. |ANALYZE TABLE        |
| 05. |BACKUP TABLE         |
| 06. |CACHE INDEX          |
| 07. |CHANGE MASTER TO     |
| 08. |CHECK TABLE          |
| 09. |CHECKSUM TABLE       |
| 10. |COMMIT               |
| 11. |CREATE DATABASE      |
| 12. |CREATE INDEX         |
| 13. |CREATE TABLE         |
| 14. |CREATE VIEW|
| 15. |DELETE|
| 16. |DESCRIBE|
| 17. |DO|
| 18. |DROP DATABASE|
| 19. |DROP INDEX|
| 20. |DROP TABLE|
| 21. |DROP USER|
| 22. |DROP VIEW|
| 23. |EXPLAIN|
| 24. |FLUSH|
| 25. |GRANT|
| 26. |HANDLER|
| 27. |INSERT|
| 28. |JOIN|
| 29. |KILL|
| 30. |LOAD DATA FROM MASTER|
| 31. |LOAD DATA INFILE|
| 32. |LOAD INDEX INTO CACHE|
| 33. |LOAD TABLE...FROM MASTER|
| 34. |LOCK TABLES|
| 35. |OPTIMIZE TABLE|
| 36. |PURGE MASTER LOGS|
| 37. |RENAME TABLE|
| 38. |REPAIR TABLE|
| 39. |REPLACE|
| 40. |RESET|
| 41. |RESET MASTER|
| 42. |RESET SLAVE|
| 43. |RESTORE TABLE|
| 44. |REVOKE|
| 45. |ROLLBACK|
| 46. |ROLLBACK TO SAVEPOINT|
| 47. |SAVEPOINT|
| 48. |SELECT|
| 49. |SET|
| 50. |SET PASSWORD|
| 51. |SET SQL_LOG_BIN|
| 52. |SET TRANSACTION|
| 53. |  SHOW BINLOG EVENTS|
| 54. |  SHOW CHARACTER SET|
| 55. |  SHOW COLLATION|
| 56. |  SHOW COLUMNS|
| 57. |  SHOW CREATE DATABASE|
| 58. |  SHOW CREATE TABLE|
| 59. |  SHOW CREATE VIEW|
| 60. |  SHOW DATABASES|
| 61. |  SHOW ENGINES|
| 62. |  SHOW ERRORS|
| 63. |  SHOW GRANTS|
| 64. |  SHOW INDEX|
| 65. |  SHOW INNODB STATUS|
| 66. |  SHOW LOGS|
| 67. |  SHOW MASTER LOGS|
| 68. |  SHOW MASTER STATUS|
| 69. |  SHOW PRIVILEGES|
| 70. |  SHOW PROCESSLIST|
| 71. |  SHOW SLAVE HOSTS|
| 72. |  SHOW SLAVE STATUS|
| 73. |  SHOW STATUS|
| 74. |  SHOW TABLE STATUS|
| 75. |  SHOW TABLES|
| 76. |  SHOW VARIABLES|
| 77. |  SHOW WARNINGS|
| 78. |  START SLAVE|
| 79. |  START TRANSACTION|
| 80. |  STOP SLAVE|
| 81. |  TRUNCATE TABLE|
| 82. |  UNION|
| 83. |  UNLOCK TABLES|
| 84. |  USE|
| 85. |  String Functions|
| 86. |  AES_DECRYPT|
| 87. |  AES_ENCRYPT|
| 88. |  ASCII|
| 89. |  BIN|
| 90. |  BINARY|
| 91.   |  BIT_LENGTH|
| 92.   |  CHAR|
| 93.   |  CHAR_LENGTH|
| 94.   |  CHARACTER_LENGTH|
| 95.   |  COMPRESS|
| 96.   |  CONCAT|
| 97.   |  CONCAT_WS|
| 98.   |  CONV|
| 99.   |  DECODE|
| 100.   |  DES_DECRYPT|
| 101.   |  DES_ENCRYPT|
| 102.   |  ELT|
| 103.   |  ENCODE|
| 104.   |  ENCRYPT|
| 105.   |  EXPORT_SET|
| 106.   |  FIELD|
| 107.   |  FIND_IN_SET|
| 108.   |  HEX|
| 109.   |  INET_ATON|
| 110.   |  INET_NTOA|
| 111.   |  INSERT|
| 112.   |  INSTR|
| 113.   |  LCASE|
| 114.   |  LEFT|
| 115.   |  LENGTH|
| 116.   |  LOAD_FILE|
| 117.   |  LOCATE|
| 118.   |  LOWER|
| 119.   |  LPAD|
| 120.   |  LTRIM|
| 121.   |  MAKE_SET|
| 122.   |  MATCH    AGAINST|
| 123.   |  MD5|
| 124.   |  MID|
| 125.   |  OCT|
| 126.   |  OCTET_LENGTH|
| 127.   |  OLD_PASSWORD|
| 128.   |  ORD|
| 129.   |  PASSWORD|
| 130.   |  POSITION|
| 131.   |  QUOTE|
| 132.   |  REPEAT|
| 133.   |  REPLACE|
| 134.   |  REVERSE|
| 135.   |  RIGHT|
| 136.   |  RPAD|
| 137.   |  RTRIM|
| 138.   |  SHA|
| 139.   |  SHA1|
| 140.   |  SOUNDEX|
| 141.   |  SPACE|
| 142.   |  STRCMP|
| 143.   |  SUBSTRING|
| 144.   |  SUBSTRING_INDEX|
| 145.   |  TRIM|
| 146.   |  UCASE|
| 147.   |  UNCOMPRESS|
| 148.   |  UNCOMPRESSED_LENGTH|
| 149.   |  UNHEX|
| 150.   |  UPPER|

####    Date and Time Functions

        ADDDATE
        ADDTIME
        CONVERT_TZ
        CURDATE
        CURRENT_DATE
        CURRENT_TIME
        CURRENT_TIMESTAMP
        CURTIME
        DATE
        DATE_ADD
        DATE_FORMAT
        DATE_SUB
        DATEDIFF
        DAY
        DAYNAME
        DAYOFMONTH
        DAYOFWEEK
        DAYOFYEAR
        EXTRACT
        FROM_DAYS
        FROM_UNIXTIME
        GET_FORMAT
        HOUR
        LAST_DAY
        LOCALTIME
        LOCALTIMESTAMP
        MAKEDATE
        MAKETIME
        MICROSECOND
        MINUTE
        MONTH
        MONTHNAME
        NOW
        PERIOD_ADD
        PERIOD_DIFF
        QUARTER
        SEC_TO_TIME
        SECOND
        STR_TO_DATE
        SUBDATE
        SUBTIME
        SYSDATE
        TIME
        TIMEDIFF
        TIMESTAMP
        TIMESTAMPDIFF
        TIMESTAMPADD
        TIME_FORMAT
        TIME_TO_SEC
        TO_DAYS
        UNIX_TIMESTAMP
        UTC_DATE
        UTC_TIME
        UTC_TIMESTAMP
        WEEK
        WEEKDAY
        WEEKOFYEAR
        YEAR
        YEARWEEK
		

####   Mathematical and Aggregate Functions


        ABS
        ACOS
        ASIN
        ATAN
        ATAN2
        AVG
        BIT_AND
        BIT_OR
        BIT_XOR
        CEIL
        CEILING
        COS
        COT
        COUNT
        CRC32
        DEGREES
        EXP
        FLOOR
        FORMAT
        GREATEST
        GROUP_CONCAT
        LEAST
        LN
        LOG
        LOG2
        LOG10
        

        MAX
        MIN
        MOD
        PI
        POW
        POWER
        RADIANS
        RAND
        ROUND
        SIGN
        SIN
        SQRT
        STD
        STDDEV
        SUM
        TAN
        TRUNCATE
        VARIANCE


####   Flow Control Functions

        CASE
        IF
        IFNULL
        NULLIF

####  Command-Line Utilities

        comp_err
        isamchk
        make_binary_distribution
        msql2mysql
        my_print_defaults
        myisamchk
        myisamlog
        myisampack
        mysqlaccess
        mysqladmin
        mysqlbinlog
        mysqlbug
        mysqlcheck
        mysqldump
        mysqldumpslow
        mysqlhotcopy
        mysqlimport
        mysqlshow
        perror
		

####   Perl API - using functions and methods built into the Perl DBI with MySQL


        available_drivers
        begin_work
        bind_col
        bind_columns
        bind_param
        bind_param_array
        bind_param_inout
        can
        clone
        column_info
        commit
        connect
        connect_cached
        data_sources
        disconnect
        do
        dump_results
        err
        errstr
        execute
        execute_array
        execute_for_fetch
        fetch
        fetchall_arrayref
        fetchall_hashref
        fetchrow_array
        fetchrow_arrayref
        fetchrow_hashref
        finish
        foreign_key_info
        func
        get_info
        installed_versions
        last_insert_id
        looks_like_number
        neat
        neat_list
        parse_dsn
        parse_trace_flag
        parse_trace_flags
        ping
        prepare
        prepare_cached
        primary_key
        primary_key_info
        quote
        quote_identifier
        rollback
        rows
        selectall_arrayref
        selectall_hashref
        selectcol_arrayref
        selectrow_array
        selectrow_arrayref
        selectrow_hashref
        set_err
        state
        table_info
        table_info_all
        tables
        trace
        trace_msg
        type_info
        type_info_all
		

####  PHP API - using functions built into PHP with MySQL


        mysql_affected_rows
        mysql_change_user
        mysql_client_encoding
        mysql_close
        mysql_connect
        mysql_create_db
        mysql_data_seek
        mysql_db_name
        mysql_db_query
        mysql_drop_db
        mysql_errno
        mysql_error
        mysql_escape_string
        mysql_fetch_array
        mysql_fetch_assoc
        mysql_fetch_field
        mysql_fetch_lengths
        mysql_fetch_object
        mysql_fetch_row
        mysql_field_flags
        mysql_field_len
        mysql_field_name
        mysql_field_seek
        mysql_field_table
        mysql_field_type
        mysql_free_result
        mysql_get_client_info
        mysql_get_host_info
        mysql_get_proto_info
        mysql_get_server_info
        mysql_info
        mysql_insert_id
        mysql_list_dbs
        mysql_list_fields
        mysql_list_processes
        mysql_list_tables
        mysql_num_fields
        mysql_num_rows    
        mysql_pconnect
        mysql_ping
        mysql_query
        mysql_real_escape_string
        mysql_result
        mysql_select_db
        mysql_stat
        mysql_tablename
        mysql_thread_id
        mysql_unbuffered_query


#### MYSQL FUNCTIONS

```
mysqli_affected_rows()            Returns the number of affected rows in the previous MySQL operation
mysqli_autocommit()               Turns on or off auto-committing database modifications
mysqli_change_user()              Changes the user of the specified database connection
mysqli_character_set_name()       Returns the default character set for the database connection
mysqli_close()                    Closes a previously opened database connection
mysqli_commit()                   Commits the current transaction
mysqli_connect_errno()            Returns the error code from the last connection error
mysqli_connect_error()            Returns the error description from the last connection error
mysqli_connect()                  Opens a new connection to the MySQL server
mysqli_data_seek()                Adjusts the result pointer to an arbitrary row in the result-set
mysqli_debug()                    Performs debugging operations
mysqli_dump_debug_info()          Dumps debugging info into the log
mysqli_errno()                    Returns the last error code for the most recent function call
mysqli_error_list()               Returns a list of errors for the most recent function call
mysqli_error()                    Returns the last error description for the most recent function call
mysqli_fetch_all()                Fetches all result rows as an associative array, a numeric array, or both
mysqli_fetch_array()              Fetches a result row as an associative, a numeric array, or both
mysqli_fetch_assoc()              Fetches a result row as an associative array
mysqli_fetch_field_direct()       Returns meta-data for a single field in the result set, as an object
mysqli_fetch_field()              Returns the next field in the result set, as an object
mysqli_fetch_fields()             Returns an array of objects that represent the fields in a result set
mysqli_fetch_lengths()            Returns the lengths of the columns of the current row in the result set
mysqli_fetch_object()             Returns the current row of a result set, as an object
mysqli_fetch_row()                Fetches one row from a result-set and returns it as an enumerated array
mysqli_field_count()              Returns the number of columns for the most recent query
mysqli_field_seek()               Sets the field cursor to the given field offset
mysqli_field_tell()               Returns the position of the field cursor
mysqli_free_result()            Frees the memory associated with a result
mysqli_get_charset()            Returns a character set object
mysqli_get_client_info()        Returns the MySQL client library version
mysqli_get_client_stats()        Returns statistics about client per-process
mysqli_get_client_version()        Returns the MySQL client library version as an integer
mysqli_get_connection_stats()    Returns statistics about the client connection
mysqli_get_host_info()            Returns the MySQL server hostname and the connection type
mysqli_get_proto_info()            Returns the MySQL protocol version
mysqli_get_server_info()        Returns the MySQL server version
mysqli_get_server_version()        Returns the MySQL server version as an integer
mysqli_info()                    Returns information about the most recently executed query
mysqli_init()                    Initializes MySQLi and returns a resource for use with mysqli_real_connect()
mysqli_insert_id()                Returns the auto-generated id used in the last query
mysql_kill()                    Asks the server to kill a MySQL thread
mysqli_more_results()            Checks if there are more results from a multi query
mysqli_multi_query()            Performs one or more queries on the database
mysqli_next_result()            Prepares the next result set from mysqli_multi_query()
mysqli_num_fields()                Returns the number of fields in a result set
mysqli_num_rows()                Returns the number of rows in a result set
mysqli_options()                Sets extra connect options and affect behavior for a connection
mysqli_ping()                    Pings a server connection, or tries to reconnect if the connection has gone down
mysqli_prepare()                Prepares an SQL statement for execution
mysqli_query()                    Performs a query against the database
mysqli_real_connect()            Opens a new connection to the MySQL server
mysqli_real_escape_string()        Escapes special characters in a string for use in an SQL statement
mysqli_real_query()                Executes an SQL query
mysqli_reap_async_query()         Returns the result from async query
mysqli_refresh()                  Refreshes tables or caches, or resets the replication server information
mysqli_rollback()                 Rolls back the current transaction for the database
mysqli_select_db()                Changes the default database for the connection
mysqli_set_charset()              Sets the default client character set
mysqli_set_local_infile_default()    Unsets user defined handler for load local infile command
mysqli_set_local_infile_handler()    Set callback function for LOAD DATA LOCAL INFILE command
mysqli_sqlstate()                 Returns the SQLSTATE error code for the last MySQL operation
mysqli_ssl_set()                  Used to establish secure connections using SSL
mysqli_stat()                     Returns the current system status
mysqli_stmt_init()                Initializes a statement and returns an object for use with mysqli_stmt_prepare()
mysqli_store_result()             Transfers a result set from the last query
mysqli_thread_id()                Returns the thread ID for the current connection
mysqli_thread_safe()              Returns whether the client library is compiled as thread-safe
mysqli_use_result()               Initiates the retrieval of a result set from the last query executed using the mysqli_real_query()
mysqli_warning_count()            Returns the number of warnings from the last query in the connection
```

