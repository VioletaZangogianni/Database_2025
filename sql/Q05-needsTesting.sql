WITH band_perf (band_id, performance_id) AS (SELECT band_id, performance_id FROM band INNER JOIN performer NATURAL JOIN performance ON band.band_performer_id = performer.performer_id),
	 A (artist_id, performance_id, birthdate) AS (SELECT artist_id, performance_id, birthdate FROM artist INNER JOIN performer NATURAL JOIN performance ON artist.artist_performer_id = performer.performer_id WHERE TIMESTAMPDIFF(year, birthdate, CURRENT_DATE()) < 30),
	 B (artist_id, performance_id, birthdate) AS (SELECT artist_id, performance_id, birthdate FROM artist NATURAL JOIN members NATURAL JOIN band_perf WHERE TIMESTAMPDIFF(year, birthdate, CURRENT_DATE()) < 30)
SELECT artist_id, COUNT(*) AS number_of_apps FROM (SELECT * FROM A UNION SELECT * FROM B) AS BRUH
    GROUP BY artist_id
    ORDER BY number_of_apps DESC;