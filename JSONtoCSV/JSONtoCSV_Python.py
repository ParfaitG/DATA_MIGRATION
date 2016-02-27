import os
import json
import csv
from collections import OrderedDict

cd = os.path.dirname(os.path.abspath(__file__))

# READ IN JSON FILE INTO LIST
with open(os.path.join(cd,'Cldata.json')) as data_file:    
    data = json.load(data_file, object_pairs_hook=OrderedDict)

# ITERATE THROUGH LIST, APPENDING TO CSV
with open(os.path.join(cd, 'Cldata_PY.csv'), 'w', newline='') as csvfile:
    writer = csv.writer(csvfile)
    writer.writerow(['user', 'category', 'city', 'time', 'post', 'link'])  
    for i in data:        
        writer.writerow([i['user'], i['category'], i['city'], i['time'], i['post'], i['link']])    

print("Successfully migrated json data to csv!")
