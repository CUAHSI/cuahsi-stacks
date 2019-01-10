FROM bitnami/minideb:latest
MAINTAINER Tony Castronova <acastronova@cuahsi.org>

# Author: Tony Castronova
# Organization: CUAHSI
# Date: 01.04.2019
# Notes:
# - uses bitnami/minideb to reduce image size


RUN install_packages \
make \
gfortran \
git \
vim \
python3 \ 
python3-pip \
python3-dev

WORKDIR /tmp

RUN pip3 install numpy scipy matplotlib 

RUN git clone  https://github.com/djlampert/PyHSPF.git && \
cd PyHSPF/src && \
python3 setup.py config --fcompiler=gfortran build --compiler=unix && \\
rm setup.cfg && \
echo "[build_ext]\ncompiler=unix" >> setup.cfg && \
python3 setup.py install && \
mv /tmp/PyHSPF/examples /home

RUN rm -rf /tmp/*

RUN apt-get autoremove -y make gfortran git

ENTRYPOINT ["/bin/bash"]


