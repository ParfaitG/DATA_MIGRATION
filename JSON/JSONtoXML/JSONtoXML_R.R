library(XML)
library(jsonlite)

# READ JSON
cldata <- fromJSON("CLData.json")

# CREATE XML FILE
doc = newXMLDoc()
root = newXMLNode("CLData", doc = doc)

# WRITE XML NODES AND DATA
mcNodes <- lapply(1:nrow(cldata), function(i) {
   k <- Map(function(h,d) newXMLNode(h,d), colnames(cldata), cldata[i,])

   mcNode = newXMLNode("missedConnection")
   addChildren(mcNode, kids=k)

   return(mcNode)
})

output <- addChildren(root, kids=mcNodes)

# OUTPUT XML
output <- saveXML(doc, file="CLData_R.xml")

cat("Successfully migrated JSON data to XML!\n")
