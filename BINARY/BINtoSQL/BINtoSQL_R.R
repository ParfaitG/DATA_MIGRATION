library(RSQLite)

# LOAD OBJECT
cldata <- readRDS("../BuildBINs/CLData_R.rds")

# APPEND TO DATABASE
conn <- dbConnect(RSQLite::SQLite(), "CLData.db")
dbWriteTable(conn, name="cldata", value=cldata,  row.names=FALSE,
             overwrite=TRUE, append=FALSE)
dbDisconnect(conn) 

cat("Successfully migrated binary data to SQL database!\n")
