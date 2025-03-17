DROP SCHEMA IF EXISTS 'music_festival_ntua' --νομίζω είναι καλύτερο να τα διαγράφουμε πριν το CREATE σε περίπτωση που αλλάξουμε τίποτα σε κάποιο TABLE
CREATE SCHEMA IF 'music_festival_ntua';
USE music_festival_ntua;

DROP TABLE IF EXISTS festival
CREATE TABLE festival (
  id BIGINT NOT NULL AUTO INCREMENT,
  name VARCHAR(20) NOT NULL,
  fest_year YEAR NOT NULL,
  location_id BIGINT NOT NULL
  start_date DATE NOT NUlL,
  end_date DATE NOT NULL,
  PRIMARY KEY(id),
  CONSTRAINT where_fest FOREIGN KEY (location_id) REFERENCES location(location_id),
  PRIMARY KEY(year) --???? να διαλέξουμε, δεν ξέρω αν μας αφήνει να έχουμε πολλά primary keys
);

DROP TABLE IF EXISTS location
CREATE TABLE location (
  id BIGINT NOT NULL,
  address VARCHAR(20) NOT NULL,
  coordinates VARCHAR(20) NOT NULL, --πλιζ πείτε μου ότι αυτό το βάλαμε για αστείο
  city VARCHAR(20) NOT NULL,
  country VARCHAR(20) NOT NULL,
  continent VARCHAR(20) CHECK (continent IN ('Europe', 'America', 'Asia', 'Africa', 'Oceania', 'Arctica', 'Antarctica')), --δεν υπάρχει περίπτωση να μην είναι περιττό αυτό
  PRIMARY KEY(id)
);

DROP TABLE IF EXISTS event
CREATE TABLE event (
  id BIGINT NOT NULL,
  festival_id BIGINT NOT NULL,
  stage_id BIGINT NOT NULL,
  event_date DATE NOT NULL,
  event_time TIME NOT NULL,
  PRIMARY KEY(id),
  CONSTRAINT part_of_fest FOREIGN KEY (festival_id) REFERENCES festival(id),
  CONSTRAINT takes_place_in FOREIGN KEY (stage_id) REFERENCES stage(id)
);

DROP TABLE IF EXISTS stage
CREATE TABLE stage (
  id BIGINT NOT NULL,
  name VARCHAR(20) NOT NULL,
  description VARCHAR(20) NOT NULL,
  capacity SMALLINT NOT NULL,
  equipment_id BIGINT NOT NULL,
  PRIMARY KEY(id),
  CONSTRAINT equipment_used FOREIGN KEY (equipment_id) REFERENCES equipment(id)
);

DROP TABLE IF EXISTS equipment
CREATE TABLE equipment (
  id BIGINT NOT NULL,
  product VARCHAR(20) NOT NULL,
  category VARCHAR(20) CHECK (category in ('Microphone')) --είπα να το κάνω με τέτοιο πάλι, αλλά δεν έβαλα κάτι άλλο
);

DROP TABLE IF EXISTS staff;
CREATE TABLE staff (
  id BIGINT NOT NULL AUTO_INCREMENT,
  name VARCHAR(50) NOT NULL,
  age SMALLINT NOT NULL,
  role VARCHAR(20) CHECK (role IN ('Technical', 'Security', 'Support')),
  experience_level VARCHAR(20) CHECK (experience_level IN ('Trainee', 'Beginner', 'Intermediate', 'Experienced', 'Highly Experienced')),
  PRIMARY KEY(id)
);

CREATE TABLE performance (
  id BIGINT NOT NULL AUTO_INCREMENT,
  event_id BIGINT NOT NULL,
  artist_id BIGINT NOT NULL,
  type VARCHAR(20) CHECK (type IN ('Warm-up', 'Headline', 'Special Guest')),
  start_time TIME NOT NULL,
  duration SMALLINT NOT NULL,
  break SMALLINT CHECK (break BETWEEN 5 AND 30),
  staff_id BIGINT,
  PRIMARY KEY(id),
  CONSTRAINT event_performed FOREIGN KEY (event_id) REFERENCES event(id),
  CONSTRAINT artist_performed FOREIGN KEY (artist_id) REFERENCES artist(id),
  CONSTRAINT staff_assigned FOREIGN KEY (staff_id) REFERENCES staff(id)
);

DROP TABLE IF EXISTS visitor;
CREATE TABLE visitor (
  id BIGINT NOT NULL AUTO_INCREMENT,
  name VARCHAR(50) NOT NULL,
  surname VARCHAR(50) NOT NULL,
  contact_info VARCHAR(100) NOT NULL,
  age SMALLINT NOT NULL CHECK (age >= 0),
  PRIMARY KEY(id)
);
