FROM ubuntu:bionic


WORKDIR /tmp

RUN apt-get update \
&& apt-get install -y --no-install-recommends ca-certificates build-essential gfortran wget

RUN wget https://water.usgs.gov/software/HSPF/code/UNIX/hspf11.0.source.tar.gz

RUN tar -xf hspf11.0.source.tar.gz

RUN cd hspf11.0/src \
&&




