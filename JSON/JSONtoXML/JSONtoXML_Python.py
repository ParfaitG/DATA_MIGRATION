import os
import json
import lxml.etree as ET

# READ JSON
cd = os.path.dirname(os.path.abspath(__file__))
with open(os.path.join(cd,'CLData.json')) as f:    
    data = json.load(f)

# INITIALIZING XML FILE
root = ET.Element('CLData')

# WRITING TO XML NODES
for i in data:
    mcNode = ET.SubElement(root, "missedConnection")
    
    for key, value in i.items():                
        ET.SubElement(mcNode, key).text = str(value)            

# WRITE XML
tree = ET.ElementTree(root)
tree.write(os.path.join(cd, "CLData_Py.xml"), 
          pretty_print=True, 
          xml_declaration=True, 
          encoding="UTF-8")

print("Successfully migrated JSON data to XML!")

