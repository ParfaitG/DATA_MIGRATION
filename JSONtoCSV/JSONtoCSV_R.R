library(jsonlite)

setwd("C:\\Path\\Working\\Directory")
cldata <- do.call(rbind, 
                  lapply(paste(readLines("Cldata.json", warn=FALSE),
                               collapse=""), 
                  jsonlite::fromJSON))

write.csv(cldata, "Cldata_R.csv", row.names=FALSE)

print("Successfully migrated json data to csv!")