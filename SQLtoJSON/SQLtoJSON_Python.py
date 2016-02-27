import os
import json
import pymysql
from collections import OrderedDict

cd = os.path.dirname(os.path.abspath(__file__))

# IMPORT SQL DATA
db = pymysql.connect(host="localhost", db="****", 
                      user="****", passwd="****") 
cur = db.cursor()
cur.execute("SELECT * FROM cldata")

# EXTRACT DATA ROW BY ROW
data = []
inner = OrderedDict()
for row in cur.fetchall():
    inner['user'] = row[1]
    inner['category'] = row[2]
    inner['city'] = row[3]
    inner['post'] = row[4]
    inner['time'] = row[5]
    inner['link'] = row[6]
    
    data.append(inner)
    inner = OrderedDict()

cur.close()
db.close()

# EXPORT TO FILE
jsondata = json.dumps(data, indent=4)

with open(os.path.join(cd, 'Cldata_PY.json'),'w') as jsonfile:
    jsonfile.write(jsondata)    
jsonfile.close()

print("Successfully migrated sql data to json!")

