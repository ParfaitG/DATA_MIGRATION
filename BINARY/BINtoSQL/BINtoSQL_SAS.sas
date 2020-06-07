%let fpath = C:\Path\To\Work\Directory;

** READ OBJECT
libname mylib "&fpath\..\BuildBINs";

** CONNECT TO DB
libname dbdata odbc complete="DRIVER=SQLite3 ODBC Driver;Database=&fpath\CLData.db;";

** APPEND TO DB
proc datasets;
   append base = dbdata.cldata
   data = mylib.CLData
   force;
quit;

libname dbdata clear;

put 'Successfully migrated binary data into SQL database';
