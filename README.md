# DATA_MIGRATION
XML, CSV, JSON, and SQL data migration/conversion scripts in Java, PHP, Python, R, SAS, and VBA (MS Access and MS Excel).

Using *Craigslist Missed Connections NYC/CHI/LA* posts as example data, scripts include six data migration processes in attached folders.
Each folder contains examples in above 5 programming language/software types.

**REQUIREMENT**: For any MySQL or other database imports and/or exports, a CLData table is required (see attached create table .sql script).
Additionally, some scripts require various libraries/modules:

* CSV scripts: Python csv module;
* JSON scripts: Java - json simple 1.1.1. and gson 2.2.2 jar files; Python - json; R - jsonlite, SAS - proc json, MS Access/Excel - VBA-JSON w/ MS Script Runtime library reference;
* XML scripts: Python - lxml, R - XML, SAS - proc xsl;
* SQL scripts: Java - jdbc mysql; PHP - PDO extension; Python - pymysql; R - RMySQL; SAS - ODBC; MS Access/Excel - MySQL ODBC driver;

---
1. #####[CSV to SQL](/CSVtoXML)
   Each script imports CSV data into connected CLData database table. Attached CSV file is included.

2. #####[CSV to JSON](/CSVtoJSON) 
   Each script outputs JSON file with pretty printing. Attached JSON file is included.

3. #####[CSV to XML](/CSVtoXML)
   Each script outputs XML file. For document formatting, MS Access, Excel and SAS runs embedded XSLT stylesheets. Attached XML file is included.

4. #####[JSON to CSV](/JSONtoCSV)
   Each script parses JSON data and outputs to CSV format. Attached JSON file is included.

5. #####[JSON to SQL](/JSONtoSQL)
   Each script parses JSON data imports into connected CLData database table. Attached JSON file is included.

6. #####[JSON to XML](/JSONtoXML) 
   Each script parses JSON file and outputs to XML format. For document formatting, MS Access, Excel and SAS runs embedded XSLT stylesheets. Attached JSON file is included.

7. #####[SQL to CSV](/SQLtoCSV)
   Each script imports CSV data into connected CLData database table.  Attached SQL create table code is included.

8. #####[SQL to JSON](/SQLtoJSON) 
   Each script connects to database and queries CLData table for JSON output with pretty printing. Attached SQL create table code is included.

9. #####[SQL to XML](/SQLtoXML)
   Each script connects to database and queries CLData table for XML output. For document formatting, MS Access, Excel and SAS runs embedded XSLT stylesheets. Attached SQL create table code is included.

10. #####[XML to CSV](/XMLtoCSV)
   Each script parses XML file and outputs to CSV format.  Attached XML file is included.

11. #####[XML to JSON](/XMLtoJSON)
   Each script parses XML file and outputs to JSON with pretty printing. Attached XML file is included.

12. #####[XML to SQL](/XMLtoSQL)
   Each script parses XML data and imports into connected CLData database table. Attached XML file is included.
