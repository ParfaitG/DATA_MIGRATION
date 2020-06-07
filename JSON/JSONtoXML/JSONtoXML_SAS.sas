%Let fpath = C:\Path\To\Working\Directory;

filename jsonfile "&fpath\CLData.json";

** READ IN JSON CONTENT;
data Cldata;
    infile jsonfile lrecl=32000 truncover dsd firstobs=3 ;	

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

** EXPORT DATASET TO XML FILE;
filename out "&fpath\CLData_SAS.xml";

libname out xml XMLENCODING='UTF-8';                                               

data out.CLData;
 	set Work.CLData;
	user = trim(user);
	category = trim(category);
run;

** XSLT PROCESSING TO REFORMAT FROM SAS DEFAULT;
filename xslfile temp;

data _null_;
  infile cards;
  input;
  file xslfile;
  put _infile_;
cards4;
<xsl:transform xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">
<xsl:output version="1.0" encoding="UTF-8" indent="yes" />
<xsl:strip-space elements="*"/>  
  <xsl:template match="@*|node()">
    <xsl:copy>
      <xsl:apply-templates select="@*|node()"/>
    </xsl:copy>
  </xsl:template>
  <xsl:template match="TABLE">    
    <xsl:element name="CLData">
      <xsl:apply-templates select="*"/>
    </xsl:element>
  </xsl:template>
   <xsl:template match="CLDATA">
       <xsl:element name="missedConnection">
         <user><xsl:value-of select="normalize-space(User)"/></user>
         <category><xsl:value-of select="normalize-space(Category)"/></category>
         <city><xsl:value-of select="normalize-space(City)"/></city>
         <time><xsl:value-of select="normalize-space(Time)"/></time>
         <post><xsl:value-of select="normalize-space(Post)"/></post>
         <link><xsl:value-of select="normalize-space(Link)"/></link>
      </xsl:element>   
  </xsl:template>  
</xsl:transform>
;;;;

proc xsl 
	in="&fpath\CLData_SAS.xml"
	out="&fpath\CLData_SAS.xml"
	xsl=xslfile;
run;

put 'Successfully migrated JSON data to XML';
