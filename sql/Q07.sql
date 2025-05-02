WITH fest_staff (fest_year, fest_name, staff_id, experience_level) AS (SELECT festival_fest_year, festival_name, staff_id, staff_levels_id FROM festival NATURAL JOIN music_event NATURAL JOIN worksIn NATURAL JOIN staff NATURAL JOIN staff_levels GROUP BY festival_fest_year, festival_name, staff_id HAVING COUNT(*) > 0)
SELECT fest_year AS 'Year', AVG(experience_level) AS average_exp_level FROM fest_staff
GROUP BY fest_year
ORDER BY average_exp_level ASC
LIMIT 1;
