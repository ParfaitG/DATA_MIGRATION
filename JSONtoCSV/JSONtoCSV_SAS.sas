%Let fpath = C:\Path\To\Working\Directory;

data Cldata;
    infile "&fpath\Cldata.json" lrecl=32000 truncover dsd firstobs=3 ;	

    input @'"user":' User $255.
        / @'"category":' Category $255.
        / @'"city":' City $255.
        / @'"post":' Post $255.
		/ @'"time":' Time $255.
		/ @'"link":' Link $255.
        /
        /
    ;
	User = tranwrd(tranwrd(User, '"', ''), ',','');
	Category = tranwrd(tranwrd(Category, '"', ''), ',','');
	City = tranwrd(tranwrd(City, '"', ''), ',','');
	Post = tranwrd(tranwrd(Post, '"', ''), ',','');
	Time = tranwrd(tranwrd(Time, '"', ''), ',','');
	Link = tranwrd(tranwrd(Link, '"', ''), ',','');

	_infile_ = tranwrd(_infile_,'"','');
run;

** EXPORT DATASET TO CSV FILE;
proc export 
	data = Work.Cldata
	outfile = "fpath\Cldata_SAS.csv"
	dbms = csv replace;
run;
