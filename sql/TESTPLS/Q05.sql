WITH band_perf (band_id, performance_id) AS (SELECT band_id, performance_id FROM band INNER JOIN performer NATURAL JOIN performance ON band.band_performer_id = performer.performer_id),
	 A (artist_id, artist_name, performance_id, birthdate) AS (SELECT artist_id, artist_name, performance_id, artist_birthdate FROM artist INNER JOIN performer NATURAL JOIN performance ON artist.artist_performer_id = performer.performer_id WHERE TIMESTAMPDIFF(year, artist_birthdate, CURRENT_DATE()) < 30),
	 B (artist_id, artist_name, performance_id, birthdate) AS (SELECT artist_id, artist_name, performance_id, artist_birthdate FROM artist NATURAL JOIN members NATURAL JOIN band_perf WHERE TIMESTAMPDIFF(year, artist_birthdate, CURRENT_DATE()) < 30),
	young_artists AS (SELECT * FROM A UNION SELECT * FROM B)
SELECT artist_id AS 'ID', artist_name AS 'Name', COUNT(*) AS 'Appearances' FROM young_artists
    GROUP BY artist_id, artist_name
    ORDER BY 'Appearances' DESC;
