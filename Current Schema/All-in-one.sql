DROP SCHEMA IF EXISTS music_festival_ntua; 
CREATE SCHEMA music_festival_ntua;
USE music_festival_ntua;

DROP TABLE IF EXISTS location;
CREATE TABLE location (
  location_id BIGINT NOT NULL AUTO_INCREMENT,
  location_address VARCHAR(20) NOT NULL UNIQUE,
  location_coordinates VARCHAR(20) NOT NULL UNIQUE, 
  location_city VARCHAR(20) NOT NULL,
  location_country VARCHAR(20) NOT NULL,
  location_continent VARCHAR(20) CHECK (location_continent IN ('Europe', 'America', 'Asia', 'Africa', 'Oceania', 'Arctica', 'Antarctica')), 
  PRIMARY KEY(location_id)
);

DROP TABLE IF EXISTS festival;
CREATE TABLE festival (
  festival_id BIGINT NOT NULL AUTO_INCREMENT,
  festival_name VARCHAR(20) NOT NULL,
  festival_fest_year YEAR NOT NULL UNIQUE,
  location_id BIGINT NOT NULL UNIQUE,
  festival_start_date DATE NOT NUlL UNIQUE,
  festival_end_date DATE NOT NULL UNIQUE,
  festival_image_url VARCHAR(255) DEFAULT 'https://images.unsplash.com/photo-1533174072545-7a4b6ad7a6c3?q=80&w=2070&auto=format&fit=crop&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D',
  festival_image_description VARCHAR(64) DEFAULT 'This is a festival!',
  PRIMARY KEY(festival_id),
  CONSTRAINT where_fest FOREIGN KEY (location_id) REFERENCES location(location_id),
  CONSTRAINT festival_date CHECK (festival_start_date < festival_end_date),
  CONSTRAINT festival_year CHECK (YEAR(festival_start_date) = festival_fest_year AND YEAR(festival_end_date) = festival_fest_year)
);

DROP TABLE IF EXISTS equipmentCategory;
CREATE TABLE equipmentCategory (
    equipmentCategory_category VARCHAR(20) NOT NULL UNIQUE,
    PRIMARY KEY(equipmentCategory_category)
);

DROP TABLE IF EXISTS equipment;
CREATE TABLE equipment (
  equipment_id BIGINT NOT NULL AUTO_INCREMENT,
  equipment_product VARCHAR(20) NOT NULL UNIQUE,
  equipmentCategory_category VARCHAR(20) NOT NULL,
  equipment_image VARCHAR(256) DEFAULT 'https://images.unsplash.com/photo-1520444451380-ebe0f7b9cfd5?q=80&w=2070&auto=format&fit=crop&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D',
  equipment_description VARCHAR(32) DEFAULT 'Equipment description',
  PRIMARY KEY(equipment_id),
  CONSTRAINT equipment_category FOREIGN KEY (equipmentCategory_category) REFERENCES equipmentCategory(equipmentCategory_category)
);

DROP TABLE IF EXISTS stage;
CREATE TABLE stage (
  stage_id BIGINT NOT NULL AUTO_INCREMENT,
  stage_name VARCHAR(40) NOT NULL,
  stage_description VARCHAR(30) NOT NULL,
  stage_capacity BIGINT NOT NULL,
  PRIMARY KEY(stage_id)
);

DROP TABLE IF EXISTS equipmentUsed;
CREATE TABLE equipmentUsed (
	equipmentUsed_id BIGINT NOT NULL AUTO_INCREMENT,
    equipment_id BIGINT NOT NULL,
    stage_id BIGINT NOT NULL,
    PRIMARY KEY(equipmentUsed_id),
    CONSTRAINT equipment_assigned FOREIGN KEY (equipment_id) REFERENCES equipment(equipment_id),
    CONSTRAINT stage_assigned FOREIGN KEY (stage_id) REFERENCES stage(stage_id)
);

