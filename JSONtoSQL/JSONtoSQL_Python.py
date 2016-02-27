import os
import json
from collections import OrderedDict
import pymysql

cd = os.path.dirname(os.path.abspath(__file__))

# READ IN JSON FILE INTO LIST
with open(os.path.join(cd,'Cldata.json')) as data_file:    
    data = json.load(data_file, object_pairs_hook=OrderedDict)

# DB CONNECTION
db = pymysql.connect(host="localhost", db="****", 
                      user="****", passwd="****") 

# DB IMPORT
cur = db.cursor()

for i in data:    
    cur.execute("INSERT INTO ClData (user, category, city, time, post, link)" \
                " VALUES (%s, %s, %s, %s, %s, %s)", \
                (i['user'], i['category'], i['city'], i['time'], i['post'], i['link']))
    db.commit()                
cur.close()
db.close()
print("Successfully migrated json data to sql!")
