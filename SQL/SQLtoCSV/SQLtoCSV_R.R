library(RSQLite)

# OPEN DATABASE AND QUERY
conn <- dbConnect(RSQLite::SQLite(), dbname="CLData.db")
sqlData <- dbGetQuery(conn, "SELECT * FROM cldata")
dbDisconnect(conn) 

# WRITE TO CSV
write.csv(sqlData, paste0("CLData_R.csv"), row.names=FALSE)
          
cat("Successfully migrated SQL data to CSV!\n")
