library(XML)
library(jsonlite)

setwd("C:\\Path\\To\\Work\\Directory")

# READ XML
doc <- xmlParse("Cldata.xml")

# CONVERT TO DATA FRAME
df <- xmlToDataFrame(nodes = getNodeSet(doc, "//missedConnection"))

# CONVERT TO JSON
x <- toJSON(df, pretty=TRUE)

# EXPORT TO FILE
fileConn<-file("Cldata_R.json")
writeLines(x, fileConn)
close(fileConn)

print("Successfully migrated xml data to json!")

