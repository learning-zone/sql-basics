
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