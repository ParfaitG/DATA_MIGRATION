#!/usr/bin/python
import os
import csv
import sqlite3

cd = os.path.dirname(os.path.abspath(__file__))
    
# OPEN DATABASE CONNECTION
db = sqlite3.connect(database=os.path.join(cd, "CLData.db"))

cur = db.cursor() 
cur.execute("SELECT * FROM cldata")

# WRITE ROWS TO CSV
with open(os.path.join(cd, 'CLData_Py.csv'), 'w', newline='') as f:
    writer = csv.writer(f)
    writer.writerow([desc[0] for desc in cur.description])

    for row in cur.fetchall():
        writer.writerow(row)

# CLOSE CURSOR AND DATABASE        
cur.close()
db.close()

print("Successfully migrated SQL data to CSV!")

