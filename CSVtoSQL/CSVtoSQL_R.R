library(RMySQL)

setwd("C:\\Path\\To\\R\\Script")

# READ IN CSV
csvdf <- read.csv("CLData.csv")

# APPEND TO DATABASE
myconn <- dbConnect(RMySQL::MySQL(), dbname="database", host="hostname",
                    username="username", password="password")
dbWriteTable(myconn, name="cldata", value=csvdf, 
             append=TRUE, row.names=FALSE)
dbDisconnect(myconn) 

print("Successfully migrated CSV data into SQL!")
