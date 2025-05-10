WITH band_perf AS (SELECT band_id, performance_id FROM band INNER JOIN performance ON band.band_performer_id = performance.performer_id),
	A AS (SELECT artist_id, artist_name, performance_id FROM artist INNER JOIN performance ON artist.artist_performer_id = performance.performer_id),
	B AS (SELECT artist_id, artist_name, performance_id FROM artist NATURAL JOIN members NATURAL JOIN band_perf),
	all_apps AS (SELECT * FROM A UNION SELECT * FROM B),
    app_counts AS (SELECT artist_id, artist_name, COUNT(*) AS apps FROM all_apps GROUP BY artist_id, artist_name),
	top_apps AS (SELECT apps-4 as most_apps FROM app_counts ORDER BY apps DESC LIMIT 1)
SELECT artist_id, artist_name AS 'Name', apps AS Appearances FROM app_counts
	WHERE apps < ANY (SELECT * FROM top_apps);
