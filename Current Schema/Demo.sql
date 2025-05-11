INSERT INTO location VALUES (999999, 'Demo Location', "a", "a", "a", "Europe");
INSERT INTO stage VALUES (999998, "Demo1", "Demo Stage", 10);
INSERT INTO stage VALUES (999999, "Demo2", "Demo Stage", 100);

# Wrong Dates
INSERT INTO festival VALUES (999999, 'Demo', '2050', 999999, '2050-5-14', '2051-5-17', NULL, NULL);

INSERT INTO festival VALUES (999999, 'Demo', '2050', 999999, '2050-5-14', '2050-5-17', NULL, NULL);
# Date not incluede in festival
INSERT INTO music_event VALUES (999999, 999999, 999999, '2050-5-13', '10:00:00', NULL);


INSERT INTO music_event VALUES (999998, 999999, 999998, '2050-5-14', '10:00:00', NULL);
INSERT INTO music_event VALUES (999999, 999999, 999999, '2050-5-14', '10:30:00', NULL);

# Wrong Starting Time
INSERT INTO performance VALUES (999997, 999998, 1, 'Warm-Up', '10:10:00', 100, NULL);
# Too Long Performance
INSERT INTO performance VALUES (999997, 999998, 1, 'Warm-Up', '10:00:00', 181, NULL);

INSERT INTO performance VALUES (999997, 999998, 1, 'Warm-Up', '10:00:00', 60, NULL);
# Short Break
INSERT INTO performance VALUES (999998, 999998, 10, 'Warm-Up', '11:01:00', 60, NULL);

INSERT INTO performance VALUES (999998, 999998, 10, 'Warm-Up', '11:15:00', 60, NULL);
# Artist Already Performing 
INSERT INTO performance VALUES (999999, 999999, 10, 'Headline', '10:30:00', 120, NULL);

CALL checkEnoughStaff(80);
# Not Enough Staff
CALL checkEnoughStaff(999999);

# Invalid EAN-13 Code
INSERT INTO ticket VALUES (999990, 999998, 1, 'VIP', '2020-10-10', '10.00', 'DEBIT', '6969696969693', 'USED');

INSERT INTO ticket VALUES (999990, 999998, 1, 'VIP', '2020-10-10', '10.00', 'DEBIT', '6969696969692', 'USED');
# Too Many VIP
INSERT INTO ticket VALUES (999991, 999998, 2, 'VIP', '2020-10-10', '10.00', 'DEBIT', '1234567891019', 'NOT USED');
# Duplicate EAN Code
INSERT INTO ticket VALUES (999992, 999998, 3, 'REGULAR', '2020-10-10', '10.00', 'DEBIT', '6969696969692', 'NOT USED');
# Visitor Multiple Tickets
INSERT INTO ticket VALUES (999993, 999998, 1, 'REGULAR', '2020-10-10', '10.00', 'DEBIT', '1109876543211', 'NOT USED');

# Visitor Not Attended Reviewed Event
INSERT INTO review VALUES (999999, 2, 999997, 5, 5, 5, 5, 5);

INSERT INTO review VALUES (999999, 1, 999997, 5, 5, 5, 5, 5);


INSERT INTO seller(visitor_id,ticket_id) VALUES
(1,2282),
(2,2283),
(3,2284),
(4,2285);


SELECT * FROM resalequeue;

INSERT INTO buyer(visitor_id, music_event_id, ticketType_type) VALUES
(21, 43, 'REGULAR'),
(22, 43, 'BACKSTAGE');
