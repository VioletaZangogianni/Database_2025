WITH fest_staff (fest_year, staff_id, experience_level) AS (SELECT DISTINCT festival_fest_year, staff_id, lvl_id FROM festival NATURAL JOIN music_event NATURAL JOIN performance NATURAL JOIN worksIn NATURAL JOIN staff
SELECT fest_year, AVG(experience_level) AS average_experience_level FROM fest_staff
GROUP BY fest_year
ORDER BY average_experience_level ASC
LIMIT 1;
