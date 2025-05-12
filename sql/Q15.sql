WITH band_perf (band_id, performance_id) AS (SELECT band_id, performance_id
		FROM band INNER JOIN performance
        ON band.band_performer_id = performance.performer_id),
	A AS (SELECT artist_id, artist_name, performance_id
		FROM artist INNER JOIN performance
        ON artist.artist_performer_id = performance.performer_id),
	B AS (SELECT artist_id, artist_name, performance_id
		FROM artist NATURAL JOIN members NATURAL JOIN band_perf),
	art_perf AS (SELECT * FROM A UNION SELECT * FROM B)
SELECT CONCAT(visitor_name, ' ', visitor_surname) AS Reviewer, artist_name AS Artist,
		review_interpretation + review_overall_impression AS Score
	FROM visitor NATURAL JOIN review NATURAL JOIN art_perf
	ORDER BY Score DESC LIMIT 5;