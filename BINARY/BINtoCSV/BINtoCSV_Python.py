import os
import pickle
import csv

cd = os.path.dirname(os.path.abspath(__file__))
os.chdir("../BuildBINs")

# LOAD OBJECT
with open('CLData_Py.pkl', 'rb') as f:
    data = pickle.load(f)

# WRITE TO CSV
with open(os.path.join(cd, 'CLData_Py.csv'), 'w', newline='') as csvfile:
    writer = csv.writer(csvfile)
    writer.writerow(list(data[0].keys()))  

    for d in data:        
        writer.writerow(list(d.values()))    

print("Successfully migrated binary data to CSV!")
