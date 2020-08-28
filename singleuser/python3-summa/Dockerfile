ARG BASE_VERSION
FROM cuahsi/singleuser-base:$BASE_VERSION

USER root
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
    ca-certificates \
    git \
    make \
    gfortran-6 \
    libnetcdff-dev \
    liblapack-dev \
    vim \
    && apt-get clean

ENV F_MASTER /code
ENV FC gfortran
ENV FC_EXE gfortran
ENV LIBRARIES='-L/usr/lib -lnetcdff -L/usr/lib/x86_64-linux-gnu -llapack -lblas'
ENV INCLUDES='-I/usr/include -I/usr/local/include'

# fetch tags and build summa
RUN git clone --single-branch --branch master https://github.com/NCAR/summa.git /code

# build the code
RUN cd /code/build \
&& git fetch --tags \
&& make \
&& mv /code/bin/summa.exe /usr/local/bin

# install pysumma
RUN git clone --single-branch --branch master https://github.com/UW-Hydro/pysumma.git /code/pysumma \
&& cd /code/pysumma \
&& git pull \
&& conda install numpy -y \
&& pip install .

# install system monitor
RUN pip install nbresuse==0.3.3 \
&& jupyter labextension install jupyterlab-topbar-extension jupyterlab-system-monitor

# conda installations
RUN conda install -y \
 descartes \
 && conda clean --all -f -y

# clean up
RUN rm -rf /code /home/jovyan/work
    
USER $NB_UID
