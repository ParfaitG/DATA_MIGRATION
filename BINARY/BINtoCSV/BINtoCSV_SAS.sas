%Let fpath = C:\Path\To\Working\Directory;

** READ OBJECT
libname mylib "&fpath\..\BuildBINs";

** EXPORT CSV;
proc export 
    data = mylib.Cldata
    outfile = "&fpath\CLData_SAS.csv"
    dbms = csv replace;
run;

put 'Successfully migrated binary data to CSV!';
