%Let fpath = C:\Path\To\SAS\Script;

** READING IN CSV;
proc import
	datafile = "&fpath\CLData.csv"
	out = CLData
	dbms = csv;
run;

** CLEANING UP TIME FIELD;
data Work.CLData;	
   	set Work.CLData;	
	newtime = put(time, is8601dt.);	
	drop time;
 	rename newtime = time;		
run;

data Work.CLData;	
	retain user city category post time link;
   	set Work.CLData;				
run;

** ASSIGN LIBRARY TO ODBC DATABASE;
libname mydata odbc complete="driver=MySQL ODBC 5.3 Unicode Driver; Server=hostname; user=username; pwd=password; database=database;";

** APPEND TO DATABASE TABLE;
proc datasets;
	append base = mydata.cldata
    data = Work.Cldata
    force;
quit;

** UN-ASSIGN ODBC LIBRARY;
libname mydata clear;
