import random


first_names = [
    'Jean', 'Luc', 'Pierre', 'Antoine', 'Michel', 'Henri', 'Jacques', 'François', 'Louis', 'Paul',
    'André', 'Marc', 'Claude', 'Alain', 'Émile', 'Gérard', 'Bernard', 'René', 'Raymond', 'Daniel',
    'Thierry', 'Gilbert', 'Christian', 'Georges', 'Laurent', 'Philippe', 'Olivier', 'Pascal', 'Roger', 'Guy'
]

surnames = [
    'Dupont', 'Moreau', 'Lefebvre', 'Girard', 'Lambert', 'Rousseau', 'Fournier', 'Faure', 'Andrieux', 'Garnier',
    'Perrin', 'Marchand', 'Noël', 'Granger', 'Chevalier', 'Lemoine', 'Barbier', 'Pires', 'Rolland', 'Benoit',
    'Da Silva', 'Lemoine', 'Besson', 'Langlois', 'Perrot', 'Texier', 'Schmitt', 'Jacquet', 'Colin', 'Leroux'
]

values = []
for i in range(200):
    first = random.choice(first_names)
    last = random.choice(surnames)
    email = f"{first.lower()}.{last.lower()}{i}@example.com"
    age = random.randint(18, 65)
    values.append(f"('{first}', '{last}', '{email}', {age})")

#SQL INSERT statement
sql_insert = "INSERT INTO visitor (visitor_name, visitor_surname, visitor_contact_info, visitor_age) VALUES\n"
sql_insert += ",\n".join(values) + ";"


