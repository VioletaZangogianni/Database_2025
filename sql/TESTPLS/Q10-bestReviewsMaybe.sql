WITH g_art (genre_id, artist_id) AS (SELECT genre_id, artist_id FROM genres NATURAL JOIN art2genre NATURAL JOIN artist),
band_perf (band_id, performance_id) AS (SELECT band_id, performance_id FROM band INNER JOIN performer NATURAL JOIN performance ON band.band_performer_id = performer.performer_id),
A (genre_id, artist_id, rev) AS (SELECT genre_id, artist_id, review_overall_impression + review_interpretation FROM art2genre NATURAL JOIN artist INNER JOIN performer NATURAL JOIN performance NATURAL JOIN review ON artist.artist_performer_id = performer.performer_id),
B (genre_id, artist_id, rev) AS (SELECT genre_id, artist_id, review_overall_impression + review_interpretation FROM art2genre NATURAL JOIN artist NATURAL JOIN members NATURAL JOIN band_perf NATURAL JOIN review),
g_art_perf (genre_id, artist_id, rev) AS (SELECT * FROM A UNION SELECT * FROM B)

SELECT G1.genre_id AS g1, G2.genre_id AS g2, AVG(G1.rev) AS score FROM g_art_perf G1, g_art_perf G2 WHERE G1.artist_id = G2.artist_id
GROUP BY g1, g2
ORDER BY score DESC
LIMIT 3;
