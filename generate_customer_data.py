import csv
from faker import Faker
import random

fake = Faker()

# Create a sequence generator for unique customer IDs
def id_generator():
    current_id = 1
    while True:
        yield current_id
        current_id += 1

id_gen = id_generator()

# Function to generate a single customer record
def generate_customer():
    gender = random.choice(['M', 'F'])
    first_name = fake.first_name_male() if gender == 'M' else fake.first_name_female()
    return [
        next(id_gen),  # customerid (unique)
        first_name,
        fake.last_name(),
        fake.street_address(),
        fake.secondary_address() if random.random() < 0.3 else '',  # 30% chance of having address2
        fake.city(),
        fake.state() if random.random() < 0.8 else '',  # 80% chance of having a state
        fake.zipcode() if random.random() < 0.9 else '',  # 90% chance of having a zip code
        fake.country(),
        random.randint(1, 5),  # region
        fake.email() if random.random() < 0.8 else '',  # 80% chance of having an email
        fake.phone_number() if random.random() < 0.7 else '',  # 70% chance of having a phone
        random.randint(1, 4),  # creditcardtype
        fake.credit_card_number(),
        fake.credit_card_expire(),
        fake.user_name(),
        fake.password(),
        random.randint(18, 90) if random.random() < 0.95 else '',  # age (95% chance of being provided)
        random.randint(20000, 200000) if random.random() < 0.7 else '',  # income (70% chance of being provided)
        gender
    ]

# Generate CSV file
filename = 'customer_data.csv'
header = ['customerid', 'firstname', 'lastname', 'address1', 'address2', 'city', 'state', 'zip', 'country', 'region', 'email', 'phone', 'creditcardtype', 'creditcard', 'creditcardexpiration', 'username', 'password', 'age', 'income', 'gender']

with open(filename, 'w', newline='') as csvfile:
    csvwriter = csv.writer(csvfile)
    csvwriter.writerow(header)
    for _ in range(20000):
        csvwriter.writerow(generate_customer())

print(f"Generated {filename} with 20,000 records.")