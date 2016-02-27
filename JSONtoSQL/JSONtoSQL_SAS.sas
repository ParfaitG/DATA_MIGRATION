filename jsonfile 'C:\Path\To\Working\Directory\Cldata.json';

** READ IN JSON CONTENT;
data Cldata;
    infile jsonfile lrecl=32000 truncover dsd firstobs=3 ;	

    input @'"user":' User 
        / @'"category":' Category $100.
        / @'"city":' City $100.
        / @'"post":' Post $100.
		/ @'"time":' Time $100.
		/ @'"link":' Link $255.
        /
        /
    ;
	Category = tranwrd(tranwrd(Category, '"', ''), ',','');
	City = tranwrd(tranwrd(City, '"', ''), ',','');
	Post = tranwrd(tranwrd(Post, '"', ''), ',','');
	Time = tranwrd(tranwrd(Time, '"', ''), ',','');
	Link = tranwrd(tranwrd(Link, '"', ''), ',','');

	_infile_ = tranwrd(_infile_,'"','');
run;

** ASSIGN LIBRARY TO ODBC DATABASE;
libname mydata odbc complete="driver=MySQL ODBC 5.3 Unicode Driver; Server=localhost; 
                              database=****; user=****; pwd=****;";

** APPEND TO DATABASE TABLE;
proc datasets noprint;
	append base = mydata.cldata
    data = Work.Cldata
    force;
quit;

** UN-ASSIGN ODBC LIBRARY;
libname mydata clear;
