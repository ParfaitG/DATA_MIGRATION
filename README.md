# DATA_MIGRATION
Binary, CSV, JSON, SQL, and XML data migration scripts in Java, PHP, Python, R, SAS, and VBA (MS Access and MS Excel).

Using **Craigslist Missed Connections NYC/CHI/LA August 2015** posts as example data, scripts include 12 data migration processes in attached folders. Each folder contains examples in above programming language/software types. 

---

1. **[BINARY](/BINARY)**
    - [BIN to SQL](/BINARY/BINtoSQL)
      Each script migrates binary data to CSV format. See [BuildBINs](/BuildBINs) for data source.
    - [BIN to JSON](/BINARY/BINtoJSON) 
      Each script migrates binary data to JSON format. See [BuildBINs](/BuildBINs) for data source.
    - [BIN to SQL](/BINARY/BINtoSQL)
      Each script migrates binary data to SQL database table. See [BuildBINs](/BuildBINs) for data source.
    - [BIN to XML](/BINARY/BINtoXML)
      Each script migrates binary data to XML format. See [BuildBINs](/BuildBINs) for data source.

2. **[CSV](/CSV)**
    - [CSV to JSON](/CSV/CSVtoJSON) 
      Each script migrates CSV data into JSON format. Attached CSV file is included.
    - [CSV to SQL](/CSV/CSVtoSQL)
      Each script migrates CSV data into SQL database table. Attached CSV file is included.
    - [CSV to XML](/CSV/CSVtoXML)
      Each script migrates CSV data into XML format. Attached CSV file is included.

3. **[JSON](/JSON)**
    - [JSON to CSV](/JSON/JSONtoCSV)
      Each script migrates JSON data into CSV format. Attached JSON file is included.
    - [JSON to SQL](/JSON/JSONtoSQL)
      Each script migrates JSON data into SQL database table. Attached JSON file is included.
    - [JSON to XML](/JSON/JSONtoXML) 
      Each script migrates JSON file into XML format. Attached JSON file is included.

4. **[SQL](/SQL)**
    - [SQL to CSV](/SQL/SQLtoCSV)
      Each script migrates SQL database table into CSV format. Attached SQLite table schema and database included.
    - [SQL to JSON](/SQL/SQLtoJSON) 
      Each script migrates SQL database table into JSON format. Attached SQLite table schema and database included.
    - [SQL to XML](/SQL/SQLtoXML)
      Each script migrates SQL database table into XML format. Attached SQLite table schema and database included.

5. **[XML](/XML)**
    - [XML to CSV](/XML/XMLtoCSV)
      Each script migrates XML data into CSV format. Attached XML file is included.
    - [XML to JSON](/XML/XMLtoJSON)
      Each script migrates XML data into JSON format. Attached XML file is included.
    - [XML to SQL](/XML/XMLtoSQL)
      Each script migrates XML data into SQL database tables. Attached XML file is included.

---

**REQUIREMENT**: Sscripts require various non-standard modules:

* JSON scripts: Java - gson 2.2.2 jar file; R - jsonlite, VBA - [VBA-JSON](https://github.com/VBA-tools/VBA-JSON) w/ MS Script Runtime library reference;
* XML scripts: Python - lxml, R - XML, SAS - proc xsl;
* SQL scripts: Java - SQLite jdbc jar file; PHP - PDO extension; R - RSQLite; SAS - ODBC; VBA - SQLite ODBC driver;
