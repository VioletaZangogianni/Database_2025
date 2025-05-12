WITH fest_ticket AS (SELECT festival_fest_year AS fest_year, festival_name AS fest_name,
			ticket_price AS price, ticketType_type AS ticket_Type, ticket_payment_method AS method
		FROM festival NATURAL JOIN music_event LEFT JOIN ticket
        ON music_event.music_event_id = ticket.music_event_id),
	fest_ticket_price AS (SELECT fest_year, fest_name,
			CASE WHEN ticket_type = 'VIP' THEN price ELSE 0 END AS vip_price,
            CASE WHEN ticket_type = 'BACKSTAGE' THEN price ELSE 0 END AS back_price,
            CASE WHEN ticket_type = 'REGULAR' THEN price ELSE 0 END AS std_price,
            CASE WHEN ticket_type = 'STUDENT' THEN price ELSE 0 END AS student_price,
            
			CASE WHEN method = 'DEBIT' THEN price ELSE 0 END AS debit_price,
            CASE WHEN method = 'CREDIT' THEN price ELSE 0 END AS credit_price,
            CASE WHEN method = 'BANK_DEPOSIT' THEN price ELSE 0 END AS bank_price
		FROM fest_ticket),
	fest_totals AS (SELECT fest_year, fest_name,
		ROUND(SUM(vip_price), 2) AS vip_total, ROUND(SUM(back_price), 2) AS back_total,
        ROUND(SUM(std_price), 2) AS std_total, ROUND(SUM(student_price), 2) AS student_total,
        
        ROUND(SUM(debit_price), 2) AS debit_total, ROUND(SUM(credit_price), 2) AS credit_total,
		ROUND(SUM(bank_price), 2) AS bank_total
    FROM fest_ticket_price
    GROUP BY fest_year, fest_name)
SELECT fest_year AS 'Year', fest_name AS 'Festival',
	CONCAT(ROUND(vip_total + back_total + std_total + student_total, 2), '€') AS 'Total Earnings',
    CONCAT(std_total, '€') AS 'Regular ticket Earnings', CONCAT(vip_total, '€') AS 'VIP Earnings',
    CONCAT(back_total, '€') AS 'Backstage Earnings', CONCAT(student_total, '€') AS 'Student ticket Earnings',
    
    CONCAT(debit_total, '€') AS 'Debit Earnings', CONCAT(credit_total, '€') AS 'Credit Earnings',
    CONCAT(bank_total, '€') AS 'Bank Deposit Earnings'
FROM fest_totals
ORDER BY fest_year ASC;