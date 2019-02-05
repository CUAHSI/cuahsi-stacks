FROM jupyterhub/jupyterhub:0.9.4
MAINTAINER Tony Castronova <acastronova@cuahsi.org>


ENV PATH=/opt/conda/bin:$PATH

RUN apt-get update \
&& apt-get install --fix-missing -y --no-install-recommends wget git \
&& /opt/conda/bin/conda install -yq psycopg2=2.7 \
&& /opt/conda/bin/conda clean -tipsy 

RUN cd /srv \
&& git clone -b master https://github.com/hydroshare/dockerspawner.git \
&& pip install -e dockerspawner

RUN cd /srv \
&& git clone -b master https://github.com/hydroshare/oauthenticator.git \
&& pip install -e oauthenticator 

# required only for the utilities.py file
RUN git clone -b develop https://github.com/hydroshare/hydroshare-jupyterhub.git \
&& cd hydroshare-jupyterhub \
&& pip install -e jupyterhub_rest_server

RUN cd /tmp \
&& wget https://download.docker.com/linux/static/stable/x86_64/docker-17.09.0-ce.tgz \
&& tar -xf docker-17.09.0-ce.tgz \
&& cp /tmp/docker/docker /usr/bin/docker

RUN apt-get autoremove -y wget git \
&& rm -rf /tmp/* \
&& rm -rf /var/lib/apt/lists/*

RUN conda install -y tornado=5

ADD cull_idle_servers.py /srv/cull_idle_servers.py
