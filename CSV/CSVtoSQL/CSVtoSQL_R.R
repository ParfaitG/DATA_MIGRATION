library(RSQLite)

# READ IN CSV
setwd("/path/to/working/directory")
csvdf <- read.csv("Cldata.csv")

# APPEND TO DATABASE
dbconn <- dbConnect(RSQLite::SQLite(), "CLData.db")
dbWriteTable(dbconn, name="cldata", value=csvdf, 
             row.names=FALSE, overwrite=TRUE, append=FALSE)
dbDisconnect(dbconn) 

cat("Successfully migrated CSV data into SQL database!\n")
