ARG BASE_VERSION
FROM cuahsi/singleuser-base:$BASE_VERSION

USER root

RUN sudo apt install ca-certificates

RUN apt-get update && \
    apt-get install -y --no-install-recommends ffmpeg && \
    rm -rf /var/lib/apt/lists/*

USER $NB_UID

ENV XDG_CACHE_HOME /home/$NB_USER/.cache/

# System libs
RUN conda install -y \
python-wget \
requests \
&& conda clean --all -f -y 

# Numerical
RUN conda install -y \
pandas \
scipy \
numpy \
openblas \
&& conda clean --all -f -y 

# Geospatial
RUN conda install -y \
geopandas \
gdal \
&& conda clean --all -f -y 

# Plotting
RUN conda install -y \
matplotlib \
seaborn \
rasterio \
rasterstats \
&& conda clean --all -f -y 

# Statistics
RUN conda install -y \
statsmodels \
&& conda clean --all -f -y 

# Data - Conda
RUN conda install -y \
netcdf4 \
h5py \
&& conda clean --all -f -y 

# get the MODFLOW binaries
RUN curl -L -o linux.zip https://github.com/MODFLOW-USGS/executables/releases/download/2.0/linux.zip?raw=true \
&& mkdir binaries \
&& unzip linux.zip -d binaries \
&& rm linux.zip 

# add binaries to the path
ENV PATH="/home/jovyan/binaries:${PATH}"

# Import matplotlib the first time to build the font cache.
RUN MPLBACKEND=Agg python -c "import matplotlib.pyplot" && \
    fix-permissions /home/$NB_USER

USER root
RUN apt update && apt install -y cmake \
&& rm -rf /var/lib/apt/lists/*

# Set GDAL and Proj env vars. This is necessary to ensure gdal commands don't error out when the base
# conda environment is not explicitly activated.
# see https://gis.stackexchange.com/questions/326968/ogr2ogr-error-1-proj-pj-obj-create-cannot-find-proj-db
ENV GDAL_DATA=/opt/conda/share/gdal \
    PROJ_LIB=/opt/conda/share/proj

RUN rm -rf XDG_CACHE_HOME/*
USER $NB_UID

