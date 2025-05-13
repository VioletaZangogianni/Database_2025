import random

def generate_ean13():
    digits = [random.randint(0, 9) for _ in range(12)]
    sum_odd = sum(digits[i] for i in range(0, 12, 2))
    sum_even = sum(digits[i] for i in range(1, 12, 2))
    check_digit = (10 - ((sum_odd + 3 * sum_even) % 10)) % 10
    digits.append(check_digit)
    return ''.join(map(str, digits))

ticket_types = ['REGULAR', 'STUDENT', 'BACKSTAGE']
payment_methods = ['DEBIT', 'CREDIT', 'BANK_DEPOSIT']
purchase_date = '2004-01-01'
#status = 'USED'
#status=['NOT USED','FOR SALE']
vip_count = 0
vip_limit = 5

with open("insert_tickets1.sql", "w") as file:
    file.write("INSERT INTO ticket (music_event_id, visitor_id, ticketType_type, ticket_purchase_date, ticket_price, ticket_payment_method, ticket_EAN_13_code, ticket_status) VALUES\n")

    values = []
    for event_id in range(35, 130):  # 1 to 33 inclusive
        for visitor_id in range(1, 21):  # 1 to 200 inclusive
            if vip_count < vip_limit and random.random() < 0.0008: 
                ticket_type = 'VIP'
                vip_count += 1
            else:
                ticket_type = random.choice(ticket_types)

            ticket_price = round(random.uniform(20, 200), 2)  
            payment_method = random.choice(payment_methods)
            ean13 = generate_ean13()
            if visitor_id < 11:
                status = 'NOT USED'
            else:
                status = 'FOR SALE'

            values.append(f"({event_id}, {visitor_id}, '{ticket_type}', '{purchase_date}', {ticket_price:.2f}, '{payment_method}', '{ean13}', '{status}')")

    file.write(",\n".join(values) + ";\n")
