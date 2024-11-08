import csv
import random

import pandas as pd

# Define the number of rows and the range for id and timestamp
num_rows = 20_000_000
id_range = range(100)
timestamp_range = range(100000000, 100001000)

random.seed(42)

print("Generating data (1/1)")
# Open a CSV file to write the data
with open("data.csv", mode="w", newline="") as file:
    writer = csv.writer(file)
    writer.writerow(["id", "timestamp", "value", "valid"])  # Write the header

    for _ in range(num_rows):
        id = random.choice(id_range)
        timestamp = random.choice(timestamp_range)
        value = round(random.uniform(0, 10), 4)
        valid = random.choice([0, 1])
        writer.writerow([id, timestamp, value, valid])

print("Sorting data")
df = pd.read_csv("data.csv")
print("Sorting by id (1/4)")
df.sort_values(by="id", ascending=False).to_csv("sorted_id.csv", index=False)
print("Sorting by timestamp (2/4)")
df.sort_values(by="timestamp").to_csv("sorted_timestamp.csv", index=False)
print("Sorting by value (3/4)")
df.sort_values(by="value", ascending=False).to_csv("sorted_value.csv", index=False)
print("Sorting by valid (4/4)")
df.sort_values(by="valid", ascending=False).to_csv("sorted_valid.csv", index=False)
print("Done")
