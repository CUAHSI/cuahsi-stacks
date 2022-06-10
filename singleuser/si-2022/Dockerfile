ARG BASE_VERSION
FROM cuahsi/conda-si:1652463125

FROM cuahsi/singleuser-base:$BASE_VERSION

COPY --from=0 /opt/conda/ /opt/conda

# set EnvVars.
# DATA and OAUTH are used by hydroshare_on_jupyter
ENV XDG_CACHE_HOME /home/$NB_USER/.cache/ \
    GDAL_DATA=/opt/conda/share/gdal \
    PROJ_LIB=/opt/conda/share/proj \
    DATA=${HOME}/downloads \
    OAUTH=${HOME}/.hs_auth


# Import matplotlib the first time to build the font cache.
RUN MPLBACKEND=Agg python -c "import matplotlib.pyplot" && \
    fix-permissions /home/$NB_USER




USER root

RUN apt-get update \
 && apt-get install -y --no-install-recommends \
    nano \
    vim \
    htop \
    libnetcdff-dev \
    curl \
    git \
    gfortran \
 # NextGen System Dependencies
    tar \
    g++ \
    gcc \
    make \
    cmake \
    bzip2 \
    libudunits2-dev \
    texinfo \
 && rm -rf /var/lib/apt/lists/*

ENV BOOST_ROOT="/opt/boost_1_72_0" \
    CXX=/usr/bin/g++

# Install Boost (NextGen Dep.)
WORKDIR /opt
RUN curl -L -O https://boostorg.jfrog.io/artifactory/main/release/1.72.0/source/boost_1_72_0.tar.bz2 \
 && tar -xjf boost_1_72_0.tar.bz2 \
 && rm boost_1_72_0.tar.bz2


## Install Python 3.8 (NextGen Dep.)
#RUN mamba install -y \
    #    numpy \
    # && conda clean --all -f -y

# ------------------------- 
# Install NextGen
# ------------------------- 
ENV NGEN_ROOT=/home/jovyan/ngen

RUN mkdir $NGEN_ROOT \
 && cd $NGEN_ROOT \
 && git clone https://github.com/NOAA-OWP/ngen.git . \
 && git submodule update --init --recursive -- test/googletest \
 && git submodule update --init --recursive -- extern/pybind11

RUN cd $NGEN_ROOT \
 && cmake -B $NGEN_ROOT -S . \
 && cmake --build $NGEN_ROOT --target ngen

# put NGEN executable in PATH
RUN chmod +x /home/jovyan/ngen/ngen
ENV PATH="/home/jovyan/ngen:${PATH}"

# add example data to home folder
RUN mv /home/jovyan/ngen/data $HOME/data

# build JupyterLab
RUN jupyter lab build

USER $NB_UID
WORKDIR /home/$NB_USER/data 


# clean cache files
RUN rm -rf XDG_CACHE_HOME/*

# remove the "work" folder since we're not using install
RUN rm -rf /home/jovyan/work


## configure JupyterLab extensions
#RUN jupyter nbextension enable --py ipyleaflet \
# && jupyter nbextension enable --py widgetsnbextension \
# && jupyter labextension install jupyter-leaflet \
# && jupyter labextension install @jupyter-widgets/jupyterlab-manager \
# && python -m hydroshare_on_jupyter configure
