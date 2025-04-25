SET @f_year := 2021;
SET @genre := 'Pop';
WITH band_perf (band_id, performance_id, music_event_id) AS (SELECT band_id, performance_id, music_event_id FROM band INNER JOIN performer NATURAL JOIN performance ON band.band_performer_id = performer.performer_id),
	 A (artist_id, artist_name, genre_desc, fest_year) AS (SELECT artist_id, artist_name, genre_desc, festival_fest_year FROM art2genre NATURAL JOIN artist INNER JOIN performer NATURAL JOIN performance NATURAL JOIN music_event NATURAL JOIN festival ON artist.artist_performer_id = performer.performer_id),
	 B (artist_id, artist_name, genre_desc, fest_year) AS (SELECT artist_id, artist_name, genre_desc, festival_fest_year FROM art2genre NATURAL JOIN artist NATURAL JOIN members NATURAL JOIN band_perf NATURAL JOIN music_event NATURAL JOIN festival),
     art_g_year (artist_id, artist_name, genre_desc, fest_year) AS (SELECT * FROM A UNION SELECT * FROM B),
     g_artists AS (SELECT artist_id, genre_desc FROM art_g_year WHERE genre_desc = @genre)
SELECT DISTINCT artist_id AS id, artist_name AS 'Name', case
	WHEN @f_year IN (SELECT fest_year FROM (SELECT artist_id, fest_year FROM art_g_year WHERE artist_id = id) AS T) THEN 'YES'
    ELSE 'NO'
END AS wasThisYear FROM art_g_year
WHERE artist_id IN (SELECT artist_id FROM g_artists);
