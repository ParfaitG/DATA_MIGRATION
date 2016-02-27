library(RMySQL)
library(jsonlite)

setwd('C:\\Path\\To\\Working\\Directory')

# IMPORT JSON
cldata <- do.call(rbind, 
                  lapply(paste(readLines("Cldata.json", warn=FALSE),
                               collapse=""), 
                  jsonlite::fromJSON))

# APPEND TO DATABASE
myconn <- dbConnect(RMySQL::MySQL(), host="localhost", dbname="****",
                    username="****", password="****")
dbWriteTable(myconn, name="cldata", value=cldata,
             append=TRUE, row.names=FALSE)
dbDisconnect(myconn) 

print("Successfully migrated json data to sql!")