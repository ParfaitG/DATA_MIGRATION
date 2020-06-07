import os
import json
import sqlite3

# CONNECT TO DATABASE
cd = os.path.dirname(os.path.abspath(__file__))
db = sqlite3.connect(database=os.path.join(cd, 'CLData.db'))

# QUERY DATABASE
db.row_factory = sqlite3.Row
cur = db.cursor()
cur.execute("SELECT * FROM cldata")

data = [dict(row) for row in cur.fetchall()]

cur.close()
db.close()

# JSON EXPORT
jsondata = json.dumps(data, indent=4)

with open(os.path.join(cd, 'CLData_Py.json'),'w') as f:
    f.write(jsondata)    

print("Successfully migrated SQL data to JSON!")
