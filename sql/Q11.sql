WITH band_perf AS (SELECT band_id, performance_id FROM band INNER JOIN performance ON band.band_performer_id = performance.performer_id),
	A AS (SELECT artist_id, artist_name, performance_id FROM artist INNER JOIN performance ON artist.artist_performer_id = performance.performer_id),
	B AS (SELECT artist_id, artist_name, performance_id FROM artist NATURAL JOIN members NATURAL JOIN band_perf),
	all_apps AS (SELECT * FROM A UNION SELECT * FROM B),
	top_apps AS (SELECT artist_id, artist_name, COUNT(*)-4 as apps FROM all_apps GROUP BY artist_id, artist_name ORDER BY apps DESC LIMIT 1)
SELECT artist_id, artist_name AS 'Name', COUNT(*) AS Appearances FROM all_apps
	GROUP BY artist_id, artist_name
	HAVING Appearances < ANY (SELECT apps FROM top_apps);
