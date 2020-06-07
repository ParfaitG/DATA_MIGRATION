library(jsonlite)

# LOAD OBJECT
cldata <- readRDS("../BuildBINs/CLData_R.rds")

# WRITE CSV
write.csv(cldata, "CLData_R.csv", row.names=FALSE)

cat("Successfully migrated binary data to CSV!!\n")
