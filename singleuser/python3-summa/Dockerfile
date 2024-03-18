ARG BASE_VERSION
FROM cuahsi/singleuser-base:$BASE_VERSION

# BEGIN ROOT - ROOT - ROOT - ROOT
USER root
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
    ca-certificates \
    software-properties-common \
    git \
    #    make \
    #    gfortran \
    #    libgfortran4 \
    #    libnetcdff-dev \
    #    liblapack-dev \
    vim \
    && apt-get clean
#USER $NB_UID
# END ROOT - ROOT - ROOT - ROOT

# this is a conflict that prevents summa from installing via conda
RUN mamba remove libgfortran5 -y

RUN mamba install -c conda-forge -y \
    fiona \
    geopandas \
    cartopy \
    descartes \
    seaborn \
    pytest \

    "summa>=3.0.3" \
&& mamba clean --all -f -y
   # pyopenssl=23.0.0 \


##install pysumma
#ENV BRANCH="v3.0.3"
#RUN git clone --single-branch --branch $BRANCH https://github.com/UW-Hydro/pysumma.git /tmp/pysumma \
#&& cd /tmp/pysumma \
#&& git pull \
#&& pip install .

### installing metsim and rasterio via pip due to conda dep errors
##RUN pip install metsim rasterio
##
### BEGIN ROOT - ROOT - ROOT - ROOT
### clean up
##USER root
##RUN rm -rf /code /home/jovyan/work
##USER $NB_UID
### END ROOT - ROOT - ROOT - ROOT
