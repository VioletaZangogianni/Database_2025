SET @start_date := '2019-09-12';
WITH vis_event (visitor_id, visitor_name, shows) AS (SELECT visitor_id, CONCAT(visitor_name, ' ', visitor_surname) AS full_name, COUNT(DISTINCT music_event_id) FROM visitor NATURAL JOIN ticket NATURAL JOIN music_event WHERE music_event_date BETWEEN @start_date AND DATE_ADD(@start_date, INTERVAL 1 YEAR) GROUP BY visitor_id, full_name)
SELECT V.shows AS Shows, V.visitor_id AS ID, V.visitor_name AS 'Name' FROM vis_event V
WHERE V.shows IN (SELECT shows FROM vis_event WHERE visitor_id <> V.visitor_id AND shows >= 3)
ORDER BY V.shows ASC;
