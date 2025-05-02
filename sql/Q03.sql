WITH band_perf AS (select band_id, performance_id FROM band INNER JOIN performer NATURAL JOIN performance ON band.band_performer_id = performer.performer_id WHERE type_performance_desc = 'Warm-Up'),
	A AS (SELECT artist_id, artist_name, festival_fest_year AS fest_year, performance_id FROM artist INNER JOIN performer NATURAL JOIN performance NATURAL JOIN music_event NATURAL JOIN festival ON artist.artist_performer_id = performer.performer_id WHERE type_performance_desc = 'Warm-Up'),
    B AS (SELECT artist_id, artist_name, festival_fest_year AS fest_year, performance_id FROM artist NATURAL JOIN members NATURAL JOIN band_perf NATURAL JOIN music_event NATURAL JOIN festival),
	final AS (SELECT * FROM A UNION SELECT * FROM B)
SELECT artist_id, artist_name, fest_year, COUNT(*) AS warmups FROM final
GROUP BY artist_id, artist_name, fest_year
HAVING warmups > 2
ORDER BY warmups DESC;
