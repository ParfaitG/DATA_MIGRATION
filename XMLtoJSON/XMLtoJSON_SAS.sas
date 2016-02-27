%Let fpath = C:\Path\To\Working\Directory;

** STORING XML CONTENT;
libname tempdata xml 'C:\Path\To\Working\Directory\Cldata.xml'; 

** APPEND CONTENT TO SAS DATASET;
data Work.CLData;	
   	set tempdata.Missedconnection;	
	newtime = put(time, is8601dt.);	
	drop time;
 	rename newtime = time;		
run;

data Work.CLData;	
    ** REORDERING COLUMNS;
	retain user city category post time link;
   	set Work.CLData;				
run;

** EXPORTING TO JSON;
proc json
	out = "&fpath\Cldata_SAS.json"
	pretty;
	export Cldata / nosastags;
run;
