#!/usr/bin/python
import os
import csv, lxml.etree as ET

cd = os.path.dirname(os.path.abspath(__file__))

# INITIALIZING XML FILE
root = ET.Element('CLData')

# READING CSV FILE
with open(os.path.join(cd, "CLData.csv")) as f:
    next(f)
    reader = csv.reader(f)

    data = []    
    for row in reader:        
        data.append(row)
        
    f.close()

# WRITING TO XML NODES
for i in range(len(data)):    
    mcNode = ET.SubElement(root, "missedConnection")
    ET.SubElement(mcNode, "user").text = str(data[i][0])    
    ET.SubElement(mcNode, "category").text = data[i][1]
    ET.SubElement(mcNode, "city").text = data[i][2]    
    ET.SubElement(mcNode, "post").text = data[i][3]
    ET.SubElement(mcNode, "time").text = data[i][4]    
    ET.SubElement(mcNode, "link").text = data[i][5]

tree_out = (ET.tostring(root, pretty_print=True, xml_declaration=True, encoding="UTF-8"))

# OUTPUTTING XML CONTENT TO FILE
xmlfile = open(os.path.join(cd, 'CLData_PyOutput.xml'),'wb')
xmlfile.write(tree_out)
xmlfile.close()

print("Successfully migrated CSV to XML data!")
