library(jsonlite)

# READ JSON
cldata <- fromJSON("CLData.json")

# WRITE CSV
write.csv(cldata, "CLData_R.csv", row.names=FALSE)

cat("Successfully migrated JSON data to CSV!\n")
