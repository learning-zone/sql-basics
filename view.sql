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