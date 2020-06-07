options(width = 200)

# READ CSV DATA
cldata <- read.csv("../../CSV/CSVtoXML/CLData.csv")

# SAVE OBJECT
saveRDS(cldata, "CLData_R.rds")

# LOAD OBJECT
new_cldata <- readRDS("CLData_R.rds")

head(new_cldata)

cat("Successfully created binary data!\n")
