library(XML)
library(RMySQL)

setwd("C:\\Path\\To\\R\\Script")
todayDate = gsub("-", "", Sys.Date())

# LOADING TRANSFORMED XML INTO R DATA FRAME
doc<-xmlParse("CLData.xml")
xmldf <- xmlToDataFrame(nodes = getNodeSet(doc, "//missedConnection"))
View(xmldf)
rownames(xmldf) <- NULL

# APPEND TO DATABASE
myconn <- dbConnect(RMySQL::MySQL(), dbname="database", host="hostname",
                    username="username", password="password")
dbWriteTable(myconn, name="cldata", value=xmldf, 
             append=TRUE, row.names=FALSE)
dbDisconnect(myconn) 

print("Successfully migrated XML data into SQL!")
