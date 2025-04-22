WITH fest_ticket (fest_year, fest_name, ticket_type, ticket_price, ticket_payment_method) AS (SELECT festival_fest_year, festival_name, ticketType_type, ticket_price, ticket_payment_method FROM festival NATURAL JOIN music_event NATURAL JOIN ticket),
VIP_income (fest_year, fest_name, VIP_ticket_total) AS (SELECT fest_year, fest_name, SUM(ticket_price) FROM fest_ticket WHERE ticket_type='VIP' GROUP BY fest_year, fest_name),
back_income (fest_year, fest_name, back_ticket_total) AS (SELECT fest_year, fest_name, SUM(ticket_price) FROM fest_ticket WHERE ticket_type='VIP' GROUP BY fest_year, fest_name),
std_income (fest_year, fest_name, std_ticket_total) AS (SELECT fest_year, fest_name, SUM(ticket_price) FROM fest_ticket WHERE ticket_type='VIP' GROUP BY fest_year, fest_name),
type_analysis (fest_year, fest_name, total, VIP, bacckstage, standard) AS (SELECT fest_year, fest_name, VIP_ticket_total+back_ticket_total+std_ticket_total, VIP_ticket_total, back_ticket_total, std_ticket_total FROM  VIP_income NATURAL JOIN back_income NATURAL JOIN std_income),
debit_income (fest_year, fest_name, debit_ticket_total) AS (SELECT fest_year, fest_name, SUM(ticket_price) FROM fest_ticket WHERE ticket_type='VIP' GROUP BY fest_year, fest_name),
credit_income (fest_year, fest_name, credit_ticket_total) AS (SELECT fest_year, fest_name, SUM(ticket_price) FROM fest_ticket WHERE ticket_type='VIP' GROUP BY fest_year, fest_name),
bank_income (fest_year, fest_name, bank_ticket_total) AS (SELECT fest_year, fest_name, SUM(ticket_price) FROM fest_ticket WHERE ticket_type='VIP' GROUP BY fest_year, fest_name),
method_analysis (fest_year, fest_name, debit, credt, bank_deposit) AS (SELECT * FROM debit_income NATURAL JOIN credit_income NATURAL JOIN bank_income)

SELECT * FROM type_analysis NATURAL JOIN method_analysis;
