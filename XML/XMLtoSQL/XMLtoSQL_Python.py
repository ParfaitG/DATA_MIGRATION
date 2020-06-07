#!/usr/bin/python
import os
import sqlite3
import lxml.etree as ET

cd = os.path.dirname(os.path.abspath(__file__))

# PARSE XML
dom = ET.parse(os.path.join(cd, "CLData.xml"))

mc_nodes = dom.xpath('//missedConnection')
data = [{el.tag:el.text for el in n} for n in mc_nodes]

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

print("Successfully migrated XML data into SQL database!")
