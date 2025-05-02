SET @artist_id = 1;
WITH band_rev AS (SELECT band_id, review_interpretation AS interpretation, review_overall_impression AS overall_impression FROM band INNER JOIN performer ON band.band_performer_id = performer_id NATURAL JOIN performance NATURAL JOIN review),
A (artist_id, interpretation, overall_impression) AS (SELECT artist_id, review_interpretation, review_overall_impression FROM artist INNER JOIN performer ON artist.artist_performer_id = performer.performer_id NATURAL JOIN performance NATURAL JOIN review WHERE artist_id = @artist_id),
B (artist_id, interpretation, overall_impression) AS (SELECT artist_id, interpretation, overall_impression FROM artist NATURAL JOIN members NATURAL JOIN band_rev WHERE artist_id = @artist_id),
art_rev AS (SELECT * FROM A UNION SELECT * FROM B)
SELECT artist_name AS 'Name', AVG(interpretation) AS 'Average Interpretation', AVG(overall_impression) AS 'Average Overall Impression'
FROM artist LEFT JOIN art_rev
ON artist.artist_id = art_rev.artist_id
WHERE artist.artist_id = @artist_id
GROUP BY artist_name;
