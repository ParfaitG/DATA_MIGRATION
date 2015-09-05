library(RMySQL)

setwd("C:\\Path\\To\\R\\Script")
todayDate = gsub("-", "", Sys.Date())

# OPENING AND QUERYING DATABASE
myconn <- dbConnect(RMySQL::MySQL(), dbname="database", host="hostname",
                    username="username", password="password")
sqlData <- dbGetQuery(myconn, "SELECT * FROM cldata")
dbDisconnect(myconn) 

# WRITE TO CSV
write.csv(sqlData, paste0("CLData_", todayDate, ".csv"), row.names=FALSE)
          
print("Successfully migrated SQL data into SQL!")
