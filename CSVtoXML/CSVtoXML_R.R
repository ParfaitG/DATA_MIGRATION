library(XML)

setwd("C:\\Path\\To\\R\\Script")

# CREATE XML FILE
doc = newXMLDoc()
root = newXMLNode("CLData", doc = doc)

# READ IN CSV
csvdf <- read.csv("CLData.csv")

# WRITE XML NODES AND DATA
for (i in 1:nrow(csvdf)){
  mcNode = newXMLNode("missedConnection", parent = root)
  userNode = newXMLNode("user", csvdf$user[i], parent = mcNode)
  categoryNode = newXMLNode("user", csvdf$category[i], parent = mcNode)
  cityNode = newXMLNode("city", csvdf$city[i], parent = mcNode)
  postNode = newXMLNode("post", csvdf$post[i], parent = mcNode)
  timeNode = newXMLNode("time", csvdf$time[i], parent = mcNode)
  linkNode = newXMLNode("link", csvdf$link[i], parent = mcNode)
}

# OUTPUT XML CONTENT TO FILE
saveXML(doc, file="CLData_ROutput.xml")

print("Successfully migrated SQL to XML data!")
