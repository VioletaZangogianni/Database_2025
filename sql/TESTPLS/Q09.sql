WITH vis_event (visitor_id, shows) AS (SELECT visitor_id, COUNT(DISTINCT music_event_id) FROM visitor NATURAL JOIN ticket NATURAL JOIN music_event WHERE music_event_date BETWEEN '2025-3-3' AND DATEADD(music_event.music_event_date, INTERVAL 1 YEAR) GROUP BY visitor_id)
SELECT V1.visitor_id, V2.visitor_id, V1.shows FROM vis_event V1, vis_event V2
WHERE V1.shows = V2.shows AND V1.shows >= 3
ORDER BY V1.shows ASC;
