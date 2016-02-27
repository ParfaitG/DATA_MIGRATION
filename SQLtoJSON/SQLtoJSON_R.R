library(RMySQL)
library(jsonlite)

setwd('C:\\Path\\To\\Working\\Directory')

# IMPORT SQL DATA
con <-  dbConnect(RMySQL::MySQL(),                  
                  host = "localhost", port = 3306, dbname = "****",
                  username = "****", password = "****")
cldata <- dbGetQuery(con, "SELECT user, category, city, time, post, link FROM cldata;") 
dbDisconnect(con)

# CONVERT TO JSON
x <- toJSON(cldata, pretty=TRUE)

# EXPORT TO FILE
fileConn<-file("Cldata_R.json")
writeLines(x, fileConn)
close(fileConn)

print("Successfully migrated sql data to json!")

