WITH band_perf (band_id, performance_id, performance_type) AS (SELECT band_id, performance_id, performance_type FROM band INNER JOIN performer NATURAL JOIN performance ON band.band_performer_id = performer.performer_id),
	 A (artist_id, festival_id, performance_type) AS (SELECT artist_id, festival_id, performance_type FROM artist INNER JOIN performer NATURAL JOIN performance NATURAL JOIN music_event ON artist.artist_performer_id = performer.performer_id),
	 B (artist_id, festival_id, performance_type) AS (SELECT artist_id, festival_id, performance_type FROM artist NATURAL JOIN members NATURAL JOIN band_perf NATURAL JOIN music_event),
     art_perf (festival_id, artist_id) AS (SELECT festival_id, artist_id, performance_type FROM A UNION SELECT festival_id, artist_id FROM B WHERE performance_type = 'Warm-up')
SELECT festival_id, artist_id FROM art_perf
	GROUP BY festival_id, artist_id
	HAVING COUNT(artist_id) > 2;