DROP TABLE IF EXISTS music_event;
CREATE TABLE music_event (
  music_event_id BIGINT NOT NULL AUTO_INCREMENT,
  festival_id BIGINT NOT NULL,
  stage_id BIGINT NOT NULL,
  music_event_date DATE NOT NULL,
  music_event_time TIME NOT NULL,
  music_event_end_time TIME,
  PRIMARY KEY(music_event_id),
  CONSTRAINT part_of_fest FOREIGN KEY (festival_id) REFERENCES festival(festival_id),
  CONSTRAINT takes_place_in FOREIGN KEY (stage_id) REFERENCES stage(stage_id)
);

DROP TABLE IF EXISTS staff_levels;
CREATE TABLE staff_levels (
	staff_levels_id BIGINT NOT NULL,
	staff_levels_experience_desc VARCHAR(20) UNIQUE,
	PRIMARY KEY(staff_levels_id)
);

INSERT INTO staff_levels VALUES (1, "Trainee");
INSERT INTO staff_levels VALUES (2, "Beginner");
INSERT INTO staff_levels VALUES (3, "Intermediate");
INSERT INTO staff_levels VALUES (4, "Experienced");
INSERT INTO staff_levels VALUES (5, "Highly Experienced");

DROP TABLE IF EXISTS role_staff;
CREATE TABLE role_staff (
	role_staff_id BIGINT NOT NULL,
    role_staff_desc VARCHAR(20) UNIQUE,
    PRIMARY KEY(role_staff_id)
);

INSERT INTO role_staff VALUES (1,'Technical');
INSERT INTO role_staff VALUES (2, 'Security');
INSERT INTO role_staff VALUES (3, 'Support');

DROP TABLE IF EXISTS staff;
CREATE TABLE staff (
  staff_id BIGINT NOT NULL AUTO_INCREMENT,
  staff_name VARCHAR(50) NOT NULL,
  staff_age SMALLINT NOT NULL,
  role_staff_desc VARCHAR(20) NOT NULL,
  staff_levels_experience_desc VARCHAR(20) NOT NULL,
  PRIMARY KEY(staff_id),
  CONSTRAINT lvl FOREIGN KEY (staff_levels_experience_desc) REFERENCES staff_levels(staff_levels_experience_desc),
  CONSTRAINT staffrole FOREIGN KEY (role_staff_desc) REFERENCES role_staff(role_staff_desc),
  CONSTRAINT staff_age CHECK (staff_age > 17)
);

DROP TABLE IF EXISTS performer;
CREATE TABLE performer(
  performer_id BIGINT NOT NULL AUTO_INCREMENT,
  performer_name VARCHAR(50) NOT NULL UNIQUE,
  performer_type VARCHAR(1) NOT NULL,
  performer_image VARCHAR(256) DEFAULT 'https://media.istockphoto.com/id/666258850/photo/silhouette-of-guitar-player-on-stage.webp?a=1&b=1&s=612x612&w=0&k=20&c=agjKh4C61HNr6RhX9ttAulqGSkwDGWWk4WLXtpSuNwE=',
  performer_description VARCHAR(32) DEFAULT 'I am a performer',
  PRIMARY KEY (performer_id),
  CONSTRAINT performer_type CHECK (performer_type IN ('A', 'B')) #A for artist, B for band
);

DROP TABLE IF EXISTS genre;
CREATE TABLE genre (
	genre_desc VARCHAR(20) NOT NULL,
    PRIMARY KEY (genre_desc)
);

DROP TABLE IF EXISTS subgenre;
CREATE TABLE subgenre (
	subgenre_desc VARCHAR(30) NOT NULL,
    PRIMARY KEY(subgenre_desc)
);

DROP TABLE IF EXISTS artist;
CREATE TABLE artist(
  artist_id BIGINT NOT NULL AUTO_INCREMENT,
  artist_name VARCHAR(50) NOT NULL UNIQUE,
  artist_nickname VARCHAR(20),
  artist_birthdate DATE NOT NULL,
  artist_website VARCHAR(50) ,
  artist_instagram VARCHAR(50) ,
  artist_performer_id BIGINT,
  PRIMARY KEY (artist_id),
  CONSTRAINT perfartist FOREIGN KEY (artist_performer_id) REFERENCES performer(performer_id)
);

