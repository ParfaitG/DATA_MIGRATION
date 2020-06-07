library(XML)
library(jsonlite)

# READ XML
doc <- xmlParse("CLData.xml")

# CONVERT TO DATA FRAME
df <- xmlToDataFrame(nodes = getNodeSet(doc, "//missedConnection"))

# CONVERT TO JSON
x <- toJSON(df, pretty=TRUE)

# EXPORT TO FILE
fileConn<-file("CLDdata_R.json")
writeLines(x, fileConn)
close(fileConn)

cat("Successfully migrated XML data to JSON!\n")

