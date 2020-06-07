import os
import csv
import pickle

cd = os.path.dirname(os.path.abspath(__file__))
os.chdir("../../CSV/CSVtoXML")

# READ CSV DATA
with open("CLData.csv") as f:
    reader = csv.DictReader(f)
    data = [row for row in reader]

# SAVE OBJECT
with open(os.path.join(cd, 'CLData_Py.pkl'), 'wb') as f:
    pickle.dump(data, f, pickle.HIGHEST_PROTOCOL)

# LOAD OBJECT
with open(os.path.join(cd, 'CLData_Py.pkl'), 'rb') as f:
    new_data = pickle.load(f)

print(new_data[0:5])

print("Successfully created binary data!")