DROP TABLE IF EXISTS art2genre;
CREATE TABLE art2genre(
	artist_id BIGINT NOT NULL AUTO_INCREMENT,
 	genre_desc VARCHAR(20) NOT NULL,
  	PRIMARY KEY (artist_id, genre_desc),
	CONSTRAINT genre_exists FOREIGN KEY (genre_desc) REFERENCES genre(genre_desc),
	CONSTRAINT art_exists FOREIGN KEY (artist_id) REFERENCES artist(artist_id)
 );	
 
DROP TABLE IF EXISTS art2subgenre;
CREATE TABLE art2subgenre(
	artist_id BIGINT NOT NULL AUTO_INCREMENT,
 	subgenre_desc VARCHAR(30) NOT NULL,
  	PRIMARY KEY (artist_id, subgenre_desc),
	CONSTRAINT subgenre_exists FOREIGN KEY (subgenre_desc) REFERENCES subgenre(subgenre_desc),
	CONSTRAINT art_sub_exists FOREIGN KEY (artist_id) REFERENCES artist(artist_id)
 );	

DROP TABLE IF EXISTS band;
CREATE TABLE band(
  band_id  BIGINT NOT NULL AUTO_INCREMENT,
  band_name VARCHAR(50) NOT NULL UNIQUE,
  band_formation_date DATE NOT NULL,
  band_website VARCHAR(50) NOT NULL UNIQUE,
  band_instagram VARCHAR(50) NOT NULL UNIQUE,
  band_performer_id BIGINT,
  PRIMARY KEY (band_id),
  CONSTRAINT perfband FOREIGN KEY (band_performer_id) REFERENCES performer(performer_id)
);

DROP TABLE IF EXISTS band2genre;
CREATE TABLE band2genre(
	band_id BIGINT NOT NULL AUTO_INCREMENT,
 	genre_desc VARCHAR(20) NOT NULL,
  	PRIMARY KEY (band_id, genre_desc),
	CONSTRAINT bgenre_exists FOREIGN KEY (genre_desc) REFERENCES genre(genre_desc),
	CONSTRAINT band_exists2 FOREIGN KEY (band_id) REFERENCES band(band_id)
 );	

DROP TABLE IF EXISTS band2subgenre;
CREATE TABLE band2subgenre(
	band_id BIGINT NOT NULL AUTO_INCREMENT,
 	subgenre_desc VARCHAR(30) NOT NULL,
  	PRIMARY KEY (band_id, subgenre_desc),
	CONSTRAINT bsubgenre_exists FOREIGN KEY (subgenre_desc) REFERENCES subgenre(subgenre_desc),
	CONSTRAINT band_sub_exists FOREIGN KEY (band_id) REFERENCES band(band_id)
 );	

DROP TABLE IF EXISTS members;
CREATE TABLE members(
  artist_id BIGINT NOT NULL,
  band_id BIGINT NOT NULL,
  position VARCHAR(20) NOT NULL,
  PRIMARY KEY (artist_id, band_id),
  CONSTRAINT band_exists FOREIGN KEY (band_id) REFERENCES band(band_id),
  CONSTRAINT dude_exists FOREIGN KEY (artist_id) REFERENCES artist(artist_id)
);

DROP TABLE IF EXISTS type_performance;
CREATE TABLE type_performance (
	type_performance_id BIGINT NOT NULL,
    type_performance_desc VARCHAR(20) NOT NULL UNIQUE,
    PRIMARY KEY (type_performance_id)
);
 
 INSERT INTO type_performance VALUE (1, 'Warm-up');
 INSERT INTO type_performance VALUE (2,'Headline');
 INSERT INTO type_performance VALUE (3,'Special Guest');
    
