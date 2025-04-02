SELECT distinct staff_id FROM staff
WHERE staff_id NOT IN (SELECT staff_id FROM staff NATURAL JOIN performance NATURAL JOIN music_event
WHERE music_event_date = '2017-5-16');