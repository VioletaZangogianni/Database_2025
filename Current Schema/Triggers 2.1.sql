DELIMITER //
CREATE TRIGGER enoughStaffUpd AFTER UPDATE ON worksIn FOR EACH ROW
BEGIN
	CALL checkEnoughStaff(NEW.music_event_id);
END;
//
DELIMITER ;

DELIMITER //
CREATE TRIGGER enoughStaffDel AFTER DELETE ON worksIn FOR EACH ROW
BEGIN
	CALL checkEnoughStaff(OLD.music_event_id);
END;
//
DELIMITER ;

DELIMITER //
CREATE TRIGGER staffInsert BEFORE INSERT ON worksIn FOR EACH ROW
BEGIN
	CALL checkStaffOverlap(NEW.staff_id, NEW.music_event_id);
END;
//
DELIMITER ;

DELIMITER //
CREATE TRIGGER event_date BEFORE INSERT ON music_event FOR EACH ROW
BEGIN
	IF NOT EXISTS
		(SELECT * FROM festival WHERE festival_id = NEW.festival_id
			AND NEW.music_event_date BETWEEN festival_start_date AND festival_end_date) THEN
				SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Event Date Error';
	END IF;
END;
//
DELIMITER ;

DELIMITER //
CREATE TRIGGER checkPerformances BEFORE INSERT ON performance FOR EACH ROW
BEGIN
	DECLARE perfEndTime BIGINT;
    
    SET NEW.performance_end_time = ADDTIME(NEW.performance_start_time, SEC_TO_TIME(NEW.performance_duration * 60));
    
	CALL checkBreak(NEW.music_event_id, NEW.performance_start_time);
    CALL checkStageOverlap(NEW.music_event_id, NEW.performance_start_time, NEW.performance_end_time);
    CALL checkArtistOverlap(NEW.performer_id, NEW.music_event_id, NEW.performance_start_time, NEW.performance_end_time);
END;
//
DELIMITER ;

DELIMITER //
CREATE TRIGGER checkArtistYears AFTER INSERT ON performance FOR EACH ROW
BEGIN
	CALL checkArtistStreak();
    
    UPDATE music_event SET music_event_end_time = NEW.performance_end_time
		WHERE music_event_id = NEW.music_event_id;
END;
//
DELIMITER ;

DELIMITER //
CREATE TRIGGER createPerformerA BEFORE INSERT ON artist FOR EACH ROW
BEGIN
	DECLARE idCreated BIGINT;
    
    INSERT INTO performer(performer_name, performer_type) VALUES (NEW.artist_name, 'A');
    SELECT performer_id INTO idCreated FROM performer WHERE performer_name = NEW.artist_name;
    
    SET NEW.artist_performer_id = idCreated;
END;
//
DELIMITER ;

DELIMITER //
CREATE TRIGGER createPerformerB BEFORE INSERT ON band FOR EACH ROW
BEGIN
	DECLARE idCreated BIGINT;
    
    INSERT INTO performer(performer_name, performer_type) VALUES (NEW.band_name, 'B');
    SELECT performer_id INTO idCreated FROM performer WHERE performer_name = NEW.band_name;
    
    SET NEW.band_performer_id = idCreated;
END;
//
DELIMITER ;

