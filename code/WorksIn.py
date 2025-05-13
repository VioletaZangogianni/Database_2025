# Generate all (number1, number2) pairs
pairs = []

# Generate and write (number1, number2) pairs grouped by number2 per line
with open("number_pairs_grouped_by_number.txt", "w") as f:
    for number2 in range(3, 129,3): 
        line = ", ".join(f"({number1}, {number2})" for number1 in range(213, 312))
        f.write(line + ",\n")
