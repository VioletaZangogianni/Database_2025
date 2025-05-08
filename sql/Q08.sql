SET @event_date = '2028-09-14';
SELECT DISTINCT staff_id AS ID, staff_name AS Name FROM staff
WHERE staff_id NOT IN (SELECT staff_id FROM staff NATURAL JOIN worksIn NATURAL JOIN music_event
WHERE music_event_date = @event_date);
