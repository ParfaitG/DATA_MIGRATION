%Let fpath = D:\Freelance Work\Sandbox\CSVtoJSON\;

** READING IN CSV;
proc import
	datafile = "&fpath\Cldata.csv"
	out = Cldata
	dbms = csv;
run;

** EXPORTING TO JSON;
proc json
	out = "&fpath\Cldata_SAS.json"
	pretty;
	export Cldata / nosastags;
run;
