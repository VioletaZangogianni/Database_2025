WITH band_perf_year AS (SELECT band_id, performance_id, festival_fest_year AS fest_year FROM band INNER JOIN performance NATURAL JOIN music_event NATURAL JOIN festival ON band.band_performer_id = performance.performer_id),
A AS (SELECT genre_desc, performance_id, festival_fest_year AS fest_year FROM art2genre NATURAL JOIN artist INNER JOIN performance NATURAL JOIN music_event NATURAL JOIN festival ON artist.artist_performer_id = performance.performer_id),
B AS (SELECT genre_desc, performance_id, fest_year FROM art2genre NATURAL JOIN artist NATURAL JOIN members NATURAL JOIN band_perf_year),
C AS (SELECT genre_desc, performance_id, fest_year FROM band2genre NATURAL JOIN band_perf_year),
g_perf_year AS (SELECT * FROM A UNION SELECT * FROM B UNION SELECT * FROM C),
g_year_apps AS (SELECT genre_desc, fest_year, COUNT(*) AS appearances FROM g_perf_year GROUP BY genre_desc, fest_year HAVING appearances >= 3)
SELECT G1.genre_desc AS Genre, G1.fest_year AS 'First Year', G2.fest_year AS 'Second Year', G1.appearances FROM g_year_apps G1, g_year_apps G2
	WHERE G1.genre_desc = G2.genre_desc AND G1.fest_year + 1 = G2.fest_year AND G1.appearances = G2.appearances 
	ORDER BY G1.genre_desc ASC, G1.fest_year ASC;
