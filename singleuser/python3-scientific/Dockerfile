ARG BASE_VERSION


# Collect dependencies from TauDEM image
#FROM nlknguyen/alpine-mpich:latest as mpi
FROM cuahsi/taudem:focal as taudem
WORKDIR /tmp
RUN ldd /usr/local/bin/pitremove | tr -s '[:blank:]' '\n' | grep '^/' |  xargs -I % sh -c 'mkdir -p $(dirname deps%); cp % deps%;'
RUN rm -rf /tmp/deps/lib64
# TEST!

# Build the scientific image here
FROM cuahsi/singleuser-base:$BASE_VERSION

ENV XDG_CACHE_HOME /home/$NB_USER/.cache/
ENV GDAL_DATA=/opt/conda/share/gdal
ENV PROJ_LIB=/opt/conda/share/proj

USER root
# copy TauDEM binaries
COPY --from=taudem /usr/local/bin/ /usr/local/bin/
USER $NB_UID

#---------------
# Conda packages
#---------------

# Core libs
RUN mamba install -y \
    python-wget \
    requests \
    requests-toolbelt \
    requests-oauthlib \
    beautifulsoup4 \
    dask \
    dill \
 && mamba clean --all -f -y 

# Numerical
RUN mamba install -y \
    pandas \
    scipy \
    scikit-learn \
    scikit-image \
    sympy \
    numexpr \
    openblas \
 && mamba clean --all -f -y 

# Geospatial
RUN mamba install -y \
    geopandas \
    gdal \
    pygmt \
 && mamba clean --all -f -y 

# Plotting
RUN mamba install -y \
    graphviz \
    matplotlib \
    seaborn \
    basemap-data-hires \
    bokeh \
    rasterio \
    rasterstats \
 && mamba clean --all -f -y 

# Statistics
RUN mamba install -y \
    statsmodels \
    patsy \
 && mamba clean --all -f -y 

# Data - Conda
RUN mamba install -y \
    netcdf4 \
    h5py \
    geemap \
 && mamba clean --all -f -y 

# Data - PYPI
RUN mamba install -y \
    landlab \
 && mamba clean --all -f -y 

# Modeling
RUN mamba install -y -c conda-forge \
    ogh \
    ulmo \
 && mamba clean --all -f -y 

#-------------
# PIP packages
#-------------

# Data
RUN pip install \
    dataretrieval==0.7 \
    tabulate \
    pynhd \
    jenkspy \
    pyhydroqc

#-------------


# Import matplotlib the first time to build the font cache.
RUN MPLBACKEND=Agg python -c "import matplotlib.pyplot" && \
    fix-permissions /home/$NB_USER

RUN rm -rf XDG_CACHE_HOME/*
USER $NB_UID
