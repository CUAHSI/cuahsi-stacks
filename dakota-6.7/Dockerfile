FROM ubuntu:xenial


#RUN apt-get install -y --no-install-recommends mpich
# build mpich from source
RUN apt-get update \
&& apt-get install -y git build-essential autoconf libtool gfortran \
&& git clone git://git.mpich.org/mpich.git /tmp/mpich \
&& cd /tmp/mpich \
&& git submodule update --init \
&& ./autogen.sh \
&& ./configure --prefix=/usr \
&& make -j8 \
&& make -j8 install \
&& rm -rf /tmp/*

RUN apt-get update \
&& buildDeps='wget ca-certificates build-essential gcc g++ python3-dev liblapack-dev cmake libboost-all-dev' \
&& apt-get install -y --no-install-recommends $buildDeps 

RUN dakota=dakota-6.7-release-public-src.tar.gz \
&& wget https://dakota.sandia.gov/sites/default/files/distributions/public/$dakota -P /tmp \
&& mkdir /tmp/dakota && tar xfz /tmp/$dakota -C /tmp/dakota --strip-components 1 \
&& ldconfig \
&& mkdir -p /tmp/dakota/build \
&& cd /tmp/dakota/build 

ADD dakota_template.cmake /tmp/dakota/build/BuildDakota.cmake

#RUN cp /tmp/dakota/build/build/BuildDakota.cmake . \
RUN cd /tmp/dakota/build \
&& cmake -DPYTHON_EXECUTABLE:FILEPATH=/usr/bin/python -C BuildDakota.cmake /tmp/dakota \
&& make clean

RUN apt-get install -y gfortran
 
RUN cd /tmp/dakota/build \
&& make  \
&& make install 
##&& rm -rf /tmp/* \
##&& rm -rf /var/lib/apt/lists/* \
##&& apt-get purge -y --auto-remove $buildDeps
#
#
##&& apt-get purge -y --auto-remove $buildDeps \
##&& apt-get clean \
##&& rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/
#
ENTRYPOINT ["/bin/bash"]
