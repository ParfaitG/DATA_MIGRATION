library(XML)
library(RSQLite)

# IMPORT XML
doc <- xmlParse("CLData.xml")
xmldf <- xmlToDataFrame(nodes = getNodeSet(doc, "//missedConnection"))

# APPEND TO DATABASE
conn <- dbConnect(RSQLite::SQLite(), "CLData.db")
dbWriteTable(conn, name="cldata", value=xmldf,  row.names=FALSE,
             overwrite=TRUE, append=FALSE)
dbDisconnect(conn) 

cat("Successfully migrated XML data into SQL database!\n")
