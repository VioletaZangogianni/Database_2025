WITH vis_event (visitor_id, shows) AS (SELECT visitor_id, COUNT(DISTINCT music_event_id) FROM visitor NATURAL JOIN ticket NATURAL JOIN music_event WHERE music_event_date BETWEEN '2025-3-3' AND DATEADD(music_event.music_event_date, INTERVAL 1 YEAR) GROUP BY visitor_id)
SELECT V.shows, V.visitor_id FROM vis_event V
WHERE V.shows IN (SELECT shows FROM vis_event WHERE visitor_id <> V.visitor_id) AS TMP
ORDER BY V.shows ASC;
