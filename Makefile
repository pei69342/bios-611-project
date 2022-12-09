.PHONY: clean

clean:
	rm -rf figures
	rm -rf derived_data
	rm -rf retrieved_data
	rm -rf .created-dirs
	rm -rf .Rhistory
	rm -f Rplots.pdf
	rm -f BIOS611Project_Shih.pdf
	rm -f BIOS611Project_Shih.tex
	rm -f BIOS611Project_Shih.txt
	rm -f BIOS611Project_Shih.html

.created-dirs:
	mkdir -p figures
	mkdir -p derived_data
	mkdir -p retrieved_data
	touch .created-dirs

# Retrieve data from url links
retrieved_data/whr15_raw.csv\
 retrieved_data/whr16_raw.csv\
 retrieved_data/whr17_raw.csv\
 retrieved_data/whr18_raw.csv\
 retrieved_data/whr19_raw.csv\
 retrieved_data/whr20_raw.csv\
 retrieved_data/whr21_raw.csv\
 retrieved_data/whr22_raw.csv\
 retrieved_data/comb0821_raw.csv: .created-dirs import_whr_datasets.R
	Rscript import_whr_datasets.R

retrieved_data/mortality_raw.csv\
 retrieved_data/mental_health_raw.csv: .created-dirs\
  import_others.R source_data/IHME-GBD_2019_DATA.csv
	Rscript import_others.R

# Clean up data and output to derived_data folder
derived_data/whr15_1.csv\
 derived_data/whr16_1.csv\
 derived_data/whr17_1.csv\
 derived_data/whr18_1.csv\
 derived_data/whr19_1.csv\
 derived_data/whr20_1.csv\
 derived_data/whr21_1.csv\
 derived_data/whr22_1.csv\
 derived_data/comb0821_1.csv\
 derived_data/whr15_2.csv\
 derived_data/whr16_2.csv\
 derived_data/whr17_2.csv\
 derived_data/whr18_2.csv\
 derived_data/whr19_2.csv\
 derived_data/whr20_2.csv\
 derived_data/whr21_2.csv\
 derived_data/whr22_2.csv\
 derived_data/comb0821_2.csv\
 derived_data/anxiety_1.csv\
 derived_data/anxiety_2.csv\
 derived_data/depression_1.csv\
 derived_data/depression_2.csv\
 derived_data/mortality_1.csv\
 derived_data/mortality_2.csv: .created-dirs neat_datasets.R\
  retrieved_data/whr15_raw.csv\
  retrieved_data/whr16_raw.csv\
  retrieved_data/whr17_raw.csv\
  retrieved_data/whr18_raw.csv\
  retrieved_data/whr19_raw.csv\
  retrieved_data/whr20_raw.csv\
  retrieved_data/whr21_raw.csv\
  retrieved_data/whr22_raw.csv\
  retrieved_data/comb0821_raw.csv\
  retrieved_data/mortality_raw.csv\
  retrieved_data/mental_health_raw.csv
	Rscript neat_datasets.R

derived_data/whr_change.csv: .created-dirs whrcovid_datasets.R\
  derived_data/whr15_2.csv\
  derived_data/whr16_2.csv\
  derived_data/whr17_2.csv\
  derived_data/whr18_2.csv\
  derived_data/whr19_2.csv\
  derived_data/whr20_2.csv\
  derived_data/whr21_2.csv\
  derived_data/whr22_2.csv
	Rscript whrcovid_datasets.R

# Create bar plots
figures/bar_yr1516.png\
 figures/bar_yr1718.png\
 figures/bar_yr1920.png\
 figures/bar_yr2122.png\
 figures/bar_rand_yr1516.png\
 figures/bar_rand_yr1718.png\
 figures/bar_rand_yr1920.png\
 figures/bar_rand_yr2122.png: .created-dirs vis_barplot.R\
  derived_data/whr15_2.csv\
  derived_data/whr16_2.csv\
  derived_data/whr17_2.csv\
  derived_data/whr18_2.csv\
  derived_data/whr19_2.csv\
  derived_data/whr20_2.csv\
  derived_data/whr21_2.csv\
  derived_data/whr22_2.csv
	Rscript vis_barplot.R

# Create pairwise correlation plots
figures/corr_cs15.jpeg figures/corr_scatter15.jpeg: .created-dirs vis_corr15.R\
  derived_data/whr15_2.csv
	Rscript vis_corr15.R

figures/corr_cs22.jpeg figures/corr_scatter22.jpeg: .created-dirs vis_corr22.R\
  derived_data/whr22_2.csv
	Rscript vis_corr22.R

# Create color-coded scatter plots
figures/scatter_anxiety.png figures/scatter_anxiety_color.png: .created-dirs vis_anxiety.R\
  derived_data/anxiety_2.csv\
  derived_data/whr15_2.csv\
  derived_data/whr19_2.csv
	Rscript vis_anxiety.R

figures/scatter_depression.png figures/scatter_depression_color.png: .created-dirs vis_depression.R\
  derived_data/depression_2.csv\
  derived_data/whr15_2.csv\
  derived_data/whr19_2.csv
	Rscript vis_depression.R

# Create histograms of distribution of happiness scores
figures/hist_yr1522.png: .created-dirs vis_histogram.R\
  derived_data/whr15_2.csv\
  derived_data/whr16_2.csv\
  derived_data/whr17_2.csv\
  derived_data/whr18_2.csv\
  derived_data/whr19_2.csv\
  derived_data/whr20_2.csv\
  derived_data/whr21_2.csv\
  derived_data/whr22_2.csv
	Rscript vis_histogram.R

# Create scatter plots of pre- and post- COVID happiness score changes
figures/scatter_pre.png figures/scatter_post.png: .created-dirs\
  vis_scatter_change.R derived_data/whr_change.csv
	Rscript vis_scatter_change.R

# Explore WHR data in 5 countries in East Asia
figures/selected_countries_happiness.png\
 figures/selected_countries_gdp.png\
 figures/selected_countries_soc.png\
 figures/selected_countries_free.png\
 figures/selected_countries_corrupt.png\
 figures/selected_countries_conf.png: .created-dirs\
  vis_selected_countries.R\
    derived_data/whr15_2.csv\
  derived_data/whr16_2.csv\
  derived_data/whr17_2.csv\
  derived_data/whr18_2.csv\
  derived_data/whr19_2.csv\
  derived_data/whr20_2.csv\
  derived_data/whr21_2.csv\
  derived_data/whr22_2.csv\
  derived_data/comb0821_2.csv
	Rscript vis_selected_countries.R

# Build the final report for the project.
BIOS611Project_Shih.pdf: figures/corr_cs15.jpeg\
  figures/corr_scatter15.jpeg\
  figures/corr_cs22.jpeg\
  figures/corr_scatter22.jpeg\
  figures/bar_yr1920.png\
  figures/bar_yr2122.png\
  figures/scatter_depression_color.png\
  figures/scatter_anxiety_color.png\
  figures/selected_countries_happiness.png\
  figures/selected_countries_free.png
	Rscript -e 'rmarkdown::render("BIOS611Project_Shih.Rmd")'
