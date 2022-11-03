setwd("~/work")

library(tidyverse)
library(ggplot2)
library(ggcorrplot)
library(ggpubr)
# read in csv files from derived data folder
whr22_2 <- read.csv("derived_data/whr22_2.csv")

# computing the correlation between each pair of components
cor_mat <- round(cor(whr22_2 %>% select(gdp:dystopia_plus_residual)),2)
p_mat <- cor_pmat(whr22_2 %>% select(gdp:dystopia_plus_residual))

# plot pairwise correlation
pairs(whr22_2 %>% select(gdp:dystopia_plus_residual))

corr1 <- ggcorrplot(cor_mat, type = "lower", tl.cex = 10,
                    title = "Pairwise correlation of the 7 factors \n in happiness score (2022)") +
  theme(plot.title = element_text(size=10, hjust = 0.5),
        legend.title = element_text(size=10))
corr2 <- ggcorrplot(cor_mat, type = "lower", lab = TRUE, lab_size = 3,
                    p.mat = p_mat, insig = "blank", tl.cex = 10,
                    title = "Significant pairwise correlation of the 7 factors \n in happiness score (2022)")  +
  theme(plot.title = element_text(size=10, hjust = 0.5),
        legend.title = element_text(size=10))


# gdp; soc_supp, hlife, freedom, corruption
p51 <- ggplot(whr22_2, aes(y=gdp, x=soc_supp)) + geom_point(size=1,alpha=0.5) +
  theme(axis.text = element_text(size=7), axis.title = element_text(size=8))
p52 <- ggplot(whr22_2, aes(y=gdp, x=hlife)) + geom_point(size=1,alpha=0.5) +
  theme(axis.text = element_text(size=7), axis.title = element_text(size=8))
p53 <- ggplot(whr22_2, aes(y=gdp, x=freedom)) + geom_point(size=1,alpha=0.5) +
  theme(axis.text = element_text(size=7), axis.title = element_text(size=8))
p55 <- ggplot(whr22_2, aes(y=gdp, x=corruption)) + geom_point(size=1,alpha=0.5) +
  theme(axis.text = element_text(size=7), axis.title = element_text(size=8))

# soc_supp; hlife, freedom, corruption
p42 <- ggplot(whr22_2, aes(y=soc_supp, x=hlife)) + geom_point(size=1,alpha=0.5) +
  theme(axis.text = element_text(size=7), axis.title = element_text(size=8))
p43 <- ggplot(whr22_2, aes(y=soc_supp, x=freedom)) + geom_point(size=1,alpha=0.5) +
  theme(axis.text = element_text(size=7), axis.title = element_text(size=8))
p45 <- ggplot(whr22_2, aes(y=soc_supp, x=corruption)) + geom_point(size=1,alpha=0.5) +
  theme(axis.text = element_text(size=7), axis.title = element_text(size=8))

# hlife; freedom, corruption
p33 <- ggplot(whr22_2, aes(y=hlife, x=freedom)) + geom_point(size=1,alpha=0.5) +
  theme(axis.text = element_text(size=7), axis.title = element_text(size=8))
p35 <- ggplot(whr22_2, aes(y=hlife, x=corruption)) + geom_point(size=1,alpha=0.5) +
  theme(axis.text = element_text(size=7), axis.title = element_text(size=8))

# freedom; generosity, corruption
p24 <- ggplot(whr22_2, aes(y=freedom, x=generosity)) + geom_point(size=1,alpha=0.5) +
  theme(axis.text = element_text(size=7), axis.title = element_text(size=8))
p25 <- ggplot(whr22_2, aes(y=freedom, x=corruption)) + geom_point(size=1,alpha=0.5) +
  theme(axis.text = element_text(size=7), axis.title = element_text(size=8))

# generosity; corruption
p15 <- ggplot(whr22_2, aes(y=generosity, x=corruption)) + geom_point(size=1,alpha=0.5) +
  theme(axis.text = element_text(size=7), axis.title = element_text(size=8))

# blank plot
p0 <- ggplot(whr22_2, aes(y=gdp, x=gdp)) + geom_blank() +
  theme_bw() + theme(axis.title = element_blank(), axis.text = element_text(size=8))

# combine plots to one figure
corr_fg1 <- ggarrange(corr1, corr2, ncol=2, nrow=1, common.legend = TRUE,
                      legend = "bottom");

corr_fg2 <- annotate_figure(ggarrange(p0, p0, p0, p0, p15,
                                      p0, p0, p0, p24, p25,
                                      p0, p0, p33, p0, p35,
                                      p0, p42, p43, p0, p45,
                                      p51, p52, p53, p0, p55,
                                      ncol = 5, nrow = 5),
                            top = text_grob("Scatterplots of pairs of factors with significant correlation in 2022",
                                            face = "bold", size = 12));

# save figures
ggsave("corr_cs22.jpeg", corr_fg1, path = "figures",
       width = 7, height = 4.5, dpi = 600)
ggsave("corr_scatter22.jpeg", corr_fg2, path = "figures",
       width = 7, height = 7, dpi = 600)