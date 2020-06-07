%let fpath = C:\Path\To\Work\Directory;
filename jsonfile 'C:\Path\To\Working\Directory\CLData.json';

** READ IN JSON CONTENT;
data cldata;
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
libname dbdata odbc complete="DRIVER=SQLite3 ODBC Driver;Database=&fpath\CLData.db;";

** APPEND TO DATABASE TABLE;
proc datasets noprint;
    append base = dbdata.cldata
    data = Work.cldata
    force;
quit;

** UN-ASSIGN ODBC LIBRARY;
libname mydata clear;

put 'Successfully migrated JSON data to SQL database';
