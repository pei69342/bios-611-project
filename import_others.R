setwd("~/work")

# importing COVID 19 mortality data
mortality_raw <- rio::import(file = "https://happiness-report.s3.amazonaws.com/2021/MortalityDataWHR2021C2.xlsx",
                             which = "Sheet1");

# importing anxiety and depression data
mental_health_raw <- rio::import(file = "source_data/IHME-GBD_2019_DATA.csv",
                                 which = "IHME-GBD_2019_DATA");

# replacing special characters with underscore
char <- "[^a-zA-Z0-9.]";
colnames(mental_health_raw) <- gsub(char,"_",names(mental_health_raw));
colnames(mortality_raw) <- gsub(char,"_",names(mortality_raw));


# saving data sets in local folder
write.csv(mental_health_raw, "retrieved_data/mental_health_raw.csv", row.names=FALSE)
write.csv(mortality_raw, "retrieved_data/mortality_raw.csv", row.names=FALSE)

rm(char)