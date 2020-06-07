%let fpath = C:\Path\To\Work\Directory;

** IMPORT XML
libname tempdata xml '&fpath\CLData.xml'; 

** APPEND CONTENT TO SAS DATASET;
data Work.CLData;
   ** REORDERING COLUMNS;
   retain user city category post time link;
   set tempdata.Missedconnection;	
run;

** EXPORT JSON
proc json
   out = "&fpath\CLData_SAS.json"
   pretty;
   export CLData / nosastags;
run;

put 'Successfully migrated XML data to JSON!';
