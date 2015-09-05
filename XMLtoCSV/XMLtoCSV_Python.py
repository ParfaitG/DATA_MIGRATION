#!/usr/bin/python
import sys, os, datetime
import csv
import lxml.etree as ET

cd = os.path.dirname(os.path.abspath(__file__))

xmlfile = 'CLData.xml'
dom = ET.parse(os.path.join(cd, xmlfile))

# SET FILE NAME VALUES
i = datetime.datetime.today()
todaydate = i.strftime('%Y') + i.strftime('%m') + i.strftime('%d')

# DEFINING COLUMNS
columns = ['user', 'category', 'city', 'post', 'time', 'link']

print("Please wait...")

# OPEN CSV FILE
with open(os.path.join(cd,'CLData_{0}.csv'.format(todaydate)), 'w', newline='') as m:
    writer = csv.writer(m)    
    writer.writerow(columns)

    nodexpath = dom.xpath('//missedConnection')

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

        writer.writerow(dataline)

# SUCCESS MESSAGE
print("Successfully converted XML data to CSV!")
