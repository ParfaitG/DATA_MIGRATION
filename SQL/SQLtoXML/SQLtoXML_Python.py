#!/usr/bin/python
import os
import sqlite3
import lxml.etree as ET

cd = os.path.dirname(os.path.abspath(__file__))

# CONNECT TO DATABASE
db = sqlite3.connect(os.path.join(cd, "CLData.db"))
db.row_factory = sqlite3.Row
cur = db.cursor() 

# QUERY DATABASE
cur.execute('SELECT * FROM cldata')

# INITIALIZE XML
root = ET.Element('CLData')

for row in cur.fetchall():
    mcNode = ET.SubElement(root, "missedConnection")

    for k,v in dict(row).items():
       ET.SubElement(mcNode, k).text = v

# CLOSE CURSOR AND DATABASE
cur.close()
db.close()

# WRITE XML
tree = ET.ElementTree(root)
tree.write(os.path.join(cd, "CLData_Py.xml"), 
          pretty_print=True, 
          xml_declaration=True, 
          encoding="UTF-8")

print("Successfully migrated SQL data to XML!")
