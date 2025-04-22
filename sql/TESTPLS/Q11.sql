WITH band_perf (band_id, performance_id) AS (SELECT band_id, performance_id FROM band INNER JOIN performer NATURAL JOIN performance ON band.band_performer_id = performer.performer_id),
	 A (artist_id, artist_name, performance_id) AS (SELECT artist_id, artist_name, performance_id FROM artist INNER JOIN performer NATURAL JOIN performance ON artist.artist_performer_id = performer.performer_id),
	 B (artist_id, artist_name, performance_id) AS (SELECT artist_id, artist_name, performance_id FROM artist NATURAL JOIN members NATURAL JOIN band_perf),
	 top_apps (artist, artist_name, apps) AS (SELECT artist_id, artist_name, COUNT(*)-4 as apps FROM (SELECT * FROM A UNION SELECT * FROM B) AS BRUH
		GROUP BY artist_id, artist_name
		ORDER BY apps DESC
		LIMIT 1)
SELECT artist_id, artist_name AS 'Name', COUNT(*) AS Appearances FROM (SELECT * FROM A UNION SELECT * FROM B) AS BRUH
    GROUP BY artist_id, artist_name
    HAVING Appearances < ANY (SELECT apps FROM top_apps);
