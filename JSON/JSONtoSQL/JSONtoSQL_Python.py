import os
import json
import sqlite3

# READ JSON
cd = os.path.dirname(os.path.abspath(__file__))
with open(os.path.join(cd,'CLData.json')) as f:    
    data = json.load(f)

# OPEN DB CONNECTION
db = sqlite3.connect(os.path.join(cd, "CLData.db")) 
cur = db.cursor()

# APPEND TO DB
sql = "DELETE FROM cldata"
cur.execute(sql)
db.commit()

sql = "INSERT INTO cldata ({cols}) VALUES ({prms})"
sql = sql.format(cols=", ".join(data[0].keys()), 
                 prms=", ".join(['?'] * len(data[0])))  

cur.executemany(sql, [list(d.values()) for d in data])
db.commit()

# CLOSE DB CONNECTION
cur.close()
db.close()

print("Successfully migrated JSON data to SQL database!")
