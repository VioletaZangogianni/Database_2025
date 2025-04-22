WITH band_perf (band_id, performance_id) AS (SELECT band_id, performance_id FROM band INNER JOIN performer NATURAL JOIN performance ON band.band_performer_id = performer.performer_id),
	 A (artist_id, artist_name, continent) AS (SELECT artist_id, artist_name, location_continent FROM artist INNER JOIN performer NATURAL JOIN performance NATURAL JOIN music_event NATURAL JOIN festival NATURAL JOIN location ON artist.artist_performer_id = performer.performer_id),
	 B (artist_id, artist_name, continent) AS (SELECT artist_id, artist_name, location_continent FROM artist NATURAL JOIN members NATURAL JOIN band_perf NATURAL JOIN music_event NATURAL JOIN festival NATURAL JOIN location),
     art_cont (artist_id, artist_name, continent) AS (SELECT * FROM A UNION SELECT * FROM B)
     SELECT artist_id AS ID, artist_name AS 'Name', COUNT(DISTINCT continent) AS different_continents FROM art_cont
     GROUP BY artist_id, artist_name
     HAVING different_continents > 3;
