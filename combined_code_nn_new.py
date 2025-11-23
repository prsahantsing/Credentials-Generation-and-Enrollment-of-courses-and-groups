import pyodbc
import pandas as pd
import gspread
from sqlalchemy import create_engine
from datetime import datetime
import os

# -------------------------------
# 0️⃣ Step 0: Truncate tables before processing
# -------------------------------

print("🔹 Step 0: Truncating existing tables before import...")

conn = pyodbc.connect(
    "DRIVER={SQL Server};SERVER=localhost\\MSSQLSERVER02;DATABASE=nn;Trusted_Connection=yes;"
)
cursor = conn.cursor()

truncate_commands = [
    "TRUNCATE TABLE master_credentials_file_l",
    "TRUNCATE TABLE master_credentials_file_l2",
    "TRUNCATE TABLE master_credentials_file_T",
    "TRUNCATE TABLE newenrolls",
    "TRUNCATE TABLE csv_handle",
    "TRUNCATE TABLE NOT_ENROLLED"     # Added
]

for cmd in truncate_commands:
    cursor.execute(cmd)
    print(f"✅ Executed: {cmd}")

conn.commit()
print("✅ Step 0 complete: All tables truncated successfully.\n")

# -----------------------------
# 1️⃣ Google Sheet → SQL Insert
# -----------------------------
print("🔹 Step 1: Fetching data from Google Sheet and inserting new records...")

gc = gspread.service_account(filename=r"C:\api key\google_cloud_key.json")

sheet_url = "https://docs.google.com/spreadsheets/d/10ig5F8JIegkwV-exx0-vncQQ_FnOGNXVQVwD5jSR0KA/edit?gid=0#gid=0"
worksheet = gc.open_by_url(sheet_url).sheet1

data = worksheet.get_all_records()
df = pd.DataFrame(data)
  
# SQL Server connection
conn = pyodbc.connect(
    "DRIVER={SQL Server};SERVER=localhost\\MSSQLSERVER02;DATABASE=nn;Trusted_Connection=yes;"
)
cursor = conn.cursor()

# Get existing data for comparison
cursor.execute("""
    SELECT [First Name], [Last Name], [Class/Grade], [Branch]
    FROM master_credentials_file_l
""")
existing_rows = cursor.fetchall()
existing_set = {(row[0], row[1], row[2], row[3]) for row in existing_rows}

# Filter out existing records
new_data = df[~df.apply(
    lambda x: (
        x['First Name'], x['Last Name'], x['Class/Grade'], x['Branch']
    ) in existing_set,
    axis=1
)]

# Insert new rows
for _, row in new_data.iterrows():
    cursor.execute("""
        INSERT INTO master_credentials_file_l
        ([First Name], [Last Name], [Username], [Password], [Class/Grade], [Section], [Branch], [Admission Number / Unique Identification Number], [Remarks])
        VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?)
    """, row['First Name'], row['Last Name'], row['Username'], row['Password'],
         row['Class/Grade'], row['Section'], row['Branch'],
         row['Admission Number / Unique Identification Number'], row['Remarks'])

conn.commit()
print(f"✅ Inserted {len(new_data)} new rows into master_credentials_file_l.")

# -----------------------------
# 2️⃣ Execute Stored Procedures
# -----------------------------
print("🔹 Step 2: Executing stored procedures...")

cursor.execute("EXEC Initialize_Setup")
conn.commit()

cursor.execute("EXEC CREDENTIALS_EXECUTION")
conn.commit()

print("✅ Stored procedures executed successfully.")

# -----------------------------
# 3️⃣ Export from CSV_HANDLE
# -----------------------------
print("🔹 Step 3: Exporting CSV_HANDLE data...")

server = 'localhost\\MSSQLSERVER02'
database = 'nn'
driver = 'ODBC Driver 17 for SQL Server'
conn_str = f"mssql+pyodbc://{server}/{database}?trusted_connection=yes&driver={driver.replace(' ', '+')}"
engine = create_engine(conn_str)

df_csv = pd.read_sql("SELECT * FROM CSV_HANDLE", engine)

timestamp = datetime.now().strftime('%Y-%m-%d_%H-%M-%S')
output_dir_csv = r"G:\My Drive\LEARNER_cSV"
os.makedirs(output_dir_csv, exist_ok=True)

csv_filename = f"csv_handle_{timestamp}.csv"
csv_path = os.path.join(output_dir_csv, csv_filename)

df_csv.to_csv(csv_path, index=False, encoding='utf-8-sig')
print(f"✅ CSV_HANDLE exported to: {csv_path}")

# -----------------------------
# 4️⃣ Export from NEWENROLLS
# -----------------------------
print("🔹 Step 4: Exporting NEWENROLLS data...")

df_newenrolls = pd.read_sql("SELECT * FROM NEWENROLLS", engine)

output_dir_new = r"G:\My Drive\CSV_HANDLE"
os.makedirs(output_dir_new, exist_ok=True)

new_filename = f"newenrolls_{timestamp}.csv"
new_path = os.path.join(output_dir_new, new_filename)

df_newenrolls.to_csv(new_path, index=False, encoding='utf-8-sig')
print(f"✅ NEWENROLLS exported to: {new_path}")

# -----------------------------
# 6️⃣ Export from NOT_ENROLLED
# -----------------------------
print("🔹 Step 6: Exporting NOT_ENROLLED data...")

df_not_enrolled = pd.read_sql("SELECT * FROM NOT_ENROLLED", engine)

output_dir3 = r"G:\My Drive\NOT_ENROLLED"
os.makedirs(output_dir3, exist_ok=True)

filename3 = f"not_enrolled_{timestamp}.csv"
csv_path3 = os.path.join(output_dir3, filename3)

df_not_enrolled.to_csv(csv_path3, index=False, encoding='utf-8-sig')

print(f"✅ Step 6 complete: NOT_ENROLLED exported to: {csv_path3}")

# -----------------------------
# 5️⃣ Cleanup
# -----------------------------
cursor.close()
conn.close()
engine.dispose()

print("\n🎉 All steps completed successfully!")
