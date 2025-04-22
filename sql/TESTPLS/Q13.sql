WITH band_perf (band_id, performance_id) AS (SELECT band_id, performance_id FROM band INNER JOIN performer NATURAL JOIN performance ON band.band_performer_id = performer.performer_id),
	 A (artist_id, continent) AS (SELECT artist_id, location_continent FROM artist INNER JOIN performer NATURAL JOIN performance NATURAL JOIN music_event NATURAL JOIN location ON artist.artist_performer_id = performer.performer_id),
	 B (artist_id, continent) AS (SELECT artist_id, location_continent FROM artist NATURAL JOIN members NATURAL JOIN band_perf NATURAL JOIN music_event NATURAL JOIN location),
     art_cont (artist_id, continent) AS (SELECT * FROM A UNION SELECT * FROM B)
     SELECT artist_id, COUNT(DISTINCT continent) AS different_continents FROM art_cont
     GROUP BY artist_id
     HAVING different_continents > 3;
