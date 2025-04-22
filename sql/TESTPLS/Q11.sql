WITH band_perf (band_id, performance_id) AS (SELECT band_id, performance_id FROM band INNER JOIN performer NATURAL JOIN performance ON band.band_performer_id = performer.performer_id),
	 A (artist_id, performance_id) AS (SELECT artist_id, performance_id FROM artist INNER JOIN performer NATURAL JOIN performance ON artist.artist_performer_id = performer.performer_id),
	 B (artist_id, performance_id) AS (SELECT artist_id, performance_id FROM artist NATURAL JOIN members NATURAL JOIN band_perf),
	 top_apps (artist, apps) AS (SELECT artist_id, COUNT(*)-4 as apps FROM (SELECT * FROM A UNION SELECT * FROM B) AS BRUH
		GROUP BY artist_id
		ORDER BY apps DESC
		LIMIT 1)
SELECT artist_id, COUNT(*) AS number_of_apps FROM (SELECT * FROM A UNION SELECT * FROM B) AS BRUH
    GROUP BY artist_id
    HAVING number_of_apps < ANY (SELECT apps FROM top_apps);
