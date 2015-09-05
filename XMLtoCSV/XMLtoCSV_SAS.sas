%Let fpath = C:\Path\To\SAS\File;
%let today = %sysfunc(today(),yymmddn8.);
%Let ext = .csv;

** STORING XML CONTENT;
libname temp xml 'C:\Path\To\XML\File'; 

** APPEND CONTENT TO SAS DATASET;
data Work.CLData;
	retain user city category post time link;
   	set temp.Missedconnection;
run;

** EXPORT DATASET TO CSV FILE;
proc export 
	data = Work.CLData
	outfile = "&fpath\CLData_&today&ext"
	dbms = csv replace;
run;

