SET @visitor_id = 12;
WITH rev_event AS (SELECT visitor_id, music_event_id, (review_interpretation + review_sound_and_lighting + review_stage_presence + review_organization + review_overall_impression) AS score FROM review NATURAL JOIN performance NATURAL JOIN music_Event WHERE visitor_id = @visitor_id)
SELECT music_event_id, AVG(score) AS 'Average Review' FROM visitor LEFT JOIN rev_event ON visitor.visitor_id = rev_event.visitor_id
WHERE visitor.visitor_id = @visitor_id
GROUP BY music_event_id;
