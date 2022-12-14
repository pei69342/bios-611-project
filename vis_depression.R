library(tidyverse)
library(ggrepel)

# read in csv file from derived data folder
depression_2 <- read.csv(file="derived_data/depression_2.csv")
whr15_2 <- read.csv(file="derived_data/whr15_2.csv")
whr19_2 <- read.csv(file="derived_data/whr19_2.csv")
colnames(whr15_2)[!str_detect(colnames(whr15_2),"country")] <- paste0(names(whr15_2)[!str_detect(colnames(whr15_2),"country")],"15");
colnames(whr19_2)[!str_detect(colnames(whr19_2),"country")] <- paste0(names(whr19_2)[!str_detect(colnames(whr19_2),"country")],"19");

whr1519_diff <- whr15_2 %>% left_join(whr19_2, by = "country") %>%
  mutate(happiness_diff = happiness19-happiness15,
         gdp_diff = gdp19-gdp15,
         soc_supp_diff = soc_supp19-soc_supp15,
         hlife_diff = hlife19-hlife15,
         freedom_diff = freedom19-freedom15,
         generosity_diff = generosity19-generosity15,
         corruption_diff = corruption19-corruption15) %>%
  select(region15, country, happiness15, happiness19, happiness_diff, gdp_diff,
         soc_supp_diff, hlife_diff, freedom_diff, generosity_diff, corruption_diff);


# pivot wider to create scatter plot
depression_2_wide <- depression_2 %>% mutate(year=paste0("year",year)) %>%
  pivot_wider(id_cols=!percent,names_from = "year", values_from = "rate") %>%
  mutate(diff = year2019-year2015)


# add variables for color coding the graph
whr1519_diff2 <- whr1519_diff %>%
  mutate(change = as.factor(1*(happiness_diff > 0))) %>%
  select(country, change, happiness_diff);

# merge
depression_2_wide2 <- depression_2_wide %>% left_join(whr1519_diff2, by = "country") %>%
  mutate(diff2 = case_when(happiness_diff>0 ~ diff+5,
                           happiness_diff<=0 ~ diff-5),
         lab = case_when(diff > 235 ~ country,
                         diff < -150 ~ country));
plot1 <- ggplot(depression_2_wide2 %>% mutate(country = as.factor(diff)),
       aes(x=country, y=diff, label=lab)) +
  geom_point(size=1) + 
  geom_label_repel(min.segment.length = 0,
                   max.overlaps = Inf,
                   label.padding = 0,
                   label.r = 0,
                   label.size = 0,
                   size = 3,
                   direction = "y",
                   na.rm = TRUE) +
  ylab(label = "Changes in prevalence of depressive disorders \n (per 100,000 population)") +
  ggtitle("Changes in prevalence of derpession from 2015 to 2019") +
  theme(axis.title = element_text(size=9), axis.text.x = element_blank(),
        plot.title = element_text(size=10, hjust = 0.5))

plot2 <- ggplot(depression_2_wide2 %>% mutate(country = as.factor(diff)),
                aes(x=country, y=diff2, color=change, label=lab)) +
  geom_point(size=1) + 
  geom_label_repel(min.segment.length = 0,
                   max.overlaps = Inf,
                   label.padding = 0,
                   label.r = 0,
                   label.size = 0,
                   size = 3,
                   direction = "y",
                   na.rm = TRUE,
                   key_glyph="point") +
  labs(color="Increase in \n happiness scores") + 
  ylab(label = "Changes in prevalence of depressive disorders with slight offset \n (per 100,000 population)") +
  ggtitle("Changes in prevalence of depressive disorders from 2015 to 2019") +
  theme(axis.title = element_text(size=9), axis.text.x = element_blank(),
        plot.title = element_text(size=10, hjust = 0.5),
        legend.title = element_text(size=8, hjust = 0.5))

# save figure
ggsave("scatter_depression.png", plot1, path = "figures",
       width = 7, height = 4, dpi = 600)
ggsave("scatter_depression_color.png", plot2, path = "figures",
       width = 8, height = 4, dpi = 600)

# calculate proportion
dec_dep <- depression_2_wide2 %>% filter(diff <= 0)
inc_dep <- depression_2_wide2 %>% filter(diff > 0)

mean(as.numeric(c(dec_dep$change))-1) # 0.3333333
mean(as.numeric(c(inc_dep$change))-1) # 0.5803571