#!/usr/bin/python
import os, csv
import lxml.etree as ET

# PARSE XML
cd = os.path.dirname(os.path.abspath(__file__))
dom = ET.parse(os.path.join(cd, 'CLData.xml'))

# WRITE TO CSV
with open(os.path.join(cd,'CLData_Py.csv'), 'wb') as f:
    writer = csv.writer(f)    

    mc_nodes = dom.xpath('//missedConnection')
    writer.writerow([n.tag for n in mc_nodes[0]])

    for node in mc_nodes[1:]:
        writer.writerow([n.text for n in node])

print("Successfully migrated XML data to CSV!")
