WITH band_rev (band_id, interpretation, overall_impression) AS (SELECT band_id, review_interpretation, review_overall_impression FROM band INNER JOIN performer NATURAL JOIN performance NATURAL JOIN review ON band.band_performer_id = performer_id),
A (artist_id, artist_name, interpretation, overall_impression) AS (SELECT artist_id, artist_name, review_interpretation, review_overall_impression FROM artist INNER JOIN performer NATURAL JOIN performance NATURAL JOIN review ON artist.artist_performer_id = performer.performer_id),
B (artist_id, artist_name, interpretation, overall_impression) AS (SELECT artist_id, artist_name, interpretation, overall_impression FROM artist NATURAL JOIN members NATURAL JOIN band_rev),
art_rev AS (SELECT * FROM A UNION SELECT * FROM B)
SELECT artist_name AS 'Name', AVG(interpretation) AS 'Average Interpretation', AVG(overall_impression) AS 'Average Overall Impression' FROM art_rev
WHERE artist_id = 1
GROUP BY artist_name;
