#!/bin/bash
set -x
set -e

############################
# ROOT - INSTALL LIBRARIES #
############################
apt update
apt-get install -y software-properties-common
add-apt-repository -y ppa:ubuntugis/ubuntugis-unstable
add-apt-repository -y ppa:ubuntu-toolchain-r/test

apt-get update && apt-get install --fix-missing -y --no-install-recommends \
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
  libbsd-dev \
  libx11-dev \
  man-db \
  wget \
  bash-completion \
  libdb-dev \
  && apt-get clean \
  && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/


#  grass \
#  grass-dev \
#  vlc  \
# gcc-7 \
#  g++-7 \
#  build-essential \
#  autoconf \
#  automake \

###################################
#          SYSTEM PREP            #
###################################

# create directories
mkdir /home/jovyan/libs
mkdir /home/jovyan/work/notebooks 
chown -R jovyan:users /home/jovyan/libs 
chown -R jovyan:users /home/jovyan/work/notebooks

# fetch juptyerhub-singleuser entrypoint
chmod 755 /srv/singleuser/singleuser.sh
