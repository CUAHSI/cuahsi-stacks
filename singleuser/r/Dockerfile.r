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
&& rm -rf /var/lib/apt/lists/*

RUN /bin/sh -c "ln -s /bin/tar /bin/gtar"

USER jovyan

RUN conda install -y  --quiet \
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
&& conda clean --all -f -y \
&& fix-permissions $CONDA_DIR


RUN conda install -y --quiet r-e1071

RUN conda install -yq -c conda-forge nbrsessionproxy && \
    conda clean -tipsy

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


RUN mkdir $HOME/.userRLib \
&& echo "options(repos=structure(c(CRAN=\"http://archive.linux.duke.edu/cran\")))" >> $HOME/.Rprofile \
&& conda config --add channels r \
&& conda config --add channels conda-forge 
#&& conda create -y -n R 

RUN conda install -c r -y \
  r-essentials \
  r-devtools \
  r-xml \
  r-rjsonio \
  r-ncdf4 \
  r-sf \
  r-ggmap \
  r-mapdata \
  r-gridextra \
&& conda clean --all -y 


#RUN /bin/bash -c "source activate R" \
ARG PACKAGES='"WaterML","dplyer","rgrass7","dataRetrieval","stringi"'
RUN /opt/conda/bin/Rscript -e "install.packages(c($PACKAGES))" 

# remove all registered kernels
#RUN jupyter kernelspec remove -f $(jupyter kernelspec list | tr -s ' ' | cut -f 2 -d' ' | tail -n +2)

## install the R kernel
#USER root
#RUN /opt/conda/envs/R/bin/python -m ipykernel install --prefix=/usr --name 'R-3.5.1'
#USER jovyan
#
#RUN pip uninstall -y ipykernel
#
USER root
RUN rm -rf /home/jovan/.cache/* \
&& fix-permissions $CONDA_DIR \
&& fix-permissions /home/$NB_USER 
USER $NB_UID
