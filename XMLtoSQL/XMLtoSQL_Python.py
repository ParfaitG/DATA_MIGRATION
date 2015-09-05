#!/usr/bin/python
import sys, os, datetime
import pymysql
import lxml.etree as ET

cd = os.path.dirname(os.path.abspath(__file__))
    
xmlfile = 'CLData.xml'
dom = ET.parse(os.path.join(cd, xmlfile))

# SET FILE NAME VALUES
i = datetime.datetime.today()
todaydate = i.strftime('%Y') + i.strftime('%m') + i.strftime('%d')

# DB CONNECTION
db = pymysql.connect(host="hostname", user="username",
                      passwd="password", db="database")
 
cur = db.cursor() 


# DEFINING COLUMNS
columns = ['user', 'category', 'city', 'post', 'time', 'link']

print("Please wait...")

# OPEN CSV FILE
nodexpath = dom.xpath('//missedConnection')

r = 0
dataline = []    
for j in range(1,len(nodexpath)+1):
    
    dataline = []
    for col in columns:
        # LOCATE PATH OF NODE VALUE
        childxpath = dom.xpath('//missedConnection[{0}]/{1}'.format(j, col))

        # APPEND DATA LINES   
        for elem in childxpath:
            dataline.append(elem.text)

        if childxpath == []:
            dataline.append('')     

    sql = "INSERT INTO cldata ({0}) VALUES {1}".format((", ").join(columns), tuple(dataline,))    
    cur.execute(sql)
    db.commit()
    r += 1

# CLOSE CURSOR AND DB
cur.close()
db.close()

# SUCCESS MESSAGE
print("Successfully migrated {0} rows of XML data to SQL!".format(r))
