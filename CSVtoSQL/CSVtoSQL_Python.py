#!/usr/bin/python
import os
import csv, pymysql

cd = os.path.dirname(os.path.abspath(__file__))

# DB CONNECTION
db = pymysql.connect(host="hostname", user="username",
                      passwd="password", db="database")
 
cur = db.cursor()

# READING CSV FILE
with open(os.path.join(cd, "CLData.csv")) as f:
    next(f)
    reader = csv.reader(f)

    data = []    
    for row in reader:        
        data.append(row)
        
    f.close()

# DEFINING COLUMNS
columns = ['user', 'category', 'city', 'post', 'time', 'link']
print("Please wait...")


# APPENDING TO DATABASE
for r in data:    
    sql = "INSERT INTO cldata ({0}) VALUES {1}".format((", ").join(columns), tuple(r,))    
    cur.execute(sql)
    db.commit()
    

# CLOSE CURSOR AND DB
cur.close()
db.close()

# SUCCESS MESSAGE
print("Successfully migrated CSV to SQL data!")
