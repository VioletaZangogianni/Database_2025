SET @event_date = '2028-09-14';
WITH support AS (SELECT staff_id, staff_name FROM staff WHERE role_staff_desc = 'Support')
SELECT staff_id AS ID, staff_name AS 'Name' FROM support
WHERE staff_id NOT IN (SELECT staff_id FROM support NATURAL JOIN worksIn NATURAL JOIN music_event
WHERE music_event_date = @event_date);
