import random

norwegian_first_names = [
    'Lars', 'Ola', 'Knut', 'Per', 'Jan', 'Anders', 'Nils', 'Svein', 'Bjørn', 'Erik',
    'Morten', 'Trond', 'Steinar', 'Rune', 'Geir', 'Harald', 'Einar', 'Leif', 'Tore', 'Vidar'
]
norwegian_surnames = [
    'Hansen', 'Johansen', 'Olsen', 'Larsen', 'Andersen', 'Pedersen', 'Nilsen', 'Kristiansen',
    'Jensen', 'Karlsen', 'Johnsen', 'Pettersen', 'Eriksen', 'Berg', 'Haugen', 'Dahl', 'Moen',
    'Solberg', 'Halvorsen', 'Lie'
]

norwegian_values = []
for i in range(200):
    first = random.choice(norwegian_first_names)
    last = random.choice(norwegian_surnames)
    email = f"{first.lower()}.{last.lower()}{i}@example.com"
    age = random.randint(18, 65)
    norwegian_values.append(f"('{first}', '{last}', '{email}', {age})")

norwegian_sql_insert = "INSERT INTO visitor (visitor_name, visitor_surname, visitor_contact_info, visitor_age) VALUES\n"
norwegian_sql_insert += ",\n".join(norwegian_values) + ";"

norwegian_file_path = "insert_norwegian_visitors.sql"
with open(norwegian_file_path, "w", encoding="utf-8") as f:
    f.write(norwegian_sql_insert)
