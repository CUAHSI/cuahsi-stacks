FROM ubuntu:xenial

ADD modflow.6.0.2-makefile-ubuntu /tmp/makefile

RUN apt-get update \
&& buildDeps='wget unzip ca-certificates build-essential gcc g++ gfortran' \
&& apt-get install -y --no-install-recommends $buildDeps 

RUN cd /tmp \
&& wget https://water.usgs.gov/ogw/modflow/mf6.0.2.zip \
&& unzip -x mf6.0.2.zip \
&& cp /tmp/makefile /tmp/mf6.0.2/make \
&& cd /tmp/mf6.0.2/make \
&& make \
&& cp /tmp/mf6.0.2/make/mf6.0.2 /usr/local/bin/mf6.0.2

## install mplleaf
#conda install -n root -y mplleaflet
#
## install FloPy from the development branch
#/opt/conda/bin/pip install git+https://github.com/modflowpy/flopy.git




##&& rm -rf /tmp/* \
##&& rm -rf /var/lib/apt/lists/* \
##&& apt-get purge -y --auto-remove $buildDeps
#
#
##&& apt-get purge -y --auto-remove $buildDeps \
##&& apt-get clean \
##&& rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/
#
ENTRYPOINT ["mf6.0.2"]

