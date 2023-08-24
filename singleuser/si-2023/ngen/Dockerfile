FROM cuahsi/si-python-deps:latest as pythondeps

FROM jupyterhub/singleuser:4.0
LABEL maintainer="Tony Castronova <acastronova@cuahsi.org>"

USER root

# ----------------------
# Linux System Libraries
# ----------------------
RUN export DEBIAN_FRONTEND=noninteractive \
  && apt update && apt install -y --no-install-recommends \
  git \
  vim \
  curl \
  ca-certificates \
  build-essential \
  gnupg \ 
  wget \
  libgdal-dev \
  libmpich-dev \
  zip \ 
  unzip \
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
# ---------------------


# ---------------------
# Directory Setup
# ---------------------
USER $NB_UID

# set the home dir
ENV HOME=/home/$NB_USER

# set the default terminal start path to $HOME
RUN echo 'cd $HOME' >> .profile

# remove work dir b/c we're using "data"
RUN rm -rf ~/work

# create directory for compiled code
USER root
RUN mkdir /opt/src \
 && chown -R jovyan:users /opt/src
USER $NB_UID
# ---------------------

# set Environment Variables
ENV XDG_CACHE_HOME=/home/$NB_USER/.cache/ \
    GDAL_DATA=/opt/conda/share/gdal \
    PROJ_LIB=/opt/conda/share/proj \
    GDAL_DRIVER_PATH=/opt/conda/lib/gdalplugins \
    CLAW=/opt/src/clawpack_src/clawpack-v5-9-0 \
    FC=gfortran \
    DATA=${HOME}/downloads \
    OAUTH=${HOME}/.hs_auth

# ------------------------- 
# Install NextGen
# ------------------------- 
USER root
ENV BOOST_ROOT="/opt/src/boost_1_72_0" \
    CXX=/usr/bin/g++ \
    NGEN_ROOT=/opt/src/ngen \
    PATH="/home/jovyan/ngen:${PATH}"

# Install Boost (NextGen Dep.)
RUN cd /opt/src \
 && curl -L -O https://boostorg.jfrog.io/artifactory/main/release/1.72.0/source/boost_1_72_0.tar.bz2 \
 && tar -xjf boost_1_72_0.tar.bz2 \
 && rm boost_1_72_0.tar.bz2

COPY --from=pythondeps /opt/conda/ /opt/conda


# Install T-Route
ARG REPO_URL=https://github.com/NOAA-OWP/ngen.git \
    TROUTE_REPO_URL=https://github.com/NOAA-OWP/t-route.git \
    TROUTE_BRANCH=master \
    TROUTE_COMMIT \
    TROUTE_PATH=/opt/src/t-route
RUN mkdir $TROUTE_PATH

RUN git clone --single-branch --branch $TROUTE_BRANCH $TROUTE_REPO_URL $TROUTE_PATH\
    && cd $TROUTE_PATH \
    && if [ "x$TROUTE_COMMIT" != "x" ]; then git checkout $TROUTE_COMMIT; fi \
    && git submodule update --init
WORKDIR $TROUTE_PATH


RUN mkdir wheels \
    && pip3 install -r ./requirements.txt \
    && pip3 install wheel deprecated dask pyarrow geopandas

RUN apt update \
 && apt install libnetcdff-dev -y

