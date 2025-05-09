SET @start_date := '2019-09-12';
WITH vis_event AS (SELECT visitor_id, CONCAT(visitor_name, ' ', visitor_surname) AS visitor_name, COUNT(DISTINCT music_event_id) AS shows FROM visitor NATURAL JOIN ticket NATURAL JOIN music_event WHERE music_event_date BETWEEN @start_date AND DATE_ADD(@start_date, INTERVAL 1 YEAR) GROUP BY visitor_id, visitor_name HAVING shows >= 3)
SELECT V.shows AS Shows, V.visitor_id AS ID, V.visitor_name AS 'Name' FROM vis_event V
WHERE V.shows IN (SELECT shows FROM vis_event WHERE visitor_id <> V.visitor_id)
ORDER BY V.shows ASC;
