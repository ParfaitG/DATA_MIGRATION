import os
import pickle
import json

cd = os.path.dirname(os.path.abspath(__file__))
os.chdir("../BuildBINs")

# LOAD OBJECT
with open('CLData_Py.pkl', 'rb') as f:
    data = pickle.load(f)

jsondata = json.dumps(data, indent=4)

# JSON EXPORT
with open(os.path.join(cd, 'CLData_Py.json'),'w') as jsonfile:
    jsonfile.write(jsondata)    

print("Successfully converted binary data to JSON!")

