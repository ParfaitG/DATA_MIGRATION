import os
import lxml.etree as ET
import json
import pandas as pd
from collections import OrderedDict

cd = os.path.dirname(os.path.abspath(__file__))

# XML IMPORT
xmlfile = 'CLData.xml'
dom = ET.parse(os.path.join(cd, xmlfile))

nodexpath = dom.xpath('//missedConnection')
columns = ['user', 'category', 'city', 'post', 'time', 'link']

data = []
inner = OrderedDict()
# EXTRACT DATA NODE BY NODE
for j in range(1,len(nodexpath)+1):
    
    for col in columns:
           
        childxpath = dom.xpath('//missedConnection[{0}]/*'.format(j))

        inner['user'] = childxpath[0].text
        inner['category'] = childxpath[1].text
        inner['city'] = childxpath[2].text
        inner['post'] = childxpath[3].text
        inner['time'] = childxpath[4].text
        inner['link'] = childxpath[5].text
        
    data.append(inner)
    inner = OrderedDict()

# CONVERT TO JSON
jsondata = json.dumps(data, indent=4)

# PRETTY PRINT EXPORT
with open(os.path.join(cd, 'Cldata_PY.json'),'w') as jsonfile:
    jsonfile.write(jsondata)    
jsonfile.close()

print("Successfully migrated xml data to json!")
