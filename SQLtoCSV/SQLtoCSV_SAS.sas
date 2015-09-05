%Let fpath = C:\Path\To\Cldata_;
%let today = %sysfunc(today(),yymmddn8.);
%Let ext = .csv;

** QUERYING DATABASE TABLE TO SAS DATASET;
proc sql;
	connect to odbc as conn
		("driver={MySQL ODBC 5.3 Unicode Driver};server=hostname; database=database; user=username; pwd=password;");
	create table CLData as
	select * from connection to conn
		(select * from cldata);
	disconnect from conn;
quit;

** EXPORT DATASET TO CSV FILE;
proc export 
	data = Work.CLData
	outfile = "&fpath&today&ext"
	dbms = csv replace;
run;

