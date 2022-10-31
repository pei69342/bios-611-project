setwd("~/work")
library(tidyverse)

# read in csv files from derived data folder
all_csv_files <- list.files(path="derived_data",pattern="*.csv")
keep_files <- all_csv_files[str_detect(all_csv_files,"_2")]
keep_files <- keep_files[str_detect(keep_files,"whr")]
for(x in c(1:length(keep_files))){
  assign(substring(keep_files[x],1,nchar(keep_files[x])-4),
         read.csv(file=paste0("derived_data/",keep_files[x])))
}

library(ggplot2)
library(ggpubr)

# Basic histogram of happiness scores
create_hist <- function(ds,year){
  ggplot(ds, aes(x=happiness)) +
    geom_histogram(aes(y=..density..), binwidth=0.15,
                   fill="white", color="gray") +
    xlim(3, 8) +
    ylim(0, 0.85) +
    geom_density(alpha=.2, fill="#FF6666", color="gray") +
    geom_vline(aes(xintercept=mean(happiness)),
               color="azure4", linetype="dashed", size=1) +
    theme(plot.margin = margin(t=0.5,r=0.2,b=0.05,l=0.2, unit = "cm"),
          axis.title = element_text(size=8),
          axis.text = element_text(size=7));
}

# plot histograms from 2015 to 2022
for(yr in c(15:22)){
  assign(paste0("hist",yr),
         create_hist(ds=get(paste0("whr",yr,"_2")),year=2000+yr),
         pos = 1);
  
}

hist_comb <- ggarrange(hist15, hist16, hist17, hist18,
          hist19, hist20, hist21, hist22,
          labels = c(paste("Histogram of happiness score \n    YEAR",
                           2015),
                     paste("Histogram of happiness score \n    YEAR",
                           2016),
                     paste("YEAR",2017), paste("YEAR",2018),
                     paste("YEAR",2019), paste("YEAR",2020),
                     paste("YEAR",2021), paste("YEAR",2022)),
          hjust = c(-0.5,-0.5, c(rep(-0.8,6))),
          vjust = c(1.1,1.1,c(rep(2.5,6))),
          font.label = list(size = 9, color = "black",
                            face = "bold", family = NULL),
          ncol = 2, nrow = 4);

# save combined figure
ggsave("hist_yr1522.png", hist_comb, path = "figures",
       width = 8, height = 10, dpi = 600)

rm(list=c(paste0("hist",c(15:22)),"hist_comb","yr"))