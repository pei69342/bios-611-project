setwd("~/work")
library(tidyverse)

# read in csv files from derived data folder
all_csv_files <- list.files(path="derived_data",pattern="*.csv");
keep_files <- all_csv_files[str_detect(all_csv_files,"_2")];
keep_files <- keep_files[str_detect(keep_files,"whr")];
for(x in c(1:length(keep_files))){
  assign(substring(keep_files[x],1,nchar(keep_files[x])-4),
         read.csv(file=paste0("derived_data/",keep_files[x])))
}

# pre-COVID average happiness scores (2015-2019)
colnames(whr15_2)[!str_detect(colnames(whr15_2),"country")] <- paste0(names(whr15_2)[!str_detect(colnames(whr15_2),"country")],"15");
colnames(whr16_2)[!str_detect(colnames(whr16_2),"country")] <- paste0(names(whr16_2)[!str_detect(colnames(whr16_2),"country")],"16");
colnames(whr17_2)[!str_detect(colnames(whr17_2),"country")] <- paste0(names(whr17_2)[!str_detect(colnames(whr17_2),"country")],"17");
colnames(whr18_2)[!str_detect(colnames(whr18_2),"country")] <- paste0(names(whr18_2)[!str_detect(colnames(whr18_2),"country")],"18");
colnames(whr19_2)[!str_detect(colnames(whr19_2),"country")] <- paste0(names(whr19_2)[!str_detect(colnames(whr19_2),"country")],"19");
colnames(whr20_2)[!str_detect(colnames(whr20_2),"country")] <- paste0(names(whr20_2)[!str_detect(colnames(whr20_2),"country")],"20");
colnames(whr21_2)[!str_detect(colnames(whr21_2),"country")] <- paste0(names(whr21_2)[!str_detect(colnames(whr21_2),"country")],"21");
colnames(whr22_2)[!str_detect(colnames(whr22_2),"country")] <- paste0(names(whr22_2)[!str_detect(colnames(whr22_2),"country")],"22");

whr1519_avg <- whr15_2 %>% left_join(whr16_2, by = "country") %>%
  left_join(whr17_2, by = "country") %>%
  left_join(whr18_2, by = "country") %>%
  left_join(whr19_2, by = "country") %>%
  mutate(happiness_avg1 = select(., happiness15, happiness16, happiness17,
                                 happiness18, happiness19) %>%
           rowMeans(na.rm = TRUE),
         gdp_avg1 = select(., gdp15, gdp16, gdp17,
                           gdp18, gdp19) %>%
           rowMeans(na.rm = TRUE),
         soc_supp_avg1 = select(., soc_supp15, soc_supp16, soc_supp17,
                                soc_supp18, soc_supp19) %>%
           rowMeans(na.rm = TRUE),
         hlife_avg1 = select(., hlife15, hlife16, hlife17,
                             hlife18, hlife19) %>%
           rowMeans(na.rm = TRUE),
         freedom_avg1 = select(., freedom15, freedom16, freedom17,
                               freedom18, freedom19) %>%
           rowMeans(na.rm = TRUE),
         generosity_avg1 = select(., generosity15, generosity16, generosity17,
                                  generosity18, generosity19) %>%
           rowMeans(na.rm = TRUE),
         corruption_avg1 = select(., corruption15, corruption16, corruption17,
                                  corruption18, corruption19) %>%
           rowMeans(na.rm = TRUE),
         dystopia_plus_residual_avg1 = select(., dystopia_plus_residual15,
                                              dystopia_plus_residual16,
                                              dystopia_plus_residual17,
                                              dystopia_plus_residual18,
                                              dystopia_plus_residual19) %>%
           rowMeans(na.rm = TRUE),
         dystopia_score_avg1 = select(., dystopia_score15, dystopia_score16,
                                      dystopia_score17, dystopia_score18,
                                      dystopia_score19) %>%
           rowMeans(na.rm = TRUE),
         residual_avg1 = select(., residual15, residual16, residual17,
                                residual18, residual19) %>%
           rowMeans(na.rm = TRUE)) %>%
  select(region15, country, happiness_avg1, gdp_avg1, soc_supp_avg1,
         hlife_avg1, freedom_avg1, generosity_avg1, corruption_avg1,
         dystopia_plus_residual_avg1, dystopia_score_avg1) %>%
  mutate(residual_avg1 = (dystopia_plus_residual_avg1-dystopia_score_avg1),
         score_avg1 = select(., gdp_avg1:dystopia_plus_residual_avg1) %>%
           rowSums(na.rm = TRUE),
         pred_score_avg1 = (score_avg1 - residual_avg1));


