FROM jupyter/scipy-notebook:1145fb1198b2

MAINTAINER Tony Castronova <acastronova@cuahsi.org>

EXPOSE 8888
USER jovyan

ENV PATH="/home/jovyan/libs:/home/jovyan/libs/icommands":$PATH \
#    PYTHONPATH="/home/jovyan/work/notebooks:/home/jovyan/libs":$PYTHONPATH \
#    DOCUMENTS="/home/jovyan/work/notebooks/documents" \
#    DATA="/home/jovyan/work/notebooks/data" \
#    HOME="/home/jovyan/work" \
#    NOTEBOOK_HOME="/home/jovyan/work/notebooks" \
    IRODS_PLUGINS_HOME="/home/jovyan/libs/icommands/plugins/" \
    IRODS_ENVIRONMENT_FILE="/home/jovyan/work/notebooks/data/.irods/irods_environment.json" \
    IRODS_AUTHENTICATION_FILE="/home/jovyan/work/notebooks/data/.irods/.irodsA" 

WORKDIR $HOME


############################
# ROOT - INSTALL LIBRARIES #
############################
USER root
RUN apt-get update \
&& apt-get install -y software-properties-common \
&& add-apt-repository -y ppa:ubuntugis/ubuntugis-unstable 

RUN apt-get update \
&& apt-get install --fix-missing -y --no-install-recommends \
ca-certificates \
libtool \
libgeos-dev \
libproj-dev \
git \
subversion \
p7zip-full \
python \
python-dev \
python-pip \
python-scipy \
libxml2-dev \
libxslt-dev \
libgdal-dev \
gdal-bin \
python-gdal \
libgdal-dev \
libbsd-dev \
libx11-dev \
man-db \
wget \
bash-completion \
libdb-dev \
build-essential \
autoconf \
automake \
libmpich-dev \
libssl1.0.0 \
&& apt-get clean \
&& rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/

ADD icommands.sh /tmp/icommands.sh 
RUN chmod +x /tmp/icommands.sh \
&& echo "/usr/local/bin" | /tmp/icommands.sh \
&& rm -rf /tmp/*

## create directories
#RUN mkdir /home/jovyan/libs \
#&& mkdir /home/jovyan/work/notebooks \
#&& chown -R jovyan:users /home/jovyan/work/notebooks

RUN git clone --branch Develop https://github.com/dtarb/TauDEM.git /tmp/TauDEM \
&& cd /tmp/TauDEM \
&& git checkout f318428 \
&& cd /tmp/TauDEM/src \
&& sed -i 's#\.\.#/usr/local/bin#g' makefile \
&& make \
&& rm -rf /tmp/*

ADD singleuser.sh /srv/singleuser/singleuser.sh
RUN chmod 755 /srv/singleuser/singleuser.sh

USER jovyan 
CMD ["sh", "/srv/singleuser/singleuser.sh"]
