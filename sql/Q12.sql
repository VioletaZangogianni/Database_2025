SET @f_id := 2;
WITH date_cap AS (SELECT music_event_date AS event_date, SUM(stage_capacity) AS capacity
		FROM music_event NATURAL JOIN stage
        WHERE festival_id = @f_id
        GROUP BY music_event_date),
	date_all AS (SELECT music_event_date AS event_date, staff_id, role_staff_desc
		FROM staff NATURAL JOIN worksIn NATURAL JOIN music_event
        WHERE festival_id = @f_id),
    date_tech AS (SELECT event_date, COUNT(staff_id) AS tech
		FROM date_all
        WHERE role_staff_desc = 'Technical'
        GROUP BY event_date),
	date_sec AS (SELECT event_date, COUNT(staff_id) AS sec
		FROM date_all
        WHERE role_staff_desc = 'Security'
        GROUP BY event_date),
	date_sup AS (SELECT event_date, COUNT(staff_id) AS sup
		FROM date_all
        WHERE role_staff_desc = 'Support'
        GROUP BY event_date),
	date_act AS (SELECT * FROM date_tech NATURAL JOIN date_sec NATURAL JOIN date_sup),
	all_staff AS (SELECT event_date, CEILING(capacity/20) AS sec_needs,
			CEILING(capacity/50) AS sup_needs, sec, sup, tech
        FROM date_cap NATURAL JOIN date_act)
SELECT event_date AS 'Day', sec_needs + sup_needs AS 'Total Needed', sup_needs AS 'Support Needed',
		sup AS 'Actual Support', sec_needs AS 'Security Needed', sec AS 'Actual Security', tech AS 'Actual Technicians'
	FROM all_staff;
