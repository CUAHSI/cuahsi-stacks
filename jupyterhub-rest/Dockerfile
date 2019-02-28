FROM ubuntu:bionic

MAINTAINER Tony Castronova <acastronova@cuahsi.org>

ENV JH_BRANCH=develop

RUN apt-get update \
&& apt-get install --fix-missing -y --no-install-recommends \
 git \
 vim \
 ca-certificates \
 python3 \
 python3-pip

RUN pip3 install setuptools wheel

RUN cd /srv \
&& git clone -b $JH_BRANCH https://github.com/hydroshare/hydroshare-jupyterhub.git  \
&& cd hydroshare-jupyterhub \
&& git pull \
&& pip3 install -e jupyterhub_rest_server

RUN mkdir /app
WORKDIR /app 
ADD start.py /app/start.py

ENTRYPOINT python3 start.py


