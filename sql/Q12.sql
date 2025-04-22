SET @f_id := 2;

WITH day_ticket (event_day, audience) AS (SELECT music_event_date, COUNT(ticket_id) FROM music_event NATURAL JOIN ticket WHERE festival_id = @f_id GROUP BY music_event_date),
day_needs (event_day, security_needed, technicians_needed) AS (SELECT event_day, CEILING(audience/20) AS security_needed, CEILING(audience/50) AS technicians_needed FROM day_ticket)

SELECT event_day AS 'Day', security_needed + technicians_needed AS 'Staff Needed', security_needed AS 'Security Needed', technicians_needed AS 'Technicians Needed' FROM day_needs;
