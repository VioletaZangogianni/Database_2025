WITH band_perf (band_id, performance_id, performance_type) AS (SELECT band_id, performance_id, type_performance_desc FROM band INNER JOIN performer NATURAL JOIN performance ON band.band_performer_id = performer.performer_id),
	 A (artist_id, artist_name, fest_year, fest_name, performance_type) AS (SELECT artist_id, artist_name, festival_fest_year, festival_name, type_performance_desc FROM artist INNER JOIN performer NATURAL JOIN performance NATURAL JOIN music_event NATURAL JOIN festival ON artist.artist_performer_id = performer.performer_id),
	 B (artist_id, artist_name, fest_year, fest_name, performance_type) AS (SELECT artist_id, artist_name, festival_fest_year, festival_name, performance_type FROM artist NATURAL JOIN members NATURAL JOIN band_perf NATURAL JOIN music_event NATURAL JOIN festival),
     art_perf (fest_year, fest_name, artist_id, artist_name) AS (SELECT fest_year, fest_name, artist_id, artist_name FROM A UNION SELECT fest_year, fest_name, artist_id, artist_name FROM B WHERE performance_type = 'Warm-up')
SELECT fest_year AS 'Year', fest_name AS 'Festival', artist_name AS 'Name' FROM art_perf
	GROUP BY fest_year, fest_name, artist_name
	HAVING COUNT(artist_id) > 2;