DELIMITER //
CREATE TRIGGER checkTickets BEFORE INSERT ON ticket FOR EACH ROW
BEGIN
	DECLARE eventDate DATE;
    DECLARE capacity BIGINT;
    
    SELECT music_event_date INTO eventDate FROM music_event WHERE NEW.music_event_id = music_event_id;
    SELECT stage_capacity INTO capacity FROM music_event NATURAL JOIN stage WHERE NEW.music_event_id = music_event_id LIMIT 1;

    CALL checkEAN(NEW.ticket_EAN_13_code);

    IF NEW.ticket_status = 'FOR SALE' THEN
		SET NEW.ticket_status = 'NOT USED';
	END IF;
    
    IF EXISTS (SELECT * FROM ticket WHERE visitor_id = NEW.visitor_id AND music_event_id = NEW.music_event_id) THEN
		SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Visitor Already Owns Ticket';
    END IF;
    
	IF EXISTS (SELECT * FROM ticket NATURAL JOIN music_event
					WHERE visitor_id = NEW.visitor_id AND music_event_date = eventDate) THEN
						SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Visitor Already Owns Ticket';
    END IF;
    
	IF (SELECT COUNT(*) + 1 FROM
		ticket NATURAL JOIN music_event WHERE music_event_id = NEW.music_event_id) > capacity THEN
			SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Too Many Tickets';
	END IF;
    
    IF NEW.ticketType_type = 'VIP' THEN
		SET capacity = CEILING(capacity * 0.1);
		IF (SELECT COUNT(*) + 1 FROM
			ticket WHERE music_event_id = NEW.music_event_id AND ticketType_type = 'VIP') > capacity THEN
				SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Too Many VIP';
		END IF;
	END IF;
END;
//
DELIMITER ;


DELIMITER //
CREATE TRIGGER valid_review BEFORE INSERT ON review FOR EACH ROW
BEGIN
	IF NOT EXISTS
		(SELECT * FROM ticket NATURAL JOIN music_event NATURAL JOIN performance
			WHERE visitor_id = NEW.visitor_id AND performance_id = NEW.performance_id AND ticket_status = 'USED') THEN
				SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Review Error';
	END IF;
END;
//
DELIMITER ;


DELIMITER //
CREATE TRIGGER valid_seller BEFORE INSERT ON seller FOR EACH ROW
BEGIN
	DECLARE eventId BIGINT;
    SELECT music_event_id INTO eventId
		FROM music_event NATURAL JOIN ticket WHERE NEW.ticket_id = ticket_id;
    
    CALL checkSoldOut(eventId, @soldout);
    IF @soldout = FALSE THEN
		SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Tickets Not Sold Out';
	END IF;
    
	IF NOT EXISTS
		(SELECT * FROM ticket WHERE ticket_id = NEW.ticket_id AND visitor_id = NEW.visitor_id AND ticket_status = 'NOT USED') THEN
			SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Seller Error';
	END IF;
    
    SET NEW.seller_sold = 'N';
    
    CALL findBuyer(NEW.ticket_id, @result);
        
	IF @result = 1 THEN
		SET NEW.seller_sold = 'Y';
	END IF;
END;
//
DELIMITER ;

DELIMITER //
CREATE TRIGGER insertOnBuyer BEFORE INSERT ON buyer FOR EACH ROW
BEGIN
	DECLARE eventId BIGINT;
    SELECT music_event_id INTO eventId FROM music_event WHERE music_event_id = NEW.music_event_id;
    
    CALL checkSoldOut(eventId, @soldout);
    IF @soldout = FALSE THEN
		SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Tickets Not Sold Out';
	END IF;


	IF (NEW.ticket_id IS NOT NULL) AND NOT EXISTS (SELECT * FROM ticket
		WHERE NEW.ticket_id = ticket_id AND NEW.music_event_id = music_event_id AND NEW.ticketType_type = ticketType_type) THEN
			SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Ticket Information Incorrect';
	END IF;
    IF NEW.ticket_id IS NOT NULL AND
		NOT EXISTS (SELECT * FROM resaleQueue WHERE ticket_id = NEW.ticket_id) THEN
			SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Ticket Not Available for Resale';
	END IF;

	SET NEW.buyer_timeInserted = CURRENT_TIMESTAMP;
    SET NEW.buyer_sold = 'N';
    
    CALL findTicket(NEW.visitor_id, NEW.music_event_id, NEW.ticketType_type, NEW.ticket_id, @result);
    
    IF @result = 1 THEN
		IF (SELECT COUNT(*) FROM ticket WHERE visitor_id = NEW.visitor_id AND music_event_id = NEW.music_event_id) > 1 THEN
			SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Already Owns Ticket';
        END IF;
    
		SET NEW.buyer_sold = 'Y';
    END IF;
END;
//
DELIMITER ;
