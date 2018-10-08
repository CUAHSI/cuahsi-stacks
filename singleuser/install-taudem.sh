#!/bin/bash
set -x
set -e

apt update \
  && buildDeps='libmpich-dev' \
  && apt install -y --no-install-recommends $buildDeps \
  && git clone --branch Develop https://github.com/dtarb/TauDEM.git /tmp/TauDEM \
  && cd /tmp/TauDEM \
  && git checkout bceeef2f6a399aa23749a7c7cae7fed521ea910f \
  && cd /tmp/TauDEM/src \
  && sed -i 's#\.\.#/usr/local/bin#g' makefile \
  && make  \
  && apt-get purge -y --auto-remove $buildDeps \
  && apt-get clean \
  && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/
