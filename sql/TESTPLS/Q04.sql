WITH band_rev (band_id, interpretation, overall_impression) AS (SELECT band_id, review_interpretation, review_overall_impression FROM band INNER JOIN performer NATURAL JOIN performance NATURAL JOIN review ON band.band_performer_id = performer_id),
A (artist_id, interpretation, overall_impression) AS (SELECT artist_id, review_interpretation, review_overall_impression FROM artist INNER JOIN performer NATURAL JOIN performance NATURAL JOIN review ON artist.artist_performer_id = performer.performer_id),
B (artist_id, interpretation, overall_impression) AS (SELECT artist_id, interpretation, overall_impression FROM artist NATURAL JOIN members NATURAL JOIN band_rev),
art_rev AS (SELECT * FROM A UNION SELECT * FROM B)
SELECT AVG(interpretation) AS avg_int, AVG(overall_impression) AS avg_ov_imp FROM art_rev
WHERE artist_id = 1;
