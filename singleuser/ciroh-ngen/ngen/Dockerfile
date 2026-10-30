FROM ubuntu:22.04 

ENV FC=gfortran
ENV NETCDF=/usr/include
ENV TROUTE_PATH=/opt/src/ngen/T-Route
ENV NGEN_ROOT=/opt/src/ngen

USER root
RUN apt update \
 && apt install -y \
 build-essential \
 git \
 curl \
 python3.11 \
 python3-pip \
 python3-setuptools \
 python3-wheel \
 cmake \
 gcc \
 g++ \
 libudunits2-dev \
 gfortran \
 libnetcdff-dev

RUN ln -sf /usr/bin/python3 /usr/bin/python

RUN pip install \
 "numpy<2.0" \
  pandas \
  pyyaml \
  bmipy \
  fiona

RUN pip install --upgrade pip


## are these envs even used?
#ENV BOOST_ROOT="/boost_1_79_0"
#ENV CXX="/usr/bin/g++"
#ENV CC="/usr/bin/gcc"
#
# create a dir for compiling ngen
RUN mkdir /opt/src 

RUN git clone https://github.com/NOAA-OWP/ngen.git /opt/src/ngen

WORKDIR /opt/src/ngen

RUN git submodule update --init --recursive -- test/googletest 
RUN git submodule update --init --recursive -- extern/pybind11

# get Boost
RUN curl -L -o boost_1_79_0.tar.bz2 https://sourceforge.net/projects/boost/files/boost/1.79.0/boost_1_79_0.tar.bz2/download \
    && tar -xjf boost_1_79_0.tar.bz2 \
    && rm boost_1_79_0.tar.bz2

# TROUTE
RUN pip install pandas xarray netcdf4 joblib toolz pyyaml Cython>3,!=3.0.4 geopandas pyarrow deprecated wheel
RUN git clone --progress --single-branch --branch master http://github.com/NOAA-OWP/T-Route.git
WORKDIR /opt/src/ngen/T-Route
RUN git submodule update --init --depth 1 


RUN mkdir $TROUTE_PATH/wheels

# compile the core t-route code
RUN sed -i 's/build_[a-z]*=/#&/' compiler.sh
RUN bash compiler.sh

# compile the individual components
RUN cd $TROUTE_PATH/src/troute-network \
 && python setup.py --use-cython bdist_wheel  \
 && cp dist/*.whl $TROUTE_PATH/wheels/ \
 && pip install dist/*.whl

RUN cd $TROUTE_PATH/src/troute-routing \
 && python setup.py --use-cython bdist_wheel \
 && cp dist/*.whl $TROUTE_PATH/wheels/ \
 && pip install dist/*.whl

RUN cd $TROUTE_PATH/src/troute-config \
 && pip wheel . -w wheels/ \
 && cp wheels/*.whl $TROUTE_PATH/wheels/ 
 
RUN cd $TROUTE_PATH/src/troute-nwm \
 && pip wheel . -w wheels/ \
 && cp wheels/*.whl $TROUTE_PATH/wheels/ 

WORKDIR $NGEN_ROOT

RUN cmake \
  -DCMAKE_CXX_COMPILER=/usr/bin/g++ \
  -DCMAKE_C_COMPILER=/usr/bin/gcc \
  -DBOOST_ROOT=boost_1_79_0 \
  -B build \
  -S .

RUN cmake --build build --target ngen
RUN cmake --build build --target test_all




