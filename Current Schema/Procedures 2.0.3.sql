DELIMITER //
CREATE PROCEDURE checkEnoughStaff(eventId BIGINT)
BEGIN
	DECLARE capacity BIGINT;
    DECLARE minSecurity, minSupport BIGINT;
    
    DECLARE currentSecurity, currentSupport BIGINT;
    DECLARE staffType VARCHAR(20);
    
    SELECT stage_capacity INTO capacity FROM music_event NATURAL JOIN stage WHERE music_event_id = eventId;
    SET minSecurity = CEILING(0.05 * capacity);
    SET minSupport = CEILING(0.02 * capacity);
    
    SELECT COUNT(*) INTO currentSecurity
		FROM worksIn NATURAL JOIN staff WHERE eventId = music_event_id AND role_staff_desc = 'Security';
    SELECT COUNT(*) INTO currentSupport
		FROM worksIn NATURAL JOIN staff WHERE eventId = music_event_id AND role_staff_desc = 'Support';
    
    IF currentSecurity < minSecurity THEN
		SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Not Enough Security';
	END IF;
    
	IF currentSupport < minSupport THEN
		SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Not Enough Support Workers';
	END IF;
END;
//
DELIMITER ;

DELIMITER //
CREATE PROCEDURE checkStaffOverlap(staffId BIGINT, eventId BIGINT)
BEGIN
	DECLARE eventDate DATE;
    DECLARE eventStart TIME;
    DECLARE eventEnd TIME;
    
    SELECT music_event_date INTO eventDate
		FROM music_event WHERE music_event_id = eventId;
	SELECT music_event_time INTO eventStart
		FROM music_event WHERE music_event_id = eventId;
	SELECT music_event_end_time INTO eventEnd
		FROM music_event WHERE music_event_id = eventId;
    
    DROP TEMPORARY TABLE IF EXISTS SameDayStaff;
    CREATE TEMPORARY TABLE SameDayStaff AS
	SELECT music_event_time, music_event_end_time FROM
		worksIn NATURAL JOIN music_event WHERE staff_id = staffId AND music_event_date = eventDate;
    
    IF EXISTS
		(SELECT * FROM SameDayStaff WHERE
			NOT(eventStart > SameDayStaff.music_event_end_time OR eventEnd < SameDayStaff.music_event_time)) THEN
				SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Staff working at the same time';
	END IF;
END;
//

DELIMITER //
CREATE PROCEDURE checkBreak(event_id BIGINT, perfStart TIME)
BEGIN
	DECLARE previousTime TIME;
	DECLARE eventTime TIME;
    DECLARE break BIGINT;
    
    SELECT performance_end_time INTO previousTime
		FROM performance NATURAL JOIN music_event WHERE music_event_id = event_id ORDER BY performance_end_time DESC LIMIT 1;
    
    SELECT music_event_time INTO eventTime
		FROM music_event WHERE music_event_id = event_id;
    
	IF previousTime IS NULL THEN
		IF perfStart != eventTime THEN
			SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'First Performace Must Begin At the Start of the Event';
		END IF;
	ELSE
		SET break = TIME_TO_SEC(TIMEDIFF(perfStart, previousTime));
        
        IF break < 5 * 60 THEN
			SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Break Too Short';
		END IF;
		IF break >  30 * 60 THEN
			SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Break Too Long';
		END IF;
    END IF;
END;
//

DELIMITER //
CREATE PROCEDURE checkStageOverlap(event_id BIGINT, perfStartTime TIME, perfEndTime TIME)
BEGIN
	DECLARE stageId BIGINT;
    DECLARE eventDate DATE;
    
    SELECT stage_id INTO stageId
		FROM music_event WHERE music_event_id = event_id;
    SELECT music_event_date INTO eventDate
		FROM music_event WHERE music_event_id = event_id;
    
    DROP TEMPORARY TABLE IF EXISTS SameDayPerformances;
    CREATE TEMPORARY TABLE SameDayPerformances AS
		SELECT * FROM performance NATURAL JOIN music_event
			WHERE stage_id = stageId AND music_event_date = eventDate;
    
    IF EXISTS
		(SELECT * FROM SameDayPerformances WHERE
			NOT(perfStartTime > SameDayPerformances.performance_end_time OR perfEndTime < SameDayPerformances.performance_start_time)) THEN
				SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Stage is in use';
	END IF;
