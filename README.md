---
editor_options: 
  markdown: 
    wrap: 72
---

# BIOS 611 Project on World Happiness Report

> The World Happiness Report ranks the happiness score of more than 150
> countries based on six explanatory factors: \* GDP per capita \*
> Social support \* Healthy life expectancy \* Freedom to make life
> choices \* Generosity \* Perceptions of corruption This project plans
> to achieve the following objectives: \* Assess how much each
> explanatory factor explains the happiness score in a country for a
> given year. \* Show the changes in the happiness scores and the
> changes in the rankings for a given region or country from 2015 to
> 2022. \* Compare the changes in the happiness scores to the changes in
> the prevalence of mental health disorders in selected countries with a
> high prevalence of mental health disorders and those with a low
> prevalence of mental health disorders from 2015 to 2022. \* Assess the
> impact of the COVID-19 pandemic on happiness scores and on the six
> explanatory factors using world happiness data from 2019 to 2022. The
> main motivation is that by examining how changes in economics, social
> structures, politics, and personal perceptions are associated with the
> changes in the happiness scores, we might better understand what
> measures we could take at each of the different levels to improve the
> quality of life.

## Instructions for creating and running the Docker container

Run the following lines in the terminal:

-   `cd "<path of root folder>"`

-   `docker build . -f Dockerfile -t 611-project`

-   `docker run -p 8787:8787 -v "$(pwd):/home/rstudio/work" -e PASSWORD=<yourpassword> -it 611-project`

    -   *Note: \<path of root folder\> and \$(pwd) should refer to the
        root folder that contains the R scripts and the source_data
        folder.*

## Instructions for creating the project pdf file in R studio

In the R studio inside the Docker container, run `setwd("~/work")` in
the Console to set up the working directory.\
Run `Make clean` in the terminal to remove all outputs created by the R
scripts in the /work folder.\
Run `Make BIOS611Project_Shih.pdf` in the terminal to produce the pdf
file that contains the final result of the project.
