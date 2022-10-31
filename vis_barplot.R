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
# pivot long to make stacked barplots
bar_plong <- function(ds){
  ds %>%
    select(country, gdp:dystopia_plus_residual) %>%
    pivot_longer(!country, names_to = "factor", values_to = "happiness") %>%
    left_join(ds[c("newrank","country")], by="country") %>%
    mutate(factor_order = case_when(factor == "corruption" ~ 1,
                                    factor == "generosity" ~ 2,
                                    factor == "freedom" ~ 3,
                                    factor == "hlife" ~ 4,
                                    factor == "soc_supp" ~ 5,
                                    factor == "gdp" ~ 6,
                                    factor == "dystopia_plus_residual" ~ 7)) %>%
    mutate(factor = fct_reorder(factor, as.integer(factor_order))) %>%
    mutate(country = fct_reorder(country, as.integer(newrank)));
}

# Basic barplot of happiness scores color-coded by factors
create_bar <- function(ds){
  ggplot(data=ds, aes(x=country, y=happiness,
                          fill=factor)) +
    geom_bar(stat="identity") +
    theme(axis.text.x = element_text(angle = 45,
                                     vjust = 1, hjust=1)) +
    theme(plot.margin = margin(0.7,0.5,0.3,0.5, unit = "cm"),
          legend.text = element_text(size=7),
          axis.title = element_text(size=8),
          axis.text = element_text(size=7),
          legend.title = element_text(size=8, face="bold")) +
    scale_fill_manual(values=c('darkorange3', 'gold', 'cadetblue2',
                               'darkorchid', 'forestgreen', 'lightpink',
                               'darkgrey'),
                      labels=list(gdp="GDP per capita",
                                  soc_supp="Social support",
                                  hlife="Healthy life expectancy",
                                  freedom="Freedom to make life choices",
                                  generosity="Generosity",
                                  corruption="Perceptions of corruption",
                                  dystopia_plus_residual="Dystopia + residual"));
}

# adding a horizontal line showing dystopia baseline score
dys_label <- function(oldds, ds){
  create_bar(ds) +
    geom_hline(yintercept=oldds$dystopia_score[1],
               linetype='dashed', color='white') +
    annotate('text', x=2, y=oldds$dystopia_score[1],
             label='Dystopia baseline', size=3)
}

# top 10 vs. bottom 10
bar_topbottom <- function(ds,suffix){
  top10 <- ds %>% filter(newrank <= 10);
  bottom10 <- ds %>% filter(newrank >= nrow(.)-9);
  top10 <- bar_plong(top10);
  bottom10 <- bar_plong(bottom10);
  assign(paste0("top10_",suffix), dys_label(ds, top10), pos = 1);
  assign(paste0("bottom10_",suffix), dys_label(ds, bottom10), pos = 1);
}


# high vs. low
# Split data to >= 75% quantile and <= 25% quantile
# Then randomly select 10 countries to further investigate
bar_highlow <- function(ds,suffix){
  hap <- cbind(summary(ds$happiness)[[2]], summary(ds$happiness)[[5]]);
  lower <- ds %>% filter(happiness <= hap[1]) %>%
    mutate(keep = runif(nrow(.))) %>% arrange(keep) %>% head(10);
  higher <- ds %>% filter(happiness >= hap[2]) %>%
    mutate(keep = runif(nrow(.))) %>% arrange(keep) %>% head(10);
  lower <- bar_plong(lower);
  higher <- bar_plong(higher);
  assign(paste0("lower_",suffix), dys_label(ds, lower) +
           xlab("country (randomly selected)"), pos = 1);
  assign(paste0("higher_",suffix), dys_label(ds, higher) +
           xlab("country (randomly selected)"), pos = 1);
}

# Creating bar plots from 2015 to 2022
for(yr in c(15:22)){
  bar_topbottom(get(paste0("whr",yr,"_2")),yr)
  bar_highlow(get(paste0("whr",yr,"_2")),yr)
}