DROP TABLE IF EXISTS performance;
CREATE TABLE performance (
  performance_id BIGINT NOT NULL AUTO_INCREMENT,
  music_event_id BIGINT NOT NULL,
  performer_id BIGINT NOT NULL,
  type_performance_desc VARCHAR(20) NOT NULL,
  performance_start_time TIME NOT NULL,
  performance_duration SMALLINT NOT NULL CHECK (performance_duration <= 180),
  performance_end_time TIME,
  PRIMARY KEY(performance_id),
  CONSTRAINT event_performed FOREIGN KEY (music_event_id) REFERENCES music_event(music_event_id),
  CONSTRAINT artist_performed FOREIGN KEY (performer_id) REFERENCES performer(performer_id),
  CONSTRAINT perf_type FOREIGN KEY (type_performance_desc) REFERENCES type_performance(type_performance_desc)
);

DROP TABLE IF EXISTS worksIn;
CREATE TABLE worksIn (
	staff_id BIGINT NOT NULL,
    music_event_id BIGINT NOT NULL,
    PRIMARY KEY(staff_id, music_event_id),
    CONSTRAINT staff_assigned FOREIGN KEY (staff_id) REFERENCES staff(staff_id),
    CONSTRAINT event_assigned FOREIGN KEY (music_event_id) REFERENCES music_event(music_event_id)
);

DROP TABLE IF EXISTS visitor;
CREATE TABLE visitor (
  visitor_id BIGINT NOT NULL AUTO_INCREMENT,
  visitor_name VARCHAR(50) NOT NULL,
  visitor_surname VARCHAR(50) NOT NULL,
  visitor_contact_info VARCHAR(100) NOT NULL,
  visitor_age SMALLINT NOT NULL CHECK (visitor_age >= 0),
  PRIMARY KEY(visitor_id)
);

DROP TABLE IF EXISTS ticketType;
CREATE TABLE ticketType (
	ticketType_type VARCHAR(20) NOT NULL,
    PRIMARY KEY(ticketType_type)
);

INSERT INTO ticketType VALUES
('VIP'),
('BACKSTAGE'),
('REGULAR'),
('STUDENT');

DROP TABLE IF EXISTS ticket;
CREATE TABLE ticket (
  ticket_id BIGINT NOT NULL AUTO_INCREMENT,
  music_event_id BIGINT NOT NULL,
  visitor_id BIGINT NOT NULL,
  ticketType_type VARCHAR(20) NOT NULL,
  ticket_purchase_date DATE NOT NULL,
  ticket_price FLOAT NOT NULL,
  ticket_payment_method VARCHAR(20) NOT NULL CHECK (ticket_payment_method IN ('DEBIT','CREDIT','BANK_DEPOSIT')),
  ticket_EAN_13_code BIGINT NOT NULL, #AUTO_INCREMENT,
  ticket_status VARCHAR(20) NOT NULL CHECK (ticket_status IN ('USED','NOT USED', 'FOR SALE')),
  PRIMARY KEY (ticket_id),
  CONSTRAINT ticket_for_which_event FOREIGN KEY (music_event_id) REFERENCES music_event(music_event_id),
  CONSTRAINT visitors_ticket FOREIGN KEY (visitor_id) REFERENCES visitor(visitor_id),
  CONSTRAINT ticket_type FOREIGN KEY (ticketType_type) REFERENCES ticketType(ticketType_type)
);

  
DROP TABLE IF EXISTS review;
CREATE TABLE review (
  review_id BIGINT NOT NULL AUTO_INCREMENT,
  visitor_id BIGINT NOT NULL,
  performance_id BIGINT NOT NULL,
  review_interpretation SMALLINT NOT NULL,
  review_sound_and_lighting SMALLINT NOT NULL,
  review_stage_presence SMALLINT NOT NULL,
  review_organization SMALLINT NOT NULL,
  review_overall_impression SMALLINT NOT NULL,
  PRIMARY KEY (review_id),
  CONSTRAINT visitor_rating FOREIGN KEY (visitor_id) REFERENCES visitor(visitor_id),
  CONSTRAINT performance_rated FOREIGN KEY (performance_id) REFERENCES performance(performance_id),
  CONSTRAINT interpretation_score CHECK (review_interpretation BETWEEN 1 AND 5),
  CONSTRAINT sound_and_lighting_score CHECK (review_sound_and_lighting BETWEEN 1 AND 5),
  CONSTRAINT stage_presence_score CHECK (review_stage_presence BETWEEN 1 AND 5),
  CONSTRAINT organization_score CHECK (review_organization BETWEEN 1 AND 5),
  CONSTRAINT overall_impression_score CHECK (review_overall_impression BETWEEN 1 AND 5)
);
  

