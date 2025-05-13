import random

genres = [
    'Classical',
    'Blues',
    'Country',
    'Electronic',
    'Folk',
    'Hip-Hop',
    'Jazz',
    'Pop',
    'Rock',
    'R&B',
    'EDM'
]

pairs = []

for number in range(1, 138):  
    word = random.choice(genres)
    pairs.append((number, word))

with open("number_genre_pairs2.txt", "w") as f:
    for number, word in pairs:
        f.write(f"({number}, '{word}'),\n")
