library(XML)
library(jsonlite)

setwd('C:\\Path\\To\\Working\\Directory')

# READ JSON INTO DATAFRAME
cldata <- do.call(rbind, 
                  lapply(paste(readLines("Cldata.json", warn=FALSE),
                               collapse=""), 
                  jsonlite::fromJSON))

# CREATE XML FILE
doc = newXMLDoc()
root = newXMLNode("CLData", doc = doc)

# WRITE XML NODES AND DATA
for (i in 1:nrow(cldata)){
    mcNode = newXMLNode("missedConnection", parent = root)
    userNode = newXMLNode("user", cldata$user[i], parent = mcNode)
    categoryNode = newXMLNode("user", cldata$category[i], parent = mcNode)
    cityNode = newXMLNode("city", cldata$city[i], parent = mcNode)
    postNode = newXMLNode("post", cldata$post[i], parent = mcNode)
    timeNode = newXMLNode("time", cldata$time[i], parent = mcNode)
    linkNode = newXMLNode("link", cldata$link[i], parent = mcNode)
}

# OUTPUT XML CONTENT TO FILE
saveXML(doc, file="CLData_R.xml")


print("Successfully migrated json data to xml!")