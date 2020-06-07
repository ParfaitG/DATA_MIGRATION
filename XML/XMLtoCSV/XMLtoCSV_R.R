library(XML)

# IMPORT XML
doc <- xmlParse("CLData.xml")
xmldf <- xmlToDataFrame(nodes = getNodeSet(doc, "//missedConnection"))

# WRITE TO CSV
write.csv(xmldf, "CLData_R.csv", row.names = FALSE)

cat("Successfully migrated XML data to CSV!\n")
