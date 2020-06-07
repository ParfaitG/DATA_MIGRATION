library(RSQLite)
library(jsonlite)

# IMPORT JSON
cldata <- jsonlite::fromJSON("CLData.json")

# APPEND TO DATABASE
dbconn <- dbConnect(RSQLite::SQLite(), dbname="CLData.db")

dbWriteTable(dbconn, name="cldata", value=cldata, row.names=FALSE,
             append=FALSE, overwrite=TRUE)
dbDisconnect(dbconn) 

cat("Successfully migrated JSON data to SQL database!\n")
