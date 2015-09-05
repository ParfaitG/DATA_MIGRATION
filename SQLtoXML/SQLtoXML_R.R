library(XML)
library(RMySQL)

setwd("C:\\Path\\To\\R\\Script")
todayDate = gsub("-", "", Sys.Date())

# CREATE XML FILE
doc = newXMLDoc()
root = newXMLNode("CLData", doc = doc)

# OPEN DATABASE AND QUERY
myconn <- dbConnect(RMySQL::MySQL(), dbname="database", host="hostname",
                    username="username", password="password")
xmldf <- dbGetQuery(myconn, "SELECT `user`, `category`, `city`,
                                    `post`, `time`, `link` FROM cldata;")
dbDisconnect(myconn) 

# WRITE XML NODES AND DATA
for (i in 1:nrow(xmldf)){
  mcNode = newXMLNode("missedConnection", parent = root)
  userNode = newXMLNode("user", xmldf$user[i], parent = mcNode)
  categoryNode = newXMLNode("user", xmldf$category[i], parent = mcNode)
  cityNode = newXMLNode("city", xmldf$city[i], parent = mcNode)
  postNode = newXMLNode("post", xmldf$post[i], parent = mcNode)
  timeNode = newXMLNode("time", xmldf$time[i], parent = mcNode)
  linkNode = newXMLNode("link", xmldf$link[i], parent = mcNode)
}

# OUTPUT XML CONTENT TO FILE
saveXML(doc, file="CLData_ROutput.xml")

print("Successfully migrated SQL to XML data!")
