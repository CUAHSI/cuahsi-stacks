ARG BASE_VERSION
FROM cuahsi/singleuser-scientific-r:$BASE_VERSION

## This is a Jupyter Environment created for Tao Wen at Syracuse University for his 2020 HydroGeology course.

USER $NB_UID

# Install python libraries
RUN conda install -y --quiet \
numpy \
matplotlib \
scipy \
geopandas \
pandas \
seaborn \
scikit-learn \
graphviz \
&& conda clean --all -f -y \
&& fix-permissions $CONDA_DIR

# Install R libraries
RUN conda install -y  --quiet \
r-base=3.6.1 \
r-shiny=1.3* \
r-plyr=1.8* \
r-randomforest=4.6* \
r-ggraph \
r-igraph \
r-party \
r-raster \
r-rgeos \
r-rgdal \
r-rcolorbrewer \
r-chron \
r-usdm \
r-swirl \
&& conda clean --all -f -y \
&& fix-permissions $CONDA_DIR

USER root
RUN apt-get update && apt-get install -y --no-install-recommends \
graphviz \
&& rm -rf /var/lib/apt/lists/*
USER $NB_UID

RUN conda install -y --quiet \
graphviz \
pydot \
configparser \
descartes \ 
&& conda clean --all -f -y \
&& fix-permissions $CONDA_DIR

USER root
RUN rm -rf /home/jovan/.cache/* \
&& fix-permissions $CONDA_DIR \
&& fix-permissions /home/$NB_USER 
USER $NB_UID
