setwd("~/work")

library(openxlsx)
# specifying the path name and the sheet name
p15 <- "https://s3.amazonaws.com/happiness-report/2015/Chapter2OnlineData_Expanded-with-Trust-and-Governance.xlsx";
s15 <- "Data for Figure2.2";
whr15_raw <- read.xlsx(p15, s15, startRow=4);

library(rio)
p16 <- "https://s3.amazonaws.com/happiness-report/2016/Online-data-for-chapter-2-whr-2016.xlsx";
s16 <- "Figure2.2";
p17 <- "https://s3.amazonaws.com/happiness-report/2017/online-data-chapter-2-whr-2017.xlsx";
s17 <- "Figure2.2 WHR 2017";
p18 <- "https://s3.amazonaws.com/happiness-report/2018/WHR2018Chapter2OnlineData.xls";
s18 <- "Figure2.2";
p19 <- "https://s3.amazonaws.com/happiness-report/2019/Chapter2OnlineData.xls";
s19 <- "Figure2.6";
p20 <- "https://happiness-report.s3.amazonaws.com/2020/WHR20_DataForFigure2.1.xls";
s20 <- "Sheet1";
p21 <- "https://happiness-report.s3.amazonaws.com/2021/DataForFigure2.1WHR2021C2.xls";
s21 <- "Sheet1";
p22 <- "https://happiness-report.s3.amazonaws.com/2022/Appendix_2_Data_for_Figure_2.1.xls";
s22 <- "2022";

# importing WHR data sets from 2016 to 2022
for(x in c(16:22)){
  assign(paste0("whr",x,"_raw"),
         rio::import(file = get(paste0("p",x)),which = get(paste0("s",x))));
}

# importing WHR data from 2008 to 2021
comb0821_raw <- rio::import(file = "https://happiness-report.s3.amazonaws.com/2022/DataForTable2.1.xls",
                            which = "Sheet1");

# replacing special characters with underscore
char <- "[^a-zA-Z0-9.]";
colnames(whr15_raw) <- gsub(char,"_",names(whr15_raw));
colnames(whr16_raw) <- gsub(char,"_",names(whr16_raw));
colnames(whr17_raw) <- gsub(char,"_",names(whr17_raw));
colnames(whr18_raw) <- gsub(char,"_",names(whr18_raw));
colnames(whr19_raw) <- gsub(char,"_",names(whr19_raw));
colnames(whr20_raw) <- gsub(char,"_",names(whr20_raw));
colnames(whr21_raw) <- gsub(char,"_",names(whr21_raw));
colnames(whr22_raw) <- gsub(char,"_",names(whr22_raw));
colnames(comb0821_raw) <- gsub(char,"_",names(comb0821_raw));


# saving data sets in local folder
for(y in c(15:22)){
  write.csv(get(paste0("whr",y,"_raw")),
            paste0("retrieved_data/whr",y,"_raw.csv"), row.names=FALSE)
}
write.csv(comb0821_raw, "retrieved_data/comb0821_raw.csv", row.names=FALSE)

# clear some variables
rm(list=c(paste0("p",c(15:22)), paste0("s",c(15:22)),
          "x","y","char"))