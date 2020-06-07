#!/usr/bin/python
import os, json
import lxml.etree as ET

# PARSE XML
cd = os.path.dirname(os.path.abspath(__file__))
dom = ET.parse(os.path.join(cd, 'CLData.xml'))

mc_nodes = dom.xpath('//missedConnection')
data = [{el.tag:el.text for el in n} for n in mc_nodes]

# CONVERT TO JSON
jsondata = json.dumps(data, indent=4)

# PRETTY PRINT EXPORT
with open(os.path.join(cd, 'CLData_Py.json'),'w') as jsonfile:
    jsonfile.write(jsondata)    

print("Successfully migrated XML data to JSON!")
