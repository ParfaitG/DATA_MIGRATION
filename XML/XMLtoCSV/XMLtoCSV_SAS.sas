%let fpath = C:\Path\To\Work\Directory;

** IMPORT XML
libname tempdata xml '&fpath\CLData.xml'; 

** APPEND CONTENT TO SAS DATASET;
data Work.CLData;
   ** REORDERING COLUMNS;
   retain user city category post time link;
   set tempdata.Missedconnection;
run;

** EXPORT CSV
proc export 
   data = Work.CLData
   outfile = "&fpath\CLData_SAS.csv"
   dbms = csv replace;
run;

put 'Successfully migrated XML data to CSV!';
