import os
import json, csv

# READ JSON
cd = os.path.dirname(os.path.abspath(__file__))
with open(os.path.join(cd,'CLData.json')) as data_file:    
    data = json.load(data_file)

# WRITE TO CSV
with open(os.path.join(cd, 'CLData_Py.csv'), 'w', newline='') as csvfile:
    writer = csv.writer(csvfile)
    writer.writerow(list(data[0].keys()))  

    for d in data:        
        writer.writerow(list(d.values()))    

print("Successfully migrated JSON data to CSV!")
