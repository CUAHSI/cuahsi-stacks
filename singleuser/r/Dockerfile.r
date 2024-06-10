ARG BASE_VERSION
# Singleuser-Base 2023.08.24_1
# Ubuntu 20 - Focal
#FROM cuahsi/singleuser-base:2023.08.24_1
FROM cuahsi/singleuser-base:$BASE_VERSION

# NOTES:
# ------------------------------------------------------------
# The purpose of this Dockerfile is to fix the nbfetch library
# in the R environment
# ------------------------------------------------------------

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

#RUN jupyter labextension install @jupyterlab/server-proxy --minimize=False
RUN jupyter labextension install @jupyterlab/server-proxy --minimize=True

USER root

# instructions: https://posit.co/download/rstudio-server/ 
ENV RSTUDIO_VERSION=2023.09.1-494
RUN wget https://download2.rstudio.org/server/focal/amd64/rstudio-server-${RSTUDIO_VERSION}-amd64.deb \
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


USER $NB_USER

# Install r-base to pinned version first to make sure the
# correct version is installed before adding dependencies.
RUN mamba install -y  --quiet \
    #--channel r \
    --channel conda-forge \
  r-base \
&& conda clean --all -f -y \
&& fix-permissions $CONDA_DIR

# Large Packages
RUN mamba install -y \
  --channel conda-forge \
  r-sf \
  r-caret \
  r-tidyverse \ 
  r-forecast \
  r-randomforest \
  r-essentials \
  r-sparklyr \ 
&& conda clean --all -f -y \
&& fix-permissions $CONDA_DIR

RUN mamba install -y \
  --channel conda-forge \
  r-irkernel \
  jupyter-rsession-proxy \
  r-ncdf4 \
  r-rmarkdown \
  r-rjsonio \
  r-mapdata \
  r-gridextra \
  r-ggmap \
  r-rsqlite \
&& conda clean --all -f -y \
&& fix-permissions $CONDA_DIR

RUN mamba install -y \
  --channel conda-forge \
  r-dplyr \
  r-dataretrieval \
  r-stringi \
  r-waterml \
&& conda clean --all -f -y \
&& fix-permissions $CONDA_DIR

RUN mamba install -y \
  --channel conda-forge \
  r-nnls \
  r-tictoc \
  r-dataexplorer \
  pyproj \
&& conda clean --all -f -y \
&& fix-permissions $CONDA_DIR

RUN mamba install -y \
  --channel conda-forge \
  r-terra \
  r-arrow \
&& conda clean --all -f -y \
&& fix-permissions $CONDA_DIR

# Install NHDPlusTools
RUN R -e 'install.packages("nhdplusTools", lib = Sys.getenv("R_LIBS_USER"), repos = "https://cran.rstudio.com/")'

# set projection info for use by r-sf.
# this requires that pyproj is installed
# on the system (see above)
ENV PROJ_LIB='/opt/conda/share/proj/'

USER root
RUN rm -rf /home/jovan/.cache/* \
  && fix-permissions $CONDA_DIR \
  && fix-permissions /home/$NB_USER 
USER $NB_UID
