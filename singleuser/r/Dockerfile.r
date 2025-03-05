ARG BASE_VERSION
FROM cuahsi/singleuser-base:$BASE_VERSION

# install rstudio-server
USER root
RUN apt update \
 && apt install -y r-base gdebi-core

COPY logging.conf /etc/rstudio/logging.conf

# instructions: https://posit.co/download/rstudio-server/ 
ENV RSTUDIO_VERSION=2024.12.1-563
RUN wget https://download2.rstudio.org/server/jammy/amd64/rstudio-server-${RSTUDIO_VERSION}-amd64.deb \
 && gdebi -n rstudio-server-${RSTUDIO_VERSION}-amd64.deb

USER $NB_UID

RUN pip install git+https://github.com/huntdatacenter/jupyter-rsession-proxy.git@add-timeout
RUN jupyter labextension install @jupyterlab/server-proxy --minimize=True


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
  r-climate4r.climdex \
&& conda clean --all -f -y \
&& fix-permissions $CONDA_DIR

# Install NHDPlusTools
RUN R -e 'install.packages("nhdplusTools", repos = "https://cran.rstudio.com/")'

# set projection info for use by r-sf.
# this requires that pyproj is installed
# on the system (see above)
ENV PROJ_LIB='/opt/conda/share/proj/'

USER root
RUN rm -rf /home/jovan/.cache/* \
  && fix-permissions $CONDA_DIR \
  && fix-permissions /home/$NB_USER 
USER $NB_UID
