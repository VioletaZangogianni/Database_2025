SET @f_year := 2021;
SET @genre := 'Pop';
WITH band_perf AS (SELECT band_id, performance_id, music_event_id 
		FROM band INNER JOIN performance
		ON band.band_performer_id = performance.performer_id),
	 A AS (SELECT artist_id, artist_name, genre_desc, festival_fest_year AS fest_year
		FROM art2genre NATURAL JOIN artist INNER JOIN performance NATURAL JOIN music_event NATURAL JOIN festival
        ON artist.artist_performer_id = performance.performer_id),
	 B AS (SELECT artist_id, artist_name, genre_desc, festival_fest_year AS fest_year
		FROM art2genre NATURAL JOIN artist NATURAL JOIN members NATURAL JOIN band_perf NATURAL JOIN music_event
			NATURAL JOIN festival),
     art_g_year (artist_id, artist_name, genre_desc, fest_year) AS (SELECT * FROM A UNION SELECT * FROM B)
SELECT DISTINCT artist_id AS id, artist_name AS 'Name', case
	WHEN @f_year IN (SELECT fest_year
		FROM (SELECT artist_id, fest_year FROM art_g_year WHERE artist_id = id) AS T) THEN 'YES'
    ELSE 'NO'
END AS wasThisYear FROM art_g_year
WHERE genre_desc = @genre;