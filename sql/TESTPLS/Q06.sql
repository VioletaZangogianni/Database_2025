SELECT visitor_id AS 'ID', visitor_name AS 'Name', music_event_id, AVG((review_interpretation + review_sound_and_lighting + review_stage_presence + review_organization + review_overall_impression)/5) AS 'Average Review'
FROM visitor NATURAL JOIN review NATURAL JOIN performance NATURAL JOIN music_event
GROUP BY visitor_id, visitor_name, music_event_id
HAVING visitor_id = 5;
