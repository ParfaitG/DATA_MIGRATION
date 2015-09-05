#!/usr/bin/python
import sys, os, datetime
import csv
import pymysql


cd = os.path.dirname(os.path.abspath(__file__))

i = datetime.datetime.today()
todaydate = i.strftime('%Y') + i.strftime('%m') + i.strftime('%d')


# OPEN CSV AND WRITE COLUMN HEADERS
columns = ['user', 'category', 'city', 'post', 'time', 'link']

with open(os.path.join(cd,'CLData_{0}.csv'.format(todaydate)), 'w', newline='') as f:
    writer = csv.writer(f)    
    writer.writerow(columns)
    f.close()

    
# OPEN DATABASE CONNECTION
db = pymysql.connect(host="hostname", port=portnumber,
                     user="username", passwd="password", 
                     db="database") 

cur = db.cursor() 
cur.execute("SELECT * FROM cldata;")


# WRITE QUERY RESULTSET TO CSV
with open(os.path.join(cd,'CLData_{0}.csv'.format(todaydate)), 'a', newline='') as f:
    writer = csv.writer(f)
    
    for row in cur.fetchall():
        writer.writerow(row)

f.close()

# CLOSE CURSOR AND DATABASE        
cur.close()
db.close()

print("Successfully migrated SQL data to CSV!")

