library(RSQLite)
library(jsonlite)

# IMPORT SQL DATA
conn <-  dbConnect(RSQLite::SQLite(), dbname = "CLData.db")
cldata <- dbGetQuery(conn, "SELECT * FROM cldata") 
dbDisconnect(conn)

# CONVERT TO JSON
jdata <- toJSON(cldata, pretty=TRUE)

# EXPORT JSON
fileConn <- file("CLData_R.json")
writeLines(jdata, fileConn)
close(fileConn)

cat("Successfully migrated SQL data to JSON!\n")
