setwd("~/work")
library(tidyverse)

# read in csv file from derived data folder
depression_2 <- read.csv(file="derived_data/depression_2.csv")

# pivot wider to create scatter plot
depression_2_wide <- depression_2 %>% mutate(year=paste0("year",year)) %>%
  pivot_wider(id_cols=!percent,names_from = "year", values_from = "rate") %>%
  mutate(diff = year2019-year2015)

plot1 <- ggplot(depression_2_wide %>% mutate(country = as.factor(diff)),
       aes(x=country, y=diff)) +
  geom_point(size=1) + ylab(label = "Changes in prevalence of depression \n (per 100,000 population)") +
  ggtitle("Changes in prevalence of derpession from 2015 to 2019") +
  theme(axis.title = element_text(size=9), axis.text.x = element_blank(),
        plot.title = element_text(size=10, hjust = 0.5))

# save figure
ggsave("scatter_depression.png", plot1, path = "figures",
       width = 8, height = 4, dpi = 600)