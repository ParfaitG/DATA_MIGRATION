library(XML)

setwd("C:\\Path\\To\\R\\Script")
todayDate = gsub("-", "", Sys.Date())

# LOADING TRANSFORMED XML INTO R DATA FRAME
doc<-xmlParse("CLData.xml")
xmldf <- xmlToDataFrame(nodes = getNodeSet(doc, "//missedConnection"))
View(xmldf)

write.csv(xmldf, paste0("CLData_", todayDate, ".csv"), na = "", row.names=FALSE)

print("Successfully converted XML data into CSV!")
