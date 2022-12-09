library(tidyverse)

# read in csv files from derived data folder
all_csv_files <- list.files(path="derived_data",pattern="*.csv")
keep_files <- all_csv_files[str_detect(all_csv_files,"_2")]
keep_files <- keep_files[str_detect(keep_files,"whr")]

# China, Hong Kong, Japan, South Korea, Taiwan
for(x in c(1:length(keep_files))){
  assign(substring(keep_files[x],1,nchar(keep_files[x])-4),
         read.csv(file=paste0("derived_data/",keep_files[x])) %>% 
           filter(country %in% c("China", "Hong Kong", "Japan", "South Korea", "Taiwan")) %>%
           mutate(year = 2014+x))
}
comb0821_2 <- read.csv(file="derived_data/comb0821_2.csv") %>%
  filter(country %in% c("China", "Hong Kong", "Japan", "South Korea", "Taiwan") &
           year > 2014)

comb <- rbind(whr15_2 %>% select(country, year, happiness),
              whr16_2 %>% select(country, year, happiness),
              whr17_2 %>% select(country, year, happiness),
              whr18_2 %>% select(country, year, happiness),
              whr19_2 %>% select(country, year, happiness),
              whr20_2 %>% select(country, year, happiness),
              whr21_2 %>% select(country, year, happiness),
              whr22_2 %>% select(country, year, happiness))

hap <- ggplot(comb, aes(x=year, y=happiness, color=country)) + geom_point() +
  geom_line() + ggtitle("Changes in happiness score from 2015 to 2022") +
  ylab("Happiness Score") +
  theme(plot.title = element_text(size=10, hjust = 0.5),
        axis.title = element_text(size=9),
        legend.title = element_text(size=9),
        legend.text = element_text(size=8))

gdp <- ggplot(comb0821_2, aes(x=year, y=gdp, color=country)) + geom_point() +
  geom_line() + ggtitle("Changes in log GDP from 2015 to 2022") +
  ylab("Log GDP per capita") +
  theme(plot.title = element_text(size=10, hjust = 0.5),
        axis.title = element_text(size=9),
        legend.title = element_text(size=9),
        legend.text = element_text(size=8))
soc <- ggplot(comb0821_2, aes(x=year, y=soc_supp, color=country)) + geom_point() +
  geom_line() + ggtitle("Changes in social support score from 2015 to 2022") +
  ylab("Social Support Score") +
  theme(plot.title = element_text(size=10, hjust = 0.5),
        axis.title = element_text(size=9),
        legend.title = element_text(size=9),
        legend.text = element_text(size=8))
free <- ggplot(comb0821_2, aes(x=year, y=freedom, color=country)) + geom_point() +
  geom_line() + ggtitle("Changes in freedom score from 2015 to 2022") +
  ylab("Freedom Score") +
  theme(plot.title = element_text(size=10, hjust = 0.5),
        axis.title = element_text(size=9),
        legend.title = element_text(size=9),
        legend.text = element_text(size=8))
corrupt <- ggplot(comb0821_2, aes(x=year, y=corruption, color=country)) + geom_point() +
  geom_line() + ggtitle("Changes in perception of corruption score from 2015 to 2022") +
  ylab("Perception of Corruption Score") +
  theme(plot.title = element_text(size=10, hjust = 0.5),
        axis.title = element_text(size=9),
        legend.title = element_text(size=9),
        legend.text = element_text(size=8))
conf <- ggplot(comb0821_2, aes(x=year, y=conf_in_gov, color=country)) + geom_point() +
  geom_line() + ggtitle("Changes in confidence in government score from 2015 to 2022") +
  ylab("Confidence in Government Score") +
  theme(plot.title = element_text(size=10, hjust = 0.5),
        axis.title = element_text(size=9),
        legend.title = element_text(size=9),
        legend.text = element_text(size=8))

# save figure
ggsave("selected_countries_happiness.png", hap, path = "figures",
       width = 8, height = 4, dpi = 600)
ggsave("selected_countries_gdp.png", gdp, path = "figures",
       width = 8, height = 4, dpi = 600)
ggsave("selected_countries_soc.png", soc, path = "figures",
       width = 8, height = 4, dpi = 600)
ggsave("selected_countries_free.png", free, path = "figures",
       width = 8, height = 4, dpi = 600)
ggsave("selected_countries_corrupt.png", corrupt, path = "figures",
       width = 8, height = 4, dpi = 600)
ggsave("selected_countries_conf.png", conf, path = "figures",
       width = 8, height = 4, dpi = 600)