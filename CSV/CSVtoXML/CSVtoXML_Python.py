import os
import csv
import lxml.etree as ET

cd = os.path.dirname(os.path.abspath(__file__))

# INITIALIZING XML FILE
root = ET.Element('CLData')

# READING CSV FILE
with open(os.path.join(cd, "CLData.csv")) as f:
    reader = csv.DictReader(f)
   
    # WRITING TO XML NODES 
    for row in reader:
        mcNode = ET.SubElement(root, "missedConnection")

        for k, v in row.items():
            ET.SubElement(mcNode, k).text = str(v)

# SAVING XML FILE
tree = ET.ElementTree(root)
tree_out = tree.write(os.path.join(cd, "CLData_Py.xml"), 
                      pretty_print=True, 
                      xml_declaration=True, 
                      encoding="UTF-8")

print("Successfully migrated CSV data to XML!")
