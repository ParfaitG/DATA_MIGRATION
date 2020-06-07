%let fpath = C:\Path\To\Work\Directory;

libname mylib "&fpath."; 

** READ CSV, SAVE, AND LOAD OBJECT
proc import
   datafile = "&fpath\..\..\CSV\CSVtoXML\CLData.csv"
   out = mylib.CLData
   dbms = csv;
run;

proc print data=mylib.CLData (obs=5);
run;

put 'Successfully created binary data!';
