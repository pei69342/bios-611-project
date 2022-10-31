setwd("~/work")
library(tidyverse)

# read in csv file from derived data folder
whr_change <- read.csv(file="derived_data/whr_change.csv") %>%
  mutate(change_pos = as.factor(1*(change > 0)),
         happiness_avg1_bygrp = case_when(change>0 ~ happiness_avg1+0.05,
                                          change<=0 ~ happiness_avg1-0.05),
         happiness_avg2_bygrp = case_when(change>0 ~ happiness_avg2+0.05,
                                          change<=0 ~ happiness_avg2-0.05));

library(ggplot2)
# scatter plot
pre <- ggplot(whr_change %>% mutate(country = as.factor(happiness_avg1)),
       aes(x=country, y=happiness_avg1_bygrp, color=change_pos)) +
  geom_point(size=1) + ylab(label = "Average happiness score (with offset)") +
  guides(color = guide_legend(title = "Indicator of \n positive change")) +
  scale_color_manual(values=c("deepskyblue4","deepskyblue1")) +
  ggtitle("Average happiness score from 2015 to 2019 (with offset = 0.05)") +
  theme(legend.text = element_text(size=7),  axis.title = element_text(size=9),
        axis.text.x = element_blank(), legend.title = element_text(size=8),
        legend.title.align = 0.5, plot.title = element_text(size=10, hjust = 0.5))
  
post <- ggplot(whr_change %>% mutate(country = as.factor(happiness_avg2)),
       aes(x=country, y=happiness_avg2_bygrp, color=change_pos)) +
  geom_point(size=1) + ylab(label = "Average happiness score (with offset)") +
  guides(color = guide_legend(title = "Indicator of \n positive change")) +
  scale_color_manual(values=c("deepskyblue4","deepskyblue1")) +
  ggtitle("Average happiness score from 2020 to 2022 (with offset = 0.05)") +
  theme(legend.text = element_text(size=7),  axis.title = element_text(size=9),
        axis.text.x = element_blank(), legend.title = element_text(size=8),
        legend.title.align = 0.5, plot.title = element_text(size=10, hjust = 0.5))

# save figures
ggsave("scatter_pre.png", pre, path = "figures",
       width = 8, height = 4, dpi = 600)
ggsave("scatter_post.png", post, path = "figures",
       width = 8, height = 4, dpi = 600)