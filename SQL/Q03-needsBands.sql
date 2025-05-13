SELECT festival_id, artist_id FROM (SELECT * FROM artist natural join performer NATURAL JOIN performance NATURAL JOIN music_event
WHERE performance_type="Warm-up") AS BRUUUUUUUH
GROUP BY festival_id, artist_id
HAVING COUNT(artist_id) > 2;
