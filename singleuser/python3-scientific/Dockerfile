ARG BASE_VERSION
FROM cuahsi/singleuser-base:$BASE_VERSION

USER root

RUN apt-get update && \
    apt-get install -y --no-install-recommends ffmpeg && \
    rm -rf /var/lib/apt/lists/*

USER $NB_UID

ENV XDG_CACHE_HOME /home/$NB_USER/.cache/

# System libs
RUN conda install -y \
python-wget \
requests \
requests-toolbelt \
requests-oauthlib \
beautifulsoup4 \
dask \
dill \
&& conda clean --all -f -y 

#---------------
# Conda packages
#---------------

# Numerical
RUN conda install -y \
pandas \
scipy \
scikit-learn \
scikit-image \
sympy \
numexpr \
openblas \
&& conda clean --all -f -y 

# Geospatial
RUN conda install -y \
geopandas \
gdal \
&& conda clean --all -f -y 

# Plotting
RUN conda install -y \
graphviz \
matplotlib \
seaborn \
basemap-data-hires \
bokeh \
rasterio \
rasterstats \
&& conda clean --all -f -y 

# Statistics
RUN conda install -y \
statsmodels \
patsy \
&& conda clean --all -f -y 

# Data - Conda
RUN conda install -y \
netcdf4 \
h5py \
geemap \
&& conda clean --all -f -y 

# Data - PYPI
RUN conda install -y \
landlab \
&& conda clean --all -f -y 
#---------------

#-------------
# PIP packages
#-------------

# Modeling
RUN pip install \
ogh \
ulmo 

# Data
RUN pip install \
dataretrieval==0.7

#-------------


# Import matplotlib the first time to build the font cache.
RUN MPLBACKEND=Agg python -c "import matplotlib.pyplot" && \
    fix-permissions /home/$NB_USER

USER root
RUN apt update && apt install -y cmake \
&& rm -rf /var/lib/apt/lists/*

# install TauDEM
ARG TAG=Develop
RUN git clone --depth=1 --branch $TAG https://github.com/dtarb/TauDEM.git /tmp/TauDEM \
&& mkdir -p /tmp/TauDEM/src/build \
&& cd /tmp/TauDEM/src/build \
&& cmake .. \
&& make \
&& mv /tmp/TauDEM/src/build/* /usr/local/bin \
&& rm -rf /tmp/TauDEM

# Set GDAL and Proj env vars. This is necessary to ensure gdal commands don't error out when the base
# conda environment is not explicitly activated.
# see https://gis.stackexchange.com/questions/326968/ogr2ogr-error-1-proj-pj-obj-create-cannot-find-proj-db
ENV GDAL_DATA=/opt/conda/share/gdal \
    PROJ_LIB=/opt/conda/share/proj

## install system monitor
#RUN pip install nbresuse==0.3.3 \
#&& jupyter labextension install jupyterlab-topbar-extension jupyterlab-system-monitor

RUN rm -rf XDG_CACHE_HOME/*
USER $NB_UID