# during-COVID / post-COVID average happiness scores (2020-2022)
whr2022_avg <- whr20_2 %>% left_join(whr21_2, by = "country") %>%
  left_join(whr22_2, by = "country") %>%
  mutate(happiness_avg2 = select(., happiness20, happiness21, happiness22) %>%
           rowMeans(na.rm = TRUE),
         gdp_avg2 = select(., gdp20, gdp21, gdp22) %>%
           rowMeans(na.rm = TRUE),
         soc_supp_avg2 = select(., soc_supp20, soc_supp21, soc_supp22) %>%
           rowMeans(na.rm = TRUE),
         hlife_avg2 = select(., hlife20, hlife21, hlife22) %>%
           rowMeans(na.rm = TRUE),
         freedom_avg2 = select(., freedom20, freedom21, freedom22) %>%
           rowMeans(na.rm = TRUE),
         generosity_avg2 = select(., generosity20, generosity21, generosity22) %>%
           rowMeans(na.rm = TRUE),
         corruption_avg2 = select(., corruption20, corruption21, corruption22) %>%
           rowMeans(na.rm = TRUE),
         dystopia_plus_residual_avg2 = select(., dystopia_plus_residual20,
                                              dystopia_plus_residual21,
                                              dystopia_plus_residual22) %>%
           rowMeans(na.rm = TRUE),
         dystopia_score_avg2 = select(., dystopia_score20, dystopia_score21,
                                      dystopia_score22) %>%
           rowMeans(na.rm = TRUE),
         residual_avg2 = select(., residual20, residual21, residual22) %>%
           rowMeans(na.rm = TRUE)) %>%
  select(region20, country, happiness_avg2, gdp_avg2, soc_supp_avg2,
         hlife_avg2, freedom_avg2, generosity_avg2, corruption_avg2,
         dystopia_plus_residual_avg2, dystopia_score_avg2) %>%
  mutate(residual_avg2 = (dystopia_plus_residual_avg2-dystopia_score_avg2),
         score_avg2 = select(., gdp_avg2:dystopia_plus_residual_avg2) %>%
           rowSums(na.rm = TRUE),
         pred_score_avg2 = (score_avg2 - residual_avg2));

# merge whr1519_avg and whr2022_avg
whr_change <- whr1519_avg %>% left_join(whr2022_avg, by = "country") %>%
  mutate(change = (happiness_avg2 - happiness_avg1),
         gdp_change = (gdp_avg2 - gdp_avg1),
         soc_supp_change = (soc_supp_avg2 - soc_supp_avg1),
         hlife_change = (hlife_avg2 - hlife_avg1),
         freedom_change = (freedom_avg2 - freedom_avg1),
         generosity_change = (generosity_avg2 - generosity_avg1),
         corruption_change = (corruption_avg2 - corruption_avg1),
         dystopia_plus_residual_change = (dystopia_plus_residual_avg2 - dystopia_plus_residual_avg1),
         dystopia_score_change = (dystopia_score_avg2 - dystopia_score_avg1)) %>%
  arrange(desc(happiness_avg2));


# saving data set in local folder
write.csv(whr_change, "derived_data/whr_change.csv", row.names=FALSE)

# remove some variables
rm(list=c("all_csv_files","keep_files","x"))