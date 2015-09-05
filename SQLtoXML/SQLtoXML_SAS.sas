%Let fpath = C:\Path\To\SAS\File\;

** QUERYING DATABASE TABLE TO SAS DATASET;
proc sql;
	connect to odbc as conn
		("driver={MySQL ODBC 5.3 Unicode Driver};server=hostname; database=database; user=username; pwd=password;");
	create table CLData as
	select * from connection to conn
		(select * from cldata);
	disconnect from conn;
quit;

** EXPORT DATASET TO XML FILE;
filename out "&fpath\Cldata_SASOutput.xml";

libname out xml;                                               

data out.CLData;
 set Work.CLData;
run; 

libname out clear;

** STYLE RAW OUTPUT XML FILE;
filename xslfile temp;
data _null_;
  infile cards;
  input;
  file xslfile;
  put _infile_;
cards4;
<?xml version="1.0"?>
<xsl:stylesheet version="1.0"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
  <xsl:strip-space elements="*" />
  <xsl:output method="xml" indent="yes"/>   
  <xsl:template match="TABLE">    
    <xsl:element name="CLData">    
     <xsl:for-each select="CLDATA">
       <xsl:element name="missedConnection">
         <xsl:copy-of select="*"/>
       </xsl:element>
     </xsl:for-each>    
    </xsl:element>   
  </xsl:template>  
</xsl:stylesheet>
;;;;

proc xsl 
	in="&fpath\Cldata_SASOutput.xml"
	out="&fpath\Cldata_SASOutput.xml"
	xsl=xslfile;
run;
