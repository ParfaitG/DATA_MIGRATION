%Let fpath = C:\Path\To\SAS\Script;

** READING IN CSV;
proc import
	datafile = "&fpath\CLData.csv"
	out = CLData
	dbms = csv;
run;

** EXPORT DATASET TO XML FILE;
filename out "&fpath\Cldata_SASOutput.xml";

libname out xml;                                               

data out.CLData;
 set Work.CLData;
run; 

libname out clear;

** STYLE RAW OUTPUT XML FILE WITH XSLT;
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
