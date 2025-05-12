SET @artist_id = 12;
WITH band_rev AS (SELECT band_id, review_interpretation AS interpretation, review_overall_impression AS overall_impression
		FROM band FORCE INDEX(band_id) INNER JOIN performance FORCE INDEX(perf_event_idx) NATURAL JOIN review FORCE INDEX(review_visitor_idx)
        ON band.band_performer_id = performance.performer_id ),
	A AS (SELECT artist_id, review_interpretation AS interpretation, review_overall_impression AS overall_impression
		FROM artist FORCE INDEX(artist_id) INNER JOIN performance FORCE INDEX(perf_event_idx) NATURAL JOIN review FORCE INDEX(review_visitor_idx)
        ON artist.artist_performer_id = performance.performer_id
        WHERE artist_id = @artist_id),
	B AS (SELECT artist_id, interpretation, overall_impression
		FROM artist FORCE INDEX(artist_id) NATURAL JOIN members NATURAL JOIN band_rev
        WHERE artist_id = @artist_id),
	art_rev AS (SELECT * FROM A UNION SELECT * FROM B)
SELECT artist_name AS 'Name', AVG(interpretation) AS 'Average Interpretation', AVG(overall_impression) AS 'Average Overall Impression'
	FROM artist FORCE INDEX(artist_idx) LEFT JOIN art_rev
	ON artist.artist_id = art_rev.artist_id
	WHERE artist.artist_id = @artist_id
	GROUP BY artist_name;