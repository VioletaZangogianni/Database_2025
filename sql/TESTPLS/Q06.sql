SELECT visitor_id, music_event_id, AVG((interpretation + sound_and_lighting + stage_presence + review_organization + overall_impression)/5) AS avg_rev
FROM visitor NATURAL JOIN review
NATURAL JOIN performance NATURAL JOIN music_event
GROUP BY visitor_id, music_event_id
WHERE visitor_id = 5;
