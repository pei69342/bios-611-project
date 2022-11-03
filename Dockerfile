FROM rocker/verse
RUN R -e "install.packages(\"matlab\")"
RUN R -e "install.packages(\"openxlsx\")"
RUN R -e "install.packages(\"rio\")"
RUN R -e "install.packages(\"ggcorrplot\")"
RUN R -e "install.packages(\"ggpubr\")"