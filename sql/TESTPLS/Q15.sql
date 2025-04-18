WITH band_perf (band_id, performance_id) AS (SELECT band_id, performance_id FROM band INNER JOIN performer NATURAL JOIN performance ON band.band_performer_id = performer.performer_id),
A (artist_id, performance_id) AS (SELECT artist_id, performance_id FROM artist INNER JOIN performer NATURAL JOIN performance ON artist.artist_performer_id = performer.performer_id),
B (artist_id, performance_id) AS (SELECT artist_id, performance_id FROM artist NATURAL JOIN members NATURAL JOIN band_perf),
art_perf (artist_id, performance_id) AS (SELECT * FROM A UNION SELECT * FROM B)
SELECT visitor_id, artist_id, review_interpretation + review_overall_impression AS score FROM visitor NATURAL JOIN review NATURAL JOIN art_perf
ORDER BY score DESC
LIMIT 5;
