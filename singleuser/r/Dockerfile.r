ARG BASE_VERSION
#FROM cuahsi/singleuser-base:$BASE_VERSION

FROM jupyter/minimal-notebook:ubuntu-20.04
#FROM rocker/binder:4.2
# TEST!

# install rstudio-server
USER root
RUN apt update \
 && apt install -y r-base gdebi-core

COPY logging.conf /etc/rstudio/logging.conf

USER $NB_UID

#RUN pip install jupyter-rsession-proxy
RUN pip install git+https://github.com/huntdatacenter/jupyter-rsession-proxy.git@add-timeout

#RUN mamba install -c conda-forge \

#  rstudio \

RUN jupyter labextension install @jupyterlab/server-proxy --minimize=False
#RUN jupyter labextension install @jupyterlab/server-proxy

USER root
ENV RSTUDIO_VERSION=2022.07.1-554
#1.2.5001
RUN wget https://download2.rstudio.org/server/bionic/amd64/rstudio-server-${RSTUDIO_VERSION}-amd64.deb \
 && gdebi -n rstudio-server-${RSTUDIO_VERSION}-amd64.deb


#ENV RSERVER_TIMEOUT=30

# && rm rstudio-server-2022.07.1-554-amd64.deb \
# && apt-get clean

#RUN echo "auth-revocation-list-dir=/tmp/rstudio-server-revocation-list/" >> /etc/rstudio/rserver.conf


#RUN rm /etc/rstudio/rserver.conf

#RUN apt-get update && apt-get install -y --no-install-recommends \
#fonts-dejavu \
#unixodbc \
#unixodbc-dev \
#r-cran-rodbc \
#gfortran \
#gcc \
#curl \
#&& rm -rf /var/lib/apt/lists/*
#
#RUN /bin/sh -c "ln -s /bin/tar /bin/gtar"


#USER $NB_USER
#
## Install r-base to pinned version first to make sure the
## correct version is installed before adding dependencies.
#RUN mamba install -y  --quiet \
#  --channel r \
#  --channel conda-forge \
#  r-base=4.2.0 \
#&& conda clean --all -f -y \
#&& fix-permissions $CONDA_DIR
#
#RUN mamba install -y --quiet \
#  --channel r \
#  --channel conda-forge \
#  r-irkernel \
#  jupyter-rsession-proxy \
#  r-caret \
#  r-devtools \
#  r-forecast \
#  r-rgdal \
#  r-randomforest \
#  r-ncdf4 \
#  r-essentials \
#  r-sf \
#  r-sparklyr \
#  r-tidyverse \ 
#  r-rmarkdown \
#  r-rjsonio \
#  r-mapdata \
#  r-gridextra \
#  r-ggmap \
#  r-rsqlite \
#  r-hexbin \
#  r-htmlwidgets \
#  r-plyr \
#&& conda clean --all -f -y \
#&& fix-permissions $CONDA_DIR
#
## install non-conda packages
#ARG PACKAGES='"WaterML","dplyer","rgrass7","dataRetrieval","stringi"'
#RUN /opt/conda/bin/Rscript -e "install.packages(c($PACKAGES), repos='http://archive.linux.duke.edu/cran')"
#

#
#USER $NB_UID
#
#RUN pip install jupyter-rsession-proxy
#
###RUN apt-get update && \
###    curl --silent -L --fail https://download2.rstudio.org/rstudio-server-1.1.419-amd64.deb > /tmp/rstudio.deb && \
###    echo '24cd11f0405d8372b4168fc9956e0386 /tmp/rstudio.deb' | md5sum -c - && \
###    apt-get install -y /tmp/rstudio.deb && \
###    rm /tmp/rstudio.deb && \
###    apt-get clean
##ENV PATH=$PATH:/usr/lib/rstudio-server/bin
#
#
#
#USER root
#RUN rm -rf /home/jovan/.cache/* \
#&& fix-permissions $CONDA_DIR \
#&& fix-permissions /home/$NB_USER 
USER $NB_UID
