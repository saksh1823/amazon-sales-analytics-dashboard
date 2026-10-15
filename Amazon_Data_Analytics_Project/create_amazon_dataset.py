import pandas as pd
import random
from datetime import datetime, timedelta

random.seed(42)

products = {
    "Laptop": ("Electronics", 55000),
    "Mobile": ("Electronics", 20000),
    "Headphones": ("Electronics", 3000),
    "Smartwatch": ("Electronics", 5000),
    "Tablet": ("Electronics", 25000),
    "T-Shirt": ("Fashion", 1200),
    "Jeans": ("Fashion", 1800),
    "Shoes": ("Fashion", 3000),
    "Backpack": ("Fashion", 1500),
    "Jacket": ("Fashion", 2500),
    "Mixer": ("Home & Kitchen", 4000),
    "Air Fryer": ("Home & Kitchen", 6000),
    "Coffee Maker": ("Home & Kitchen", 4500),
    "Bedsheet": ("Home & Kitchen", 1800),
    "Cookware Set": ("Home & Kitchen", 3500)
}

cities = [
    "Chandigarh", "Mohali", "Ludhiana", "Delhi", "Mumbai",
    "Bengaluru", "Hyderabad", "Chennai", "Pune", "Kolkata",
    "Amritsar", "Jaipur", "Ahmedabad", "Lucknow", "Gurugram"
]

payments = ["UPI", "Card", "Cash", "Net Banking", "Wallet"]
statuses = ["Delivered", "Delivered", "Delivered", "Delivered",
            "Cancelled", "Returned", "Shipped"]

start_date = datetime(2025, 1, 1)

data = []

for i in range(1, 5001):
    product = random.choice(list(products.keys()))
    category, price = products[product]

    quantity = random.randint(1, 4)
    unit_price = price + random.randint(-200, 500)

    order_date = start_date + timedelta(
        days=random.randint(0, 364)
    )

    sales = quantity * unit_price

    data.append([
        f"ORD{i:05d}",
        order_date.strftime("%Y-%m-%d"),
        f"C{random.randint(1001, 1500)}",
        product,
        category,
        quantity,
        unit_price,
        sales,
        random.choice(cities),
        random.choice(payments),
        random.choice(statuses)
    ])

df = pd.DataFrame(data, columns=[
    "OrderID",
    "OrderDate",
    "CustomerID",
    "Product",
    "Category",
    "Quantity",
    "UnitPrice",
    "Sales",
    "City",
    "PaymentMethod",
    "OrderStatus"
])

df.to_csv("amazon_sales_data.csv", index=False)

print("Dataset created successfully!")
print("Rows:", len(df))
print(df.head())