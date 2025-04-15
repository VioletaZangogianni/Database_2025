WITH band_perf_year (band_id, performance_id, fest_year) AS (SELECT band_id, performance_id, festival_fest_year FROM band INNER JOIN performer NATURAL JOIN performance NATURAL JOIN music_event NATURAL JOIN festival ON band.band_performer_id = performer.performer_id),
A (genre_id, performance_id, fest_year) AS (SELECT genre_id, performance_id, festival_fest_year FROM genre NATURAL JOIN artist INNER JOIN performer NATURAL JOIN performance NATURAL JOIN music_event NATURAL JOIN festival ON artist.artist_performer_id = performer.performer_id),
B (genre_id, performance_id, fest_year) AS (SELECT genre_id, performance_id, fest_year FROM genre NATURAL JOIN artist NATURAL JOIN members NATURAL JOIN band_perf_year),
g_perf_year (genre_id, performance_id, fest_year) AS (SELECT * FROM A UNION SELECT * FROM B),
g_year_apps (genre_id, fest_year, apps) AS (SELECT genre_id, fest_year, COUNT(*) FROM g_perf_year GROUP BY genre_id, fest_year),
g_two_years (genre_id, year1) AS (SELECT Y1.genre_id, Y1.fest_year FROM g_year_apps Y1, g_year_apps Y2 WHERE Y1.fest_year + 1 = Y2.fest_year AND Y1.apps = Y2.apps)

SELECT * FROM g__year_apps
GROUP BY genre_id, fest_year
HAVING apps >= 3 AND genre_id, fest_year IN g_two_years;