END;
//

DELIMITER //
CREATE PROCEDURE checkArtistOverlap(performerId BIGINT, event_id BIGINT, perfStartTime TIME, perfEndTime TIME)
BEGIN
	DECLARE eventDate DATE;
    DECLARE eventYear YEAR;
    
    SELECT music_event_date INTO eventDate
		FROM music_event WHERE music_event_id = event_id;
	SET eventYear = YEAR(eventDate);
    
    DROP TEMPORARY TABLE IF EXISTS CurrentPerformers;
	CREATE TEMPORARY TABLE CurrentPerformers AS
	WITH 
		A AS (SELECT artist_id FROM artist WHERE artist_performer_id = performerId),
		B AS (SELECT artist_id FROM band NATURAL JOIN members WHERE band_performer_id = performerId)
	(SELECT * FROM A) UNION (SELECT * FROM B);
    
    
    DROP TEMPORARY TABLE IF EXISTS SameDayPerformers;
    CREATE TEMPORARY TABLE SameDayPerformers AS
	WITH 
		A AS (SELECT * FROM music_event NATURAL JOIN performance NATURAL JOIN (performer JOIN artist ON artist_performer_id = performer_id)
			WHERE music_event_date = eventDate),
		B AS (SELECT * FROM music_event NATURAL JOIN performance NATURAL JOIN (performer JOIN band ON band_performer_id = performer_id) NATURAL JOIN members NATURAL JOIN artist
			WHERE music_event_date = eventDate)
	(SELECT artist_id, performance_start_time, performance_end_time FROM A) UNION (SELECT artist_id, performance_start_time, performance_end_time FROM B);
    
    
    DELETE FROM SameDayPerformers WHERE artist_id <> ALL(SELECT * FROM CurrentPerformers);
    IF EXISTS
		(SELECT * FROM SameDayPerformers WHERE
			NOT(perfStartTime > SameDayPerformers.performance_end_time OR perfEndTime < SameDayPerformers.performance_start_time)) THEN
				SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Artist performing at the same time';
	END IF;
END;
//

DELIMITER //
CREATE PROCEDURE checkArtistStreak()
BEGIN
	DROP TEMPORARY TABLE IF EXISTS YearsPerformed;
    CREATE TEMPORARY TABLE YearsPerformed AS
    WITH
		A AS (SELECT * FROM music_event NATURAL JOIN (performance JOIN artist ON artist_performer_id = performer_id)),
		B AS (SELECT * FROM music_event NATURAL JOIN (performance JOIN band ON band_performer_id = performer_id) NATURAL JOIN members)
	(SELECT artist_id, YEAR(music_event_date) AS eventYear FROM A) UNION (SELECT artist_id, YEAR(music_event_date) AS eventYear FROM B);
    
    DROP TEMPORARY TABLE IF EXISTS YearsPerformedNumbered;
    CREATE TEMPORARY TABLE YearsPerformedNumbered AS
    SELECT artist_id, eventYear, ROW_NUMBER() OVER (PARTITION BY artist_id ORDER BY eventYear) AS rowNum
		FROM YearsPerformed;
        
	IF EXISTS (SELECT artist_id, eventYear - rowNum FROM YearsPerformedNumbered GROUP BY artist_id, eventYear - rowNum HAVING COUNT(*) > 3) THEN
		SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Artist performing for more than 3 years in a row';
    END IF;
END;
//


DELIMITER //
CREATE PROCEDURE checkSoldOut(eventId BIGINT, OUT isSoldOut BOOL)
BEGIN
	DECLARE capacity BIGINT;
    DECLARE soldTickets BIGINT;
    
    SELECT stage_capacity INTO capacity FROM music_event NATURAL JOIN stage WHERE eventId = music_event_id LIMIT 1;
    SELECT COUNT(*) INTO soldTickets FROM ticket NATURAL JOIN music_event WHERE music_event_id = eventId;
    
    SET isSoldOut = FALSE;
    IF soldTickets = capacity THEN
		SET isSoldOut = TRUE;
	END IF;
END;
//
DELIMITER ;

