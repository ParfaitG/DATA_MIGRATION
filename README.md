# DATA_MIGRATION
XML, CSV, SQL data migration/conversion scripts in PHP, Python, R, SAS, MS Access, and MS Excel.

Using *Craigslist Missed Connections NYC/CHI/LA* posts as example data, scripts include six data migration processes in attached folders.
Each folder contains examples in above 5 programming language/software types.

**REQUIREMENT**: For any MySQL or other database imports and/or exports, a CLData table is required (see attached create table .sql script).
Additionally, some scripts require various libraries/modules (i.e., PDO in PHP; pymysql in Python; RMySQL in R; and ODBC drivers for 
Access/Excel/SAS).

1. #####CSV to SQL 
   Each script in various forms uploads CSV data to connected CLData database table. Attached CSV is included.

2. #####CSV to XML 
   Each script outputs XML file. For document formatting, MS Access, Excel and SAS runs embedded XSLT stylesheets. Attached CSV is included.

3. #####SQL to CSV
   Each script connects to database and queries CLData table for CSV output.

4. #####SQL to XML
   Each script connects to database and queries CLData table for XML output. For document formatting, MS Access, Excel and SAS runs embedded XSLT stylesheets.

5. #####XML to CSV
   Each script converts XML data to CSV format.  Attached XML is included.

6. #####XML to SQL
   Each script in various forms uploads XML data to connected CLData database table. Attached XML is included.
