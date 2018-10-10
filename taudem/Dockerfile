FROM ubuntu:xenial


RUN apt-get update \
&& buildDeps='git libmpich-dev ca-certificates build-essential' \
&& apt-get install -y --no-install-recommends $buildDeps

RUN git clone --branch Develop https://github.com/dtarb/TauDEM.git /tmp/TauDEM \
&& cd /tmp/TauDEM \
&& git checkout tags/v5.3.7

RUN apt-get install -y libgdal-dev

RUN cd /tmp/TauDEM/src \
&& sed -i 's#\.\.#/usr/local/bin#g' makefile \
&& make  

#&& apt-get purge -y --auto-remove $buildDeps \
#&& apt-get clean \
#&& rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/

ENTRYPOINT ["/bin/bash"]
