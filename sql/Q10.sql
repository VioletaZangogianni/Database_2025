WITH band_perf AS (SELECT band_id, performance_id
		FROM band INNER JOIN performance
        ON band.band_performer_id = performance.performer_id),
	A AS (SELECT genre_desc, artist_id, performance_id
		FROM art2genre NATURAL JOIN artist INNER JOIN performance
        ON artist.artist_performer_id = performance.performer_id),
	B AS (SELECT genre_desc, artist_id, performance_id
		FROM art2genre NATURAL JOIN artist NATURAL JOIN members NATURAL JOIN band_perf),
g_art_perf AS (SELECT * FROM A UNION SELECT * FROM B)
SELECT G1.genre_desc AS first_genre, G2.genre_desc AS second_genre, COUNT(G1.performance_id) AS apps
	FROM g_art_perf G1, g_art_perf G2
    WHERE G1.artist_id = G2.artist_id AND G1.genre_desc < G2.genre_desc AND G1.performance_id = G2.performance_id
	GROUP BY first_genre, second_genre
    ORDER BY apps DESC LIMIT 3;