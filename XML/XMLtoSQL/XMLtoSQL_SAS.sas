%let fpath = C:\Path\To\Work\Directory;

** IMPORT XML
libname tempdata xml '&fpath\CLData.xml'; 

** APPEND CONTENT TO SAS DATASET
data Work.CLData;
   ** REORDERING COLUMNS
   retain user city category post time link;
   set tempdata.missedConnection;		
run;

** CONNECT TO DB
libname dbdata odbc complete="DRIVER=SQLite3 ODBC Driver;Database=&fpath\CLData.db;";

** APPEND TO DB
proc datasets;
   append base = dbdata.cldata
   data = Work.CLData
   force;
quit;

libname dbdata clear;

put 'Successfully migrated XML data into SQL database!';
