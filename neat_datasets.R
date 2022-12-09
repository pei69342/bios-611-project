# read in all csv files from retrieved data folder
all_csv_files = list.files(path="retrieved_data",pattern="*.csv")
for(x in c(1:length(all_csv_files))){
  assign(substring(all_csv_files[x],1,nchar(all_csv_files[x])-4),
         read.csv(file=paste0("retrieved_data/",all_csv_files[x])))
}

library(tidyverse)

varlist <- c("country", "happiness", "gdp", "soc_supp", "hlife", "freedom",
             "generosity", "corruption", "dystopia_plus_residual");

# Standardizing some country names for easier merging afterwards
std_cname <- function(ds){
  ds$country[str_detect(ds$country, "Bolivia")] <- "Bolivia";
  ds$country[str_detect(ds$country, "Côte d'Ivoire")] <- "Ivory Coast";
  ds$country[str_detect(ds$country, "Czechia")] <- "Czech Republic";
  ds$country[str_detect(ds$country, "Eswatini")] <- "Eswatini";
  ds$country[str_detect(ds$country, "Democratic Republic of the Congo")] <- "Congo (Kinshasa)";
  ds$country[str_detect(ds$country, "Hong Kong")] <- "Hong Kong";
  ds$country[str_detect(ds$country, "Iran")] <- "Iran";
  ds$country[str_detect(ds$country, "Lao People's Democratic Republic")] <- "Laos";
  ds$country[str_detect(ds$country, "Palestinian")] <- "Palestine";
  ds$country[ds$country == "Republic of Korea"] <- "South Korea";
  ds$country[ds$country == "Democratic People's Republic of Korea"] <- "North Korea";
  ds$country[str_detect(ds$country, "Russian")] <- "Russia";
  ds$country[str_detect(ds$country, "Syrian")] <- "Syria";
  ds$country[str_detect(ds$country, "Taiwan")] <- "Taiwan";
  ds$country[str_detect(ds$country, "Tanzania")] <- "Tanzania";
  ds$country[str_detect(ds$country, "Trinidad")] <- "Trinidad and Tobago";
  ds$country[str_detect(ds$country, "United States of America")] <- "United States";
  ds$country[str_detect(ds$country, "Venezuela")] <- "Venezuela";
  ds$country[str_detect(ds$country, "Viet Nam")] <- "Vietnam";
  ds
}

# Get dystopia score from variable name
dys_score <- function(ds){
  var <- names(ds)[str_detect(tolower(names(ds)),"dystopia")]
  if(any(str_detect(var,"[0-9]"))){
    parse_number(var)
  } else {
    NA
  }
}

tidyup <- function(oldds,keepvars,newvarnames){
  # Selecting variables that are needed
  ds1 <- oldds[keepvars];
  
  # Standardizing the variable names
  colnames(ds1) <- newvarnames;
  
  # Removing extra '*' after some country names
  cntry1 <- ds1$country[substring(ds1$country,
                                  nchar(ds1$country)) == "*"];
  ds1$country[substring(ds1$country,
                        nchar(ds1$country)) == "*"] <- 
    substring(cntry1, 1, nchar(cntry1)-1);
  
  # Standardizing some country names for easier merging afterwards
  ds1 <- std_cname(ds1)
  
  ds1 <- ds1 %>% filter(country != "NA" & country != "xx")
  
  # Adding a column of dystopia scores
  if(!is.na(dys_score(oldds))){
    ds1 <- ds1 %>% filter(country != "NA" & country != "xx")  %>%
      mutate(dystopia_score=dys_score(oldds))
  }
  
  # Calculating the residuals and predicted happiness scores
  if(any(str_detect(names(ds1),"dystopia"))){
    ds1 <- ds1 %>%
      mutate(residual=(dystopia_plus_residual-dystopia_score),
             score=select(., gdp:dystopia_plus_residual) %>%
               rowSums(na.rm = TRUE),
             pred_score=(score-residual),
             rank=row_number()) %>%
      select(rank, everything());    
  }
  
  # return the cleaned data set
  ds1
}

