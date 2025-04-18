WITH band_perf (band_id, performance_id, music_event_id) AS (SELECT band_id, performance_id, music_event_id FROM band INNER JOIN performer NATURAL JOIN performance ON band.band_performer_id = performer.performer_id),
	 A (artist_id, genre_id, fest_year) AS (SELECT artist_id, genre_id, festival_fest_year FROM artist INNER JOIN performer NATURAL JOIN performance NATURAL JOIN music_event NATURAL JOIN festival ON artist.artist_performer_id = performer.performer_id),
	 B (artist_id, genre_id, fest_year) AS (SELECT artist_id, genre_id, festival_fest_year FROM artist NATURAL JOIN members NATURAL JOIN band_perf NATURAL JOIN music_event NATURAL JOIN festival),
     art_g_year (artist_id, genre_id, fest_year) AS (SELECT * FROM A UNION SELECT * FROM B),
     g_artists AS (SELECT artist_id, genre_id FROM art_g_year WHERE genre_id = 3)
SELECT DISTINCT artist_id AS a_id, case
	WHEN 2018 IN (SELECT fest_year FROM (SELECT artist_id, fest_year FROM art_g_year WHERE artist_id = a_id) AS T) THEN 'YES'
    ELSE 'NOPE'
END AS wasThisYear FROM art_g_year
WHERE artist_id IN (SELECT artist_id FROM g_artists);