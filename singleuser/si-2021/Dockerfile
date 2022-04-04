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

# Modeling
RUN pip install \
ogh \
ulmo 

## ML Libraries
RUN conda install -y \
 pytorch \
 cudatoolkit \
 hdf5 \
 numba \
 pytest \
 pytest-cov \
 ruamel.yaml \
 sphinx \
 tqdm  \
 yapf \
&& conda clean --all -f -y 

RUN pip install \
  tensorboard \
  sphinx-rtd-theme \
  nbsphinx \
  nbsphinx-link 



# Import matplotlib the first time to build the font cache.
RUN MPLBACKEND=Agg python -c "import matplotlib.pyplot" && \
    fix-permissions /home/$NB_USER

# Set GDAL and Proj env vars. This is necessary to ensure gdal commands don't error out when the base
# conda environment is not explicitly activated.
# see https://gis.stackexchange.com/questions/326968/ogr2ogr-error-1-proj-pj-obj-create-cannot-find-proj-db
ENV GDAL_DATA=/opt/conda/share/gdal \
    PROJ_LIB=/opt/conda/share/proj

# Add some JupyterLab extensions
RUN jupyter labextension install @lckr/jupyterlab_variableinspector
RUN pip install https://github.com/ipython-contrib/jupyter_contrib_nbextensions/tarball/master \
&& jupyter contrib nbextension install --user 

# turn off minimization because this is causing problems with 
# Git help and man pages
RUN jupyter lab build --minimize=False

# Add Kyle's library (requires a fortran compiler)
RUN cd /tmp \
&& git clone https://github.com/clawpack/clawpack.git \
&& pip install -e clawpack


# add some additional libraries
USER root
RUN pip install pdbpp
RUN apt update && \
    apt install -y \
    nano \
    && rm -rf /var/lib/apt/lists/*

RUN apt-get update && \
    apt-get install -y \
    libnetcdff-dev \
    htop \
    && rm -rf /var/lib/apt/lists/*

ENV CLAW=/tmp/clawpack
USER $NB_UID

RUN rm -rf XDG_CACHE_HOME/*

