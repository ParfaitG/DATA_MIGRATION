library(XML)
library(RSQLite)

# INITIALIZE XML FILE
doc = newXMLDoc()
root = newXMLNode("CLData", doc = doc)

# OPEN DATABASE AND QUERY
conn <- dbConnect(RSQLite::SQLite(), dbname="CLData.db")
cldata <- dbGetQuery(conn, "SELECT * FROM cldata")
dbDisconnect(conn) 

# WRITE XML NODES AND DATA
mcNodes <- lapply(1:nrow(cldata), function(i) {
   k <- Map(function(h,d) newXMLNode(h,d), colnames(cldata), cldata[i,])

   mcNode = newXMLNode("missedConnection")
   addChildren(mcNode, kids=k)

   return(mcNode)
})

output <- addChildren(root, kids=mcNodes)

# OUTPUT XML
ouput <- saveXML(doc, file="CLData_R.xml")

cat("Successfully migrated SQL data to XML!\n")