DELIMITER //
CREATE PROCEDURE checkEAN(ticket_code BIGINT)
BEGIN
	DECLARE odd BIGINT;
    DECLARE even BIGINT;
    DECLARE errorDigit BIGINT;
    
	DROP TEMPORARY TABLE IF EXISTS Digits;
    CREATE TEMPORARY TABLE Digits AS
		SELECT num mod POWER(10, 1)  div POWER(10, 0)  AS d0 ,
               num mod POWER(10, 2)  div POWER(10, 1)  AS d1 ,
	           num mod POWER(10, 3)  div POWER(10, 2)  AS d2 ,
	           num mod POWER(10, 4)  div POWER(10, 3)  AS d3 ,
	           num mod POWER(10, 5)  div POWER(10, 4)  AS d4 ,
               num mod POWER(10, 6)  div POWER(10, 5)  AS d5 ,
               num mod POWER(10, 7)  div POWER(10, 6)  AS d6 ,
               num mod POWER(10, 8)  div POWER(10, 7)  AS d7 ,
               num mod POWER(10, 9)  div POWER(10, 8)  AS d8 ,
               num mod POWER(10, 10) div POWER(10, 9)  AS d9 ,
               num mod POWER(10, 11) div POWER(10, 10) AS d10,
               num mod POWER(10, 12) div POWER(10, 11) AS d11,
               num mod POWER(10, 13) div POWER(10, 12) AS d12
		FROM (SELECT ticket_code AS num) AS Digits;
        
        SELECT (d12 + d10 + d8 + d6 + d4 + d2) INTO odd FROM Digits;
        SELECT (d11 + d9  + d7 + d5 + d3 + d1)  INTO even FROM Digits;
        
        SELECT (10 - ((odd + 3 * even) % 10)) % 10 INTO errorDigit FROM Digits;
        
        IF errorDigit != (SELECT d0 FROM Digits LIMIT 1) THEN
			SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Wrong EAN Code';
        END IF;
END;
//
DELIMITER ;


DELIMITER //
CREATE PROCEDURE findBuyer(ticket BIGINT, OUT result BIGINT)
BEGIN
	DECLARE event_id BIGINT;
    DECLARE tckt_type VARCHAR(20);
    DECLARE potentialBuyer BIGINT;
    
    SELECT music_event_id, ticketType_type INTO event_id, tckt_type
		FROM ticket NATURAL JOIN music_event WHERE ticket_id = ticket LIMIT 1;
    
    SELECT visitor_id INTO potentialBuyer
		FROM buyer WHERE music_event_id = event_id AND ticketType_type = tckt_type AND buyer_sold = 'N' ORDER BY buyer_timeInserted LIMIT 1;
    
    IF potentialBuyer IS NOT NULL THEN
		UPDATE ticket SET visitor_id = potentialBuyer, ticket_status = 'NOT USED' WHERE ticket_id = ticket;
        UPDATE buyer SET buyer_sold = 'Y' WHERE visitor_id = potentialBuyer;
        SET result = 1;
	ELSE
		UPDATE ticket SET ticket_status = 'FOR SALE' WHERE ticket_id = ticket;
		INSERT INTO resaleQueue(ticket_id, resaleQueue_timeInserted) VALUES (ticket,  CURRENT_TIMESTAMP);
        SET result = 0;
    END IF;
    
END;
//
DELIMITER ;


DELIMITER //
CREATE PROCEDURE findTicket(buyer BIGINT, event_id BIGINT, tckt_type VARCHAR(20), OUT result BIGINT)
BEGIN
	DECLARE potentialTicket BIGINT;
    
    SELECT ticket_id INTO potentialTicket
		FROM resaleQueue NATURAL JOIN ticket NATURAL JOIN music_event
			WHERE music_event_id = event_id AND ticketType_type = tckt_type ORDER BY resaleQueue_timeInserted LIMIT 1;
    
    IF potentialTicket IS NOT NULL THEN
		UPDATE ticket SET visitor_id = buyer, ticket_status = 'NOT USED' WHERE ticket_id = potentialTicket;
        DELETE FROM resaleQueue WHERE ticket_id = potentialTicket;
        UPDATE seller SET seller_sold = 'Y' WHERE ticket_id = potentialTicket;
		SET result = 1;
	ELSE
		SET result = 0;
	END IF;
END;
//
DELIMITER ;
