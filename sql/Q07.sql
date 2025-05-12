WITH fest_staff AS (SELECT festival_fest_year AS fest_year, festival_name AS fest_name, staff_id,
		staff_levels_id AS experience_level
	FROM festival NATURAL JOIN music_event NATURAL JOIN worksIn NATURAL JOIN staff NATURAL JOIN staff_levels
    GROUP BY fest_year, fest_name, staff_id
    HAVING COUNT(*) > 0)
SELECT fest_year, fest_name AS 'Festival', AVG(experience_level) AS average_exp_level
	FROM fest_staff
	GROUP BY fest_year, fest_name
	ORDER BY average_exp_level ASC
	LIMIT 1;