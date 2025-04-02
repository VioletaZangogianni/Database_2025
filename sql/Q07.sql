SELECT ID, AVG(experience_level) AS tmp FROM 
(SELECT DISTINCT festival.festival_id AS ID, staff.staff_id AS yolo, staff.experience_level FROM festival natural JOIN music_event NATURAL JOIN performance natural join staff) AS GOTOHELL
GROUP BY ID;