DROP TABLE IF EXISTS seller;
CREATE TABLE seller (
	visitor_id BIGINT NOT NULL,
    ticket_id BIGINT NOT NULL,
    seller_sold CHAR DEFAULT 'N' CHECK (seller_sold IN ('Y', 'N')),
    PRIMARY KEY(visitor_id, ticket_id),
    CONSTRAINT valid_seller FOREIGN KEY (visitor_id) REFERENCES visitor(visitor_id),
    CONSTRAINT valid_ticket FOREIGN KEY (ticket_id) REFERENCES ticket(ticket_id)
);

DROP TABLE IF EXISTS buyer;
CREATE TABLE buyer (
	visitor_id BIGINT NOT NULL,
    music_event_id BIGINT NOT NULL,
    ticketType_type VARCHAR(20) NOT NULL,
    ticket_id BIGINT,
    buyer_timeInserted TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    buyer_sold CHAR DEFAULT 'N' CHECK (buyer_sold IN ('Y', 'N')),
    PRIMARY KEY (visitor_id, music_event_id),
    CONSTRAINT buyer FOREIGN KEY (visitor_id) REFERENCES visitor(visitor_id),
    CONSTRAINT valid_event FOREIGN KEY (music_event_id) REFERENCES music_event(music_event_id),
    CONSTRAINT tckt_type FOREIGN KEY (ticketType_type) REFERENCES ticketType(ticketType_type)
);

DROP TABLE IF EXISTS resaleQueue;
CREATE TABLE resaleQueue (
	resaleQueue_id BIGINT NOT NULL AUTO_INCREMENT,
    ticket_id BIGINT NOT NULL,
    resaleQueue_timeInserted TIMESTAMP NOT NULL,
    PRIMARY KEY(resaleQueue_id)
);

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
    DECLARE capacity BIGINT;
    SELECT stage_capacity INTO capacity FROM music_event NATURAL JOIN stage WHERE NEW.music_event_id = music_event_id LIMIT 1;

    CALL checkEAN(NEW.ticket_EAN_13_code);

    IF NEW.ticket_status = 'FOR SALE' THEN
		SET NEW.ticket_status = 'NOT USED';
	END IF;
    
    IF EXISTS (SELECT * FROM ticket WHERE visitor_id = NEW.visitor_id AND music_event_id = NEW.music_event_id) THEN
		SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Visitor Already Owns Ticket';
    END IF;
    
	IF (SELECT COUNT(*) + 1 FROM
		ticket NATURAL JOIN music_event WHERE music_event_id = NEW.music_event_id) > capacity THEN
			SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Too Many Tickets';
	END IF;
    
    SET capacity = CEILING(capacity * 0.1);
	IF (SELECT COUNT(*) + 1 FROM
		ticket NATURAL JOIN music_event WHERE music_event_id = NEW.music_event_id AND ticketType_type = 'VIP') > capacity THEN
			SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Too Many VIP';
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
    
    CALL findTicket(NEW.visitor_id, NEW.music_event_id, NEW.ticketType_type, @result);
    
    IF @result = 1 THEN
		IF (SELECT COUNT(*) FROM ticket WHERE visitor_id = NEW.visitor_id AND music_event_id = NEW.music_event_id) > 1 THEN
			SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Already Owns Ticket';
        END IF;
    
		SET NEW.buyer_sold = 'Y';
    END IF;
END;
//
DELIMITER ;

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
