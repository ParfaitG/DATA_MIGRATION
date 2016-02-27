library(jsonlite)

# READ IN CSV DATA
setwd("D:\\Freelance Work\\Sandbox\\CSVtoJSON\\")
df <- read.csv("Cldata.csv")

# CONVERT TO JSON STRING
x <- toJSON(df, pretty=TRUE)

# EXPORT TO JSON FILE
fileConn<-file("Cldata_R.json")
writeLines(x, fileConn)
close(fileConn)


