%Let fpath = C:\Path\To\Working\Directory;

** ASSIGN LIBRARY TO ODBC DATABASE;
libname mydata odbc complete="driver=MySQL ODBC 5.3 Unicode Driver; Server=localhost; 
                              database=****; user=****; pwd=****;";

** APPEND CONTENT TO SAS DATASET;
data Work.Cldata;	
	retain user city category post time link;
   	set mydata.Cldata;	
	drop id;	
run;

** UN-ASSIGN ODBC LIBRARY;
libname mydata clear;

** EXPORTING TO JSON;
proc json
	out = "&fpath\Cldata_SAS.json"
	pretty;
	export Cldata / nosastags;
run;
