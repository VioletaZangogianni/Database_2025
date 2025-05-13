import random

def generate_ean13():
    digits = [random.randint(0, 9) for _ in range(12)]

    sum_odd = sum(digits[i] for i in range(0, 12, 2))     # positions 1,3,5,... (index 0,2,4,...)
    sum_even = sum(digits[i] for i in range(1, 12, 2))    # positions 2,4,6,... (index 1,3,5,...)
    check_digit = (10 - ((sum_odd + 3 * sum_even) % 10)) % 10

    digits.append(check_digit)

    return ''.join(map(str, digits))

print("Generated EAN-13:", generate_ean13())

