library(XML)

# LOAD OBJECT
cldata <- readRDS("../BuildBINs/CLData_R.rds")

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
output <- cat(saveXML(doc, encoding="UTF-8"),  file="CLData_R.xml")

cat("Successfully migrated binary data to XML!\n")
