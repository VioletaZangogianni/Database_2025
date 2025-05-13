import random

genres = [
    'Andalusian classical music',
    'Indian classical music',
    'African blues',
    'British blues',
    'Gothic country',
    'Cowpunk',
    'Ambient',
    'Bass music',
    'Disco',
    'Electronic rock',
    'Anti-folk',
    'Bounce',
    'Latin hip-hop',
    'Cool jazz',
    'Vocal jazz',
    'J-pop',
    'K-pop',
    'Progressive Rock',
    'Progressive House',
    'Electropop',
    'Hard Rock',
    'Post-grunge',
    'Psychedelic rock',
    'Indie Rock',
    'Post-punk',
    'Synthpop',
    'Pop Rock',
    'Alternative Rock',
    'Emo',
    'R&B',
    'Folk Pop',
    'Soul',
    'Rap',
    'Country Pop',
    'Alternative Pop',
    'Soft Rock',
    'Dancehall',
    'Reggaeton',
    'Pop Rap',
    'Alternative R&B',
    'Indie Pop',
    'Neo Soul',
    'Pop Soul',
    'Laika',
    'Funk Pop',
    'Garage Rock',
    'Blues Rock',
    'Rap Rock',
    'Pop Punk',
    'New Wave',
    'Southern Rock',
    'Classic Rock'
]

pairs = []

for number in range(1, 25,2):  
    word = random.choice(genres)
    pairs.append((number, word))

with open("number_subgenre_pairs_band.txt", "w") as f:
    for number, word in pairs:
        f.write(f"({number}, '{word}'),\n")
