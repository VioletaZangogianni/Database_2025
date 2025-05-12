WITH band_perf AS (SELECT band_id, performance_id
		FROM band INNER JOIN performance
        ON band.band_performer_id = performance.performer_id),
	art_age AS (SELECT artist_id, artist_name, artist_performer_id AS performer_id,
			TIMESTAMPDIFF(year, artist_birthdate, CURRENT_DATE()) AS age
		FROM artist
        HAVING age < 30),
	 A AS (SELECT artist_id, artist_name, performance_id, age
		FROM art_age NATURAL JOIN performance),
	 B AS (SELECT artist_id, artist_name, performance_id, age
		FROM art_age NATURAL JOIN members NATURAL JOIN band_perf),
	young_artists AS (SELECT * FROM A UNION SELECT * FROM B)
SELECT artist_id AS 'ID', artist_name AS 'Name', age AS Age, COUNT(*) AS Appearances
	FROM young_artists
    GROUP BY artist_id, artist_name, age
    ORDER BY Appearances DESC;