%Let fpath = C:\Path\To\Working\Folder;

** QUERY DATABASE;
proc sql;
	connect to odbc as conn
		("driver={SQLite3 ODBC Driver};database=&fpath\CLData.db;");
	create table CLData as
	select * from connection to conn
		(select * from cldata);
	disconnect from conn;
quit;

** EXPORT TO CSV;
proc export 
	data = Work.CLData
	outfile = "&fpath\CLData_SAS.csv"
	dbms = csv replace;
run;

put 'Successfully migrated SQL data to CSV';
