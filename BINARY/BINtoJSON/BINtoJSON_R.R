library(jsonlite)

# LOAD OBJECT
cldata <- readRDS("../BuildBINs/CLData_R.rds")

# CONVERT TO JSON STRING
jdata <- toJSON(cldata, pretty=TRUE)

# WRITE TO JSON
fileConn <- file("CLData_R.json")
writeLines(jdata, fileConn)
close(fileConn)

cat("Successfully converted binary data to JSON!\n")
