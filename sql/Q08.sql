SELECT DISTINCT staff_id AS ID, staff_name AS Name FROM staff
WHERE staff_id NOT IN (SELECT staff_id FROM staff NATURAL JOIN worksIn NATURAL JOIN performance NATURAL JOIN music_event
WHERE music_event_date = '2021-11-02');
