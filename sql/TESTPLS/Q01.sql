WITH fest_ticket (fest_year, fest_name, price, ticket_type, method) AS (SELECT festival_fest_year, festival_name, ticket_price, ticketType_type, ticket_payment_method FROM festival NATURAL JOIN music_event LEFT JOIN ticket ON music_event.music_event_id = ticket.music_event_id),
VIP_price AS (SELECT fest_year, fest_name, CASE WHEN ticket_type = 'VIP' THEN price ELSE 0 END AS vip_price FROM fest_ticket),
VIP_total (fest_year, fest_name, vip_total) AS (SELECT fest_year, fest_name, SUM(vip_price) FROM VIP_price GROUP BY fest_year, fest_name),
BACK_price AS (SELECT fest_year, fest_name, CASE WHEN ticket_type = 'BACKSTAGE' THEN price ELSE 0 END AS back_price FROM fest_ticket),
BACK_total (fest_year, fest_name, back_total) AS (SELECT fest_year, fest_name, SUM(back_price) FROM BACK_price GROUP BY fest_year, fest_name),
STD_price AS (SELECT fest_year, fest_name, CASE WHEN ticket_type = 'STANDARD' THEN price ELSE 0 END AS std_price FROM fest_ticket),
STD_total (fest_year, fest_name, std_total) AS (SELECT fest_year, fest_name, SUM(std_price) FROM STD_price GROUP BY fest_year, fest_name),
STUDENT_price AS (SELECT fest_year, fest_name, CASE WHEN ticket_type = 'STUDENT' THEN price ELSE 0 END AS student_price FROM fest_ticket),
STUDENT_total (fest_year, fest_name, student_total) AS (SELECT fest_year, fest_name, SUM(student_price) FROM STUDENT_price GROUP BY fest_year, fest_name),
type_analysis (fest_year, fest_name, Total, VIP, Backstage, Standard, Student) AS (SELECT fest_year, fest_name, vip_total+back_total+std_total+student_total, vip_total, back_total, std_total, student_total FROM  VIP_total NATURAL JOIN back_total NATURAL JOIN std_total NATURAL JOIN student_total),
DEBIT_price  AS (SELECT fest_year, fest_name, CASE WHEN method = 'DEBIT' THEN price ELSE 0 END AS debit_price FROM fest_ticket),
DEBIT_total AS (SELECT fest_year, fest_name, SUM(debit_price) AS debit_total FROM DEBIT_price GROUP BY fest_year, fest_name),
CREDIT_price  AS (SELECT fest_year, fest_name, CASE WHEN method = 'CREDIT' THEN price ELSE 0 END AS credit_price FROM fest_ticket),
CREDIT_total AS (SELECT fest_year, fest_name, SUM(credit_price) AS credit_total FROM CREDIT_price GROUP BY fest_year, fest_name),
BANK_price AS (SELECT fest_year, fest_name, CASE WHEN method = 'BANK_DEPOSIT' THEN price ELSE 0 END AS bank_price FROM fest_ticket),
BANK_total AS (SELECT fest_year, fest_name, SUM(bank_price) AS bank_total FROM BANK_price GROUP BY fest_year, fest_name),
method_analysis AS (SELECT * FROM DEBIT_total NATURAL JOIN CREDIT_total NATURAL JOIN BANK_total)

SELECT * FROM type_analysis NATURAL JOIN method_analysis;
