import os
import json
from collections import OrderedDict
import lxml.etree as ET

cd = os.path.dirname(os.path.abspath(__file__))

# READ IN JSON FILE INTO LIST
with open(os.path.join(cd,'Cldata.json')) as data_file:    
    data = json.load(data_file, object_pairs_hook=OrderedDict)

# INITIALIZING XML DOC
root = ET.Element('CLData')

# ITERATE THROUGH LIST, APPENDING TO XML
for i in data:
    mcNode = ET.SubElement(root, "missedConnection")
    
    for key, value in i.items():                
        ET.SubElement(mcNode, key).text = str(value)            

tree_out = (ET.tostring(root, pretty_print=True, xml_declaration=True, encoding="UTF-8"))

# OUTPUTTING XML CONTENT TO FILE
xmlfile = open(os.path.join(cd, 'CLData_PY.xml'),'wb')
xmlfile.write(tree_out)
xmlfile.close()

print("Successfully migrated json data to xml!")