RUN export FC=gfortran NETCDF=/usr/include \
 && ./compiler.sh \
 && cd ./src/troute-network \
 && python3 setup.py --use-cython bdist_wheel \
 && cp dist/*.whl $TROUTE_PATH/wheels/ \
 && cd ../troute-routing \
 && python3 setup.py --use-cython bdist_wheel \
 && cp dist/*.whl $TROUTE_PATH/wheels/ \
 && cd ../troute-nwm \
 && python3 setup.py bdist_wheel \
 && cp dist/*.whl $TROUTE_PATH/wheels/

## I don't think this step is necessary but I also don't have time to check :( 
#RUN pip install t-route/wheels/*.whl
#RUN pip3 install /tmp/t-route-wheels/*.whl; \
#    pip3 install -r /tmp/t-route-requirements.txt; \
####    pip3 install deprecated geopandas \


RUN mkdir $NGEN_ROOT \
 && cd $NGEN_ROOT \
 && git clone https://github.com/NOAA-OWP/ngen.git . \
 && git submodule update --init --recursive -- test/googletest \
 && git submodule update --init --recursive --depth 1

WORKDIR ${NGEN_ROOT}
RUN pip install -r extern/test_bmi_py/requirements.txt; \
    pip install pyarrow pyproj fiona


#    VIRTUAL_ENV=/opt/conda/lib/python3.9
######RUN cd $NGEN_ROOT \
###### && cmake \
######    -DNGEN_ACTIVATE_PYTHON=YES -DPython_NumPy_INCLUDE_DIR=/opt/conda \
######    -B $NGEN_ROOT -S . \
###### && cmake --build $NGEN_ROOT --target ngen 

RUN echo "#!/bin/bash" > build_sub \
    && echo "cmake -B \$1/cmake_build -DCMAKE_BUILD_TYPE=${NGEN_BUILD_CONFIG_TYPE} -S \$1" >> build_sub \
    && echo "cmake --build \$1/cmake_build" >> build_sub \
    && chmod u+x build_sub 

RUN ./build_sub extern/iso_c_fortran_bmi
RUN ./build_sub extern/noah-owp-modular
RUN ./build_sub extern/cfe
RUN ./build_sub extern/evapotranspiration/evapotranspiration
RUN ./build_sub extern/topmodel
RUN ./build_sub extern/sloth

RUN apt update \
 && apt install libnetcdf-c++4-dev -y

RUN cmake -B cmake_build_serial -S . \
    -DMPI_ACTIVE:BOOL=OFF \
    -DNETCDF_ACTIVE:BOOL=OFF \
    -DBMI_C_LIB_ACTIVE:BOOL=ON \
    -DBMI_FORTRAN_ACTIVE:BOOL=ON \
    -DNGEN_ACTIVATE_PYTHON:BOOL=ON \
    -DNGEN_ACTIVATE_ROUTING:BOOL=ON \
    -DUDUNITS_ACTIVE:BOOL=ON \
    -DUDUNITS_QUIET:BOOL=ON \
    -DCMAKE_INSTALL_PREFIX=${WORKDIR} \
    -DNGEN_ACTIVATE_PYTHON=YES \
    -DPython_NumPy_INCLUDE_DIR=/opt/conda \
    cmake --build . --target all

#RUN cmake -B cmake_build_serial -S . \
#    -DMPI_ACTIVE:BOOL=OFF \
#    -DNETCDF_ACTIVE:BOOL=OFF \
#    -DBMI_C_LIB_ACTIVE:BOOL=ON \
#    -DBMI_FORTRAN_ACTIVE:BOOL=ON \
#    -DNGEN_ACTIVATE_PYTHON:BOOL=ON \
#    -DNGEN_ACTIVATE_ROUTING:BOOL=OFF \
#    -DUDUNITS_ACTIVE:BOOL=ON \
#    -DUDUNITS_QUIET:BOOL=ON \
#    -DCMAKE_INSTALL_PREFIX=${WORKDIR} \
#    -DNGEN_ACTIVATE_PYTHON=YES -DPython_NumPy_INCLUDE_DIR=/opt/conda \
#    -DNETCDF_INCLUDE_DIR=/usr/include \
#    -DNETCDF_LIBRARY=/usr/lib/x86_64-linux-gnu/libnetcdf.so \
#    -DNETCDF_CXX_INCLUDE_DIR=/usr/local/include \
#    -DNETCDF_CXX_LIBRARY=/usr/lib/x86_64-linux-gnu/libnetcdf_c++4.so
#
#ENV PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin

#RUN ./build_sub extern/test_bmi_cpp \
#  && ./build_sub extern/test_bmi_c \
#  && ./build_sub extern/test_bmi_fortran 
#

#  && cd cmake_build_serial
#  && cmake --build . --target all -j 4;

#ENV PATH=$PATH:/opt/src/ngen 




# Cannot get build to work with Python.
#    -DNGEN_ACTIVATE_PYTHON=YES \
#    -DPython_NumPy_INCLUDE_DIR=/opt/conda \


# && chmod +x /home/jovyan/ngen/ngen

# add example data to home folder
#RUN mv /home/jovyan/ngen/data $HOME/data
# ---------------------

