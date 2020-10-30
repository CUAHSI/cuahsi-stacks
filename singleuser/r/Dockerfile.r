ARG BASE_VERSION
FROM cuahsi/singleuser-base:$BASE_VERSION

USER root

RUN apt-get update && apt-get install -y --no-install-recommends \
fonts-dejavu \
unixodbc \
unixodbc-dev \
r-cran-rodbc \
gfortran \
gcc \
curl \
&& rm -rf /var/lib/apt/lists/*

RUN /bin/sh -c "ln -s /bin/tar /bin/gtar"

# install rstudio-server
USER root
RUN apt-get update && \
    curl --silent -L --fail https://download2.rstudio.org/rstudio-server-1.1.419-amd64.deb > /tmp/rstudio.deb && \
    echo '24cd11f0405d8372b4168fc9956e0386 /tmp/rstudio.deb' | md5sum -c - && \
    apt-get install -y /tmp/rstudio.deb && \
    rm /tmp/rstudio.deb && \
    apt-get clean
ENV PATH=$PATH:/usr/lib/rstudio-server/bin

USER $NB_USER
USER jovyan

#RUN mkdir $HOME/.userRLib \
#&& echo "options(repos=structure(c(CRAN=\"http://archive.linux.duke.edu/cran\")))" >> $HOME/.Rprofile \

#RUN conda config --add channels r \
#&& conda config --add channels conda-forge 

RUN conda install -y  --quiet \
  --channel r \
  --channel conda-forge \
  r-base=3.6.1 \
  r-caret=6.0* \
  r-crayon=1.3* \
  r-devtools=2.0* \
  r-forecast=8.7* \
  r-hexbin=1.27* \
  r-htmltools=0.3* \
  r-htmlwidgets=1.3* \
  r-irkernel=1.0* \
  r-nycflights13=1.0* \
  r-plyr=1.8* \
  r-randomforest=4.6* \
  r-rcurl=1.95* \
  r-reshape2=1.4* \
  r-rmarkdown=1.14* \
  r-rodbc=1.3* \
  r-rsqlite=2.1* \
  r-shiny=1.3* \
  r-sparklyr=1.0* \
  r-tidyverse=1.2* \ 
  unixodbc=2.3.* \
  r-essentials \
  r-xml \
  r-rjsonio \
  r-ncdf4 \
  r-sf \
  r-ggmap \
  r-mapdata \
  r-gridextra \
  nbrsessionproxy \
  r-e1071 \
  r-rgdal \
&& conda clean --all -f -y \
&& fix-permissions $CONDA_DIR

# install non-conda packages
ARG PACKAGES='"WaterML","dplyer","rgrass7","dataRetrieval","stringi"'
RUN /opt/conda/bin/Rscript -e "install.packages(c($PACKAGES), repos='http://archive.linux.duke.edu/cran')"

USER root
RUN rm -rf /home/jovan/.cache/* \
&& fix-permissions $CONDA_DIR \
&& fix-permissions /home/$NB_USER 
USER $NB_UID
