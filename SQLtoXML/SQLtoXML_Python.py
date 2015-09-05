#!/usr/bin/python
import sys, os, datetime
import pymysql
import lxml.etree as ET

cd = os.path.dirname(os.path.abspath(__file__))

# SET FILE NAME VALUES
i = datetime.datetime.today()
todaydate = i.strftime('%Y') + i.strftime('%m') + i.strftime('%d')


# DB CONNECTION AND QUERY
db = pymysql.connect(host="hostname", user="username",
                      passwd="password", db="database") 
cur = db.cursor() 
cur.execute('SELECT `user`, `category`, `city`, `post`, `time`, `link` FROM cldata')

# WRITING XML FILE
root = ET.Element('CLData')

for row in cur.fetchall():
    mcNode = ET.SubElement(root, "missedConnection")
    ET.SubElement(mcNode, "user").text = str(row[0])    
    ET.SubElement(mcNode, "category").text = row[1]
    ET.SubElement(mcNode, "city").text = row[2]    
    ET.SubElement(mcNode, "post").text = row[3]    
    ET.SubElement(mcNode, "time").text = row[4]    
    ET.SubElement(mcNode, "link").text = row[5]


# CLOSE CURSOR AND DATABASE
cur.close()
db.close()

tree_out = (ET.tostring(root, pretty_print=True))

xmlfile = open(os.path.join(cd, 'CLData_Output.xml'),'wb')
xmlfile.write(tree_out)
xmlfile.close()


# SUCCESS MESSAGE
print("Successfully migrated SQL to XML data!")
