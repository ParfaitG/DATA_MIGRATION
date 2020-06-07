%let fpath = C:\Path\To\Work\Directory;

** READ CSV
proc import
   datafile = "&fpath\CLData.csv"
   out = CLData
   dbms = csv;
run;

** EXPORT XML
filename out "&fpath\CLData_SAS.xml";

libname out xml;                                               

data out.CLData;
   set Work.CLData;
run; 

libname out clear;

** RUN XSLT FOR PRETTY PRINT
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
   in="&fpath\CLData_SAS.xml"
   out="&fpath\CLData_SAS.xml"
   xsl=xslfile;
run;

put 'Successfully migrated CSV data to XML';
