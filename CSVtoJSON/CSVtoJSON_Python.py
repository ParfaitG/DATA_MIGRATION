import os
import csv
import json
from collections import OrderedDict

cd = os.path.dirname(os.path.abspath(__file__))

# CSV IMPORT
data = []
inner = OrderedDict()
with open(os.path.join(cd, 'Cldata.csv')) as csvfile:    
    reader = csv.reader(csvfile)
    next(csvfile)
    for row in reader:
        inner['user'] = row[0]
        inner['city'] = row[1]
        inner['category'] = row[2]
        inner['post'] = row[3]
        inner['time'] = row[4]        
        inner['link'] = row[5]
        
        data.append(inner)
        inner = OrderedDict()

jsondata = json.dumps(data, indent=4)

with open(os.path.join(cd, 'Cldata_PY.json'),'w') as jsonfile:
    jsonfile.write(jsondata)    
jsonfile.close()

print("Successfully migrated csv data to json!")

