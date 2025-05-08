WITH band_perf (band_id, performance_id) AS (SELECT band_id, performance_id FROM band INNER JOIN performance ON band.band_performer_id = performance.performer_id),
	 A AS (SELECT artist_id, artist_name, performance_id, TIMESTAMPDIFF(year, artist_birthdate, CURRENT_DATE()) AS age FROM artist INNER JOIN performer NATURAL JOIN performance ON artist.artist_performer_id = performance.performer_id),
	 B AS (SELECT artist_id, artist_name, performance_id, TIMESTAMPDIFF(year, artist_birthdate, CURRENT_DATE()) AS age FROM artist NATURAL JOIN members NATURAL JOIN band_perf),
	young_artists AS (SELECT * FROM A WHERE age < 30 UNION SELECT * FROM B WHERE age < 30)
SELECT artist_id AS 'ID', artist_name AS 'Name', age AS Age, COUNT(*) AS Appearances FROM young_artists
    GROUP BY artist_id, artist_name, age
    ORDER BY Appearances DESC;
