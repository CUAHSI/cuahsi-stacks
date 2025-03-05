
# derived from the minimal singleuser image 
# https://hub.docker.com/r/jupyterhub/singleuser/dockerfile
FROM jupyterhub/singleuser

MAINTAINER Tony Castronova <acastronova@cuahsi.org>

USER root

# install system libs
RUN apt-get update && apt-get install -y --no-install-recommends \
git \
vim \
ca-certificates \
build-essential \
gnupg \ 
wget \
libgdal-dev \
libmpich-dev \
&& rm -rf /var/lib/apt/lists/*

# install icommands
RUN wget -qO - https://packages.irods.org/irods-signing-key.asc | sudo apt-key add - \
&& echo "deb [arch=amd64] https://packages.irods.org/apt/ xenial main" | sudo tee /etc/apt/sources.list.d/renci-irods.list  \
&& apt-get update \
&& apt-get install -y irods-icommands

# install TauDEM
ARG TAG=v5.3.7
RUN git clone --branch $TAG https://github.com/dtarb/TauDEM.git /tmp/TauDEM \
&& cd /tmp/TauDEM/src \
&& sed -i 's#\.\.#/usr/local/bin#g' makefile \
&& make \
&& rm -rf /tmp/*

# install nbfetch
RUN pip install -U --no-cache-dir --upgrade-strategy only-if-needed git+https://github.com/hydroshare/nbfetch.git@v0.6.3 \
&& jupyter serverextension enable --py nbfetch --sys-prefix

USER jovyan

#----------------------------
#--- Install Jupyter Sync ---
#----------------------------
USER root
RUN apt update && apt install -y nodejs \
&& rm -rf /var/lib/apt/lists/* \
&& npm install -g yarn

USER jovyan

RUN cd /tmp \
&& git clone https://github.com/kylecombes/hydroshare_jupyter_sync.git \
&& cd /tmp/hydroshare_jupyter_sync/webapp \
&& yarn install \
&& yarn build \
&& cd /tmp/hydroshare_jupyter_sync/backend \
&& pip install -r requirements.txt \
&& echo "export PYTHONPATH=$PYTHONPATH:$(pwd)" >> ~/.bashrc 

# python setup.py install
# jupyter serverextension enable --py hydroshare_jupyter_sync --sys-prefix
# enter: user, pass

RUN rm -rf ~/work
