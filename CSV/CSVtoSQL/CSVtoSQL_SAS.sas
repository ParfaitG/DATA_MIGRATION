%let fpath = C:\Path\To\Work\Directory;

** READING IN CSV;
proc import
   datafile = "&fpath\CLData.csv"
   out = CLData
   dbms = csv;
run;

data Work.CLData;	
   retain user city category post time link;
   set Work.CLData;				
run;

** ASSIGN LIBRARY TO ODBC DATABASE;
libname dbdata odbc complete="DRIVER=SQLite3 ODBC Driver;Database=&fpath\CLData.db;";

** APPEND TO DATABASE TABLE;
proc datasets;
   append base = dbdata.cldata
   data = Work.CLData
   force;
quit;

** UN-ASSIGN ODBC LIBRARY;
libname dbdata clear;

put 'Successfully migrated CSV data into SQL database';
