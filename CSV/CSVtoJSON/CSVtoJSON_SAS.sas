%let fpath = C:\Path\To\Work\Directory;

** READ CSV
proc import
   datafile = "&fpath\CLData.csv"
   out = Cldata
   dbms = csv;
run;

** EXPORT JSON
proc json
   out = "&fpath\CLData_SAS.json"
   pretty;
   export Cldata / nosastags;
run;

put 'Successfully migrated CSV data to JSON!';
