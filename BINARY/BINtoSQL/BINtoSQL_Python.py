import os
import pickle
import sqlite3

cd = os.path.dirname(os.path.abspath(__file__))

# LOAD OBJECT
with open(os.path.join(cd, '../BuildBINs/CLData_Py.pkl'), 'rb') as f:
    data = pickle.load(f)

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

print("Successfully migrated binary data to SQL database!")