# WHR 2015 data
whr15_1 <- tidyup(oldds = whr15_raw,
                  keepvars = c(names(whr15_raw)[3], names(whr15_raw)[5],
                               names(whr15_raw)[2], names(whr15_raw)[4],
                               names(whr15_raw)[14:19], names(whr15_raw)[13],
                               names(whr15_raw)[12]),
                  newvarnames = c("region","stderr_happiness",
                                  varlist,"dystopia_score"));

# WHR 2016 data
whr16_1 <- tidyup(oldds = whr16_raw,
                  keepvars = names(whr16_raw)[-3][-3][1:9],
                  newvarnames =  varlist);

# WHR 2017 data
whr17_1 <- tidyup(oldds = whr17_raw,
                  keepvars = names(whr17_raw)[-3][-3][1:9],
                  newvarnames =  varlist);

# WHR 2018 data
whr18_1 <- tidyup(oldds = whr18_raw,
                  keepvars = c(names(whr18_raw)[1:2], names(whr18_raw)[6:11],
                               names(whr18_raw)[5]),
                  newvarnames =  varlist);

# WHR 2019 data
whr19_1 <- tidyup(oldds = whr19_raw,
                  keepvars = c(names(whr19_raw)[1:2], names(whr19_raw)[6:11],
                               names(whr19_raw)[5]),
                  newvarnames =  varlist);

# WHR 2020 data
whr20_1 <- tidyup(oldds = whr20_raw,
                  keepvars = c(names(whr20_raw)[2], names(whr20_raw)[4],
                               names(whr20_raw)[1], names(whr20_raw)[3],
                               names(whr20_raw)[14:20],
                               names(whr20_raw)[13]),
                  newvarnames = c("region","stderr_happiness",
                                  varlist,"dystopia_score"));

# WHR 2021 data
whr21_1 <- tidyup(oldds = whr21_raw,
                  keepvars = c(names(whr21_raw)[2], names(whr21_raw)[4],
                               names(whr21_raw)[1], names(whr21_raw)[3],
                               names(whr21_raw)[14:20],
                               names(whr21_raw)[13]),
                  newvarnames = c("region","stderr_happiness",
                                  varlist,"dystopia_score"));

# WHR 2022 data
whr22_1 <- tidyup(oldds = whr22_raw,
                  keepvars = c(names(whr22_raw)[2:3], names(whr22_raw)[7:12],
                               names(whr22_raw)[6]),
                  newvarnames = varlist);


# WHR 2008 to 2021 combined data
comb0821_1 <- tidyup(oldds = comb0821_raw,
                     keepvars = c("year",names(comb0821_raw)[1],
                                  names(comb0821_raw)[3:12]),
                     newvarnames = c("year",varlist[-9],"positive_affect",
                                     "negative_affect","conf_in_gov"));
comb0821_1 <- std_cname(comb0821_1);


# Mortality data set - keeping variables that are needed
mortality_1 <- mortality_raw[c(names(mortality_raw)[1:4],
                               names(mortality_raw)[13:17])];
colnames(mortality_1) <- c("country", "pop2020", "pop2019",
                           "COVID_deaths_per100000_in2020",
                           "allcause_deaths_17",
                           "allcause_deaths_18",
                           "allcause_deaths_19",
                           "allcause_deaths_20",
                           "excess_deaths_20_relative_to_17to19")
mortality_1 <- std_cname(mortality_1);


# Subset mental health data to two data sets: anxiety and depression
# Selecting variables that are needed
anxiety_1 <- mental_health_raw[c(names(mental_health_raw)[2],
                                 names(mental_health_raw)[4],
                                 names(mental_health_raw)[10],
                                 names(mental_health_raw)[12:14])] %>%
  filter(cause_name == "Anxiety disorders") %>%
  pivot_wider(names_from = metric_name, values_from = val);

