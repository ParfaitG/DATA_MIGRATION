library(XML)

# READ CSV
raw <- readLines("CLData.csv")
headers <- scan(text=raw[1], what='character', sep = ",", quote = '"', quiet=TRUE)

# CREATE XML
doc = newXMLDoc()
root = newXMLNode("CLData", doc=doc)

# BUILD XML NODES
mcNodes <- lapply(raw[-1], function(line) {
   data <- scan(text=line, what='character', sep = ",", quote = '"', quiet=TRUE)                
   k <- Map(function(h,d) newXMLNode(h,d), headers, data)

   mcNode = newXMLNode("missedConnection")
   addChildren(mcNode, kids=k)

   return(mcNode)
})

output <- addChildren(root, kids=mcNodes)

# SAVE XML
output <- saveXML(doc, file="CLData_R.xml")

cat("Successfully migrated CSV data to XML!\n")

