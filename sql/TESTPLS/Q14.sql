WITH band_perf_year AS (SELECT band_id, performance_id, festival_fest_year AS fest_year FROM band INNER JOIN performer NATURAL JOIN performance NATURAL JOIN music_event NATURAL JOIN festival ON band.band_performer_id = performer.performer_id),
A AS (SELECT genre_desc, performance_id, festival_fest_year AS fest_year FROM genre NATURAL JOIN art2genre NATURAL JOIN artist INNER JOIN performer NATURAL JOIN performance NATURAL JOIN music_event NATURAL JOIN festival ON artist.artist_performer_id = performer.performer_id),
B AS (SELECT genre_desc, performance_id, fest_year FROM genre NATURAL JOIN art2genre NATURAL JOIN artist NATURAL JOIN members NATURAL JOIN band_perf_year),
g_perf_year AS (SELECT * FROM A UNION SELECT * FROM B),
g_year_apps AS (SELECT genre_desc, fest_year, COUNT(*) AS apps FROM g_perf_year GROUP BY genre_desc, fest_year)

SELECT * FROM g_year_apps WHERE (genre_desc, fest_year) IN (SELECT Y1.genre_desc, Y1.fest_year FROM g_year_apps Y1, g_year_apps Y2 WHERE Y1.fest_year + 1 = Y2.fest_year AND Y1.apps = Y2.apps)
GROUP BY genre_desc, fest_year
HAVING apps >= 3;
