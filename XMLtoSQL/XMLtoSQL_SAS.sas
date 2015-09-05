
** STORING XML CONTENT;
libname tempdata xml 'D:\Documents\GitHub\DATA_MIGRATION\Cldata.xml'; 

** APPEND CONTENT TO SAS DATASET;
data Work.CLData;	
   	set tempdata.Missedconnection;	
	newtime = put(time, is8601dt.);	
	drop time;
 	rename newtime = time;		
run;

data Work.CLData;	
	retain user city category post time link;
   	set Work.CLData;				
run;

** CONNECT TO DATABASE;
libname mydata odbc complete="driver=MySQL ODBC 5.3 Unicode Driver; Server=hostname; user=username; pwd=password; database=database;";

** APPEND TO TABLE;
proc datasets;
	append base = mydata.cldata
    data = Work.Cldata
    force;
quit;

** UN-ASSIGN ODBC LIBRARY;
libname mydata clear;
