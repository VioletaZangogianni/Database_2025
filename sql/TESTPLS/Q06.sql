SELECT visitor_id, music_event_id, AVG((review_interpretation + review_sound_and_lighting + review_stage_presence + review_organization + review_overall_impression)/5) AS avg_rev
FROM visitor NATURAL JOIN review
NATURAL JOIN performance NATURAL JOIN music_event
GROUP BY visitor_id, music_event_id
HAVING visitor_id = 5;
