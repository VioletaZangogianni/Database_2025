SET @f_id := 2;
WITH day_ticket AS (SELECT music_event_date AS event_date, COUNT(ticket_id) AS audience FROM music_event NATURAL JOIN ticket WHERE festival_id = @f_id GROUP BY music_event_date),
day_needs AS (SELECT event_date, CEILING(audience/20) AS security_needed, CEILING(audience/50) AS support_needed FROM day_ticket)
SELECT event_date AS 'Day', security_needed + support_needed AS 'Staff Needed', security_needed AS 'Security Needed', support_needed AS 'Support Needed'
	FROM day_needs ORDER BY event_date ASC;