# Arranging multiple plots into one figure
bar_arrange <- function(fg1,fg2,yr1, yr2, lb1, lb2, h, v){
  ggarrange(get(paste0(fg1,yr1)), get(paste0(fg2,yr1)),
            get(paste0(fg1,yr2)), get(paste0(fg2,yr2)),
            common.legend = TRUE,
            legend = c("bottom"),
            labels = c(paste(lb1, 2000+yr1),
                       paste(lb2, 2000+yr1),
                       paste("YEAR",2000+yr2),
                       paste("YEAR",2000+yr2)),
            hjust = h, vjust = v,
            font.label = list(size = 9, color = "black",
                              face = "bold", family = NULL),
            ncol = 2, nrow = 2);
}


# figures for top 10 vs. bottom 10
lb_top <- "Top 10 countries ranked by happiness score \n        YEAR";
lb_bottom <- "Bottom 10 countries ranked by happiness score \n        YEAR";
h_topbottom <- c(-0.17,-0.15, -0.6, -0.6);
v_topbottom <- c(1.1,1.1,2.3,2.3);
bar1 <- bar_arrange("top10_","bottom10_",15, 16,
                    lb1=lb_top, lb2=lb_bottom,
                    h=h_topbottom, v=v_topbottom);
bar2 <- bar_arrange("top10_","bottom10_",17, 18,
                    lb1=lb_top, lb2=lb_bottom,
                    h=h_topbottom, v=v_topbottom);
bar3 <- bar_arrange("top10_","bottom10_",19, 20,
                    lb1=lb_top, lb2=lb_bottom,
                    h=h_topbottom, v=v_topbottom);
bar4 <- bar_arrange("top10_","bottom10_",21, 22,
                    lb1=lb_top, lb2=lb_bottom,
                    h=h_topbottom, v=v_topbottom);

# figures for higher vs. lower
lb_high <- "10 countries with score >= the 75th percentile\n        YEAR";
lb_low <- "10 countries with score <= the 25th percentile\n        YEAR";
h_highlow <- c(-0.16,-0.15, -0.63, -0.63);
v_highlow <- c(1.1,1.1,2.3,2.3);
bar5 <- bar_arrange("higher_","lower_",15, 16,
                    lb1=lb_high, lb2=lb_low,
                    h=h_highlow, v=v_highlow);
bar6 <- bar_arrange("higher_","lower_",17, 18,
                    lb1=lb_high, lb2=lb_low,
                    h=h_highlow, v=v_highlow);
bar7 <- bar_arrange("higher_","lower_",19, 20,
                    lb1=lb_high, lb2=lb_low,
                    h=h_highlow, v=v_highlow);
bar8 <- bar_arrange("higher_","lower_",21, 22,
                    lb1=lb_high, lb2=lb_low,
                    h=h_highlow, v=v_highlow);

# save figures
figures_output <- function(filename, var, w, h){
  ggsave(filename, var, path = "figures",
         width = w, height = h, dpi = 600)
}
figures_output("bar_yr1516.png", bar1, 8, 7)
figures_output("bar_yr1718.png", bar2, 8, 7)
figures_output("bar_yr1920.png", bar3, 8, 7)
figures_output("bar_yr2122.png", bar4, 8, 7)

figures_output("bar_rand_yr1516.png", bar5, 8, 7)
figures_output("bar_rand_yr1718.png", bar6, 8, 7)
figures_output("bar_rand_yr1920.png", bar7, 8, 7)
figures_output("bar_rand_yr2122.png", bar8, 8, 7)


# remove some variables
rm(list=c(paste0("top10_",c(15:22)), paste0("bottom10_",c(15:22)),
          paste0("higher_",c(15:22)), paste0("lower_",c(15:22)),
          paste0("bar",c(1:8)),
          "keep_files","x","yr",
          c(ls()[str_detect(ls(),"h_")],
            ls()[str_detect(ls(),"v_")],
            ls()[str_detect(ls(),"lb_")])))