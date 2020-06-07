library(jsonlite)

# READ IN CSV
df <- read.csv("CLData.csv")

# CONVERT TO JSON STRING
jdata <- toJSON(df, pretty=TRUE)

# WRITE TO JSON
fileConn <- file("CLData_R.json")
writeLines(jdata, fileConn)
close(fileConn)

cat("Successfully migrated CSV data to JSON!!\n")
