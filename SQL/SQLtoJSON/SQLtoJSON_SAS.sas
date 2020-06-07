%Let fpath = C:\Path\To\Working\Directory;

** ASSIGN LIBRARY TO ODBC DATABASE;
libname sqldata odbc complete="driver={SQLite3 ODBC Driver};database=&fpath\CLData.db;";

** APPEND CONTENT TO SAS DATASET;
data Work.CLData;	
   retain user city category post time link;
   set sqldata.Cldata;
run;

** UN-ASSIGN ODBC LIBRARY;
libname sqldata clear;

** EXPORTING TO JSON;
proc json
   out = "&fpath\CLData_SAS.json"
   pretty;
   export CLData / nosastags;
run;

put 'Successfully migrated SQL data to JSON!';
