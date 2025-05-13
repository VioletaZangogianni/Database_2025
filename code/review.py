import random

def generate_tuples(count=75):
    result = []
    for _ in range(count):
        number1 = random.randint(401,600)#visitor
        number2 = random.choice([6,7,8])#performance
        number3_to_7 = [random.randint(1, 5) for _ in range(5)]
        result.append((number1, number2, *number3_to_7))
    return result

tuples = generate_tuples()


with open("review_test.txt", "w") as f:
    for t in tuples:
        f.write(f"{t},\n")

