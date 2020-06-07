%let fpath = C:\Path\To\Work\Directory;

** READ OBJECT
libname mylib "&fpath\..\BuildBINs";

** EXPORT JSON
proc json
   out = "&fpath\CLData_SAS.json"
   pretty;
   export mylib.CLData / nosastags;
run;

put 'Successfully converted binary data to JSON!';
