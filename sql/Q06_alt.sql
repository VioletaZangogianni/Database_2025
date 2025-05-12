SET @visitor_id = 2;
WITH rev_event AS (SELECT visitor_id, music_event_id,
		(review_interpretation + review_sound_and_lighting + review_stage_presence + review_organization + review_overall_impression) AS score
	FROM review FORCE INDEX(review_visitor_idx) NATURAL JOIN performance FORCE INDEX(performer_idx) NATURAL JOIN music_event FORCE INDEX(festival_idx)
	WHERE visitor_id = @visitor_id)
SELECT music_event_id, score/5 AS 'Average Review'
	FROM visitor LEFT JOIN rev_event
	ON visitor.visitor_id = rev_event.visitor_id
	WHERE visitor.visitor_id = @visitor_id;