depression_1 <- mental_health_raw[c(names(mental_health_raw)[2],
                                    names(mental_health_raw)[4],
                                    names(mental_health_raw)[10],
                                    names(mental_health_raw)[12:14])] %>%
  filter(cause_name == "Depressive disorders") %>%
  pivot_wider(names_from = metric_name, values_from = val);

# Standardizing the variable names
colnames(anxiety_1) <- c("measure", "country", "name",
                         "year", "percent","rate");
colnames(depression_1) <- c("measure", "country", "name",
                            "year", "percent","rate");
anxiety_1 <- std_cname(anxiety_1);
depression_1 <- std_cname(depression_1);



# Keeping only the countries in all data sets from 2015 to 2022
allcountries <- function(ds,x,y){
  tmp <- ds["country"] %>% arrange(country) %>% mutate(year = 1);
  colnames(tmp) <- c("country",paste0("year",2000+x));
    assign(paste0("country",y), tmp %>% unique(), pos = 1);
}
for(i in c(15:22)){
  allcountries(get(paste0("whr",i,"_1")),i,i);
}
allcountries(comb0821_1,-2000,0)
allcountries(mortality_1,-1999,1)
allcountries(anxiety_1,-1998,2)
allcountries(depression_1,-1997,3)

comb_countries <-  country15 %>% full_join(country16, by="country") %>%
  full_join(country17, by="country") %>%
  full_join(country18, by="country") %>%
  full_join(country19, by="country") %>%
  full_join(country20, by="country") %>%
  full_join(country21, by="country") %>%
  full_join(country22, by="country") %>%
  full_join(country0, by="country") %>%
  full_join(country1, by="country") %>%
  full_join(country2, by="country") %>%
  full_join(country3, by="country") %>% arrange(country) %>%
  mutate(total=select(., year2015:year2022) %>%
           rowSums(na.rm = TRUE),
         total2=select(., year2015:year3) %>%
           rowSums(na.rm = TRUE)) 

countries_nomiss <- comb_countries %>% filter(total == 8 | total2 == 12)
countries_miss <- comb_countries %>% filter(total != 8 & total2 != 12)


# Subset data by keeping the countries that have data from 2015 to 2022
nomiss <- function(ds){
  assign(paste0(ds,"_2"), get(paste0(ds,"_1")) %>%
           filter(country %in% countries_nomiss$country), pos = 1)
}
for(j in c(15:22)) {
  nomiss(paste0("whr",j))
  assign(paste0("whr",j,"_2"),
         get(paste0("whr",j,"_2")) %>%
           mutate(newrank = row_number()) %>%
           select(newrank, everything()))
}
nomiss("comb0821")
nomiss("mortality")
nomiss("anxiety")
nomiss("depression")


# saving data sets in local folder
for(k in c(15:22)){
  write.csv(get(paste0("whr",k,"_1")),
            paste0("derived_data/whr",k,"_1.csv"), row.names=FALSE)
  write.csv(get(paste0("whr",k,"_2")),
            paste0("derived_data/whr",k,"_2.csv"), row.names=FALSE)
}
for(l in c(1:2)){
  write.csv(get(paste0("comb0821_",l)),
            paste0("derived_data/comb0821_",l,".csv"), row.names=FALSE)
  write.csv(get(paste0("anxiety_",l)),
            paste0("derived_data/anxiety_",l,".csv"), row.names=FALSE)
  write.csv(get(paste0("depression_",l)),
            paste0("derived_data/depression_",l,".csv"), row.names=FALSE)
  write.csv(get(paste0("mortality_",l)),
            paste0("derived_data/mortality_",l,".csv"), row.names=FALSE)
}

# clear some variables
rm(list=c(paste0("country",c(15:22)), paste0("country",c(0:3)),
          "x","i","j","k","l","all_csv_files","varlist",
          "comb_countries","countries_miss","countries_nomiss"))