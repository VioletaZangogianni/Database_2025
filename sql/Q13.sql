WITH band_perf AS (SELECT band_id, music_event_id
		FROM band INNER JOIN performance
        ON band.band_performer_id = performance.performer_id),
	A AS (SELECT artist_id, artist_name, location_continent AS continent
		FROM artist INNER JOIN performance NATURAL JOIN music_event NATURAL JOIN festival NATURAL JOIN location
        ON artist.artist_performer_id = performance.performer_id),
	B AS (SELECT artist_id, artist_name, location_continent AS continent
		FROM artist NATURAL JOIN members NATURAL JOIN band_perf NATURAL JOIN music_event NATURAL JOIN festival
			NATURAL JOIN location),
	art_cont AS (SELECT * FROM A UNION SELECT * FROM B)
SELECT artist_id AS ID, artist_name AS 'Name', COUNT(continent) AS different_continents
	FROM art_cont
	GROUP BY artist_id, artist_name
	HAVING different_continents >= 3;