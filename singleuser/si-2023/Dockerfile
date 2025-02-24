
FROM cuahsi/si-python-deps:latest as pythondeps
FROM cuahsi/singleuser-si:ngen as ngen
FROM cuahsi/si-swmm:latest as swmm
FROM jupyterhub/singleuser:4.0


LABEL maintainer="Tony Castronova <acastronova@cuahsi.org>"


# ----------------------
# Linux System Libraries
# ----------------------
USER root
RUN export DEBIAN_FRONTEND=noninteractive \
  && apt update && apt install -y --no-install-recommends \
  git \
  vim \
  nano \
  ca-certificates \
  build-essential \
  gnupg \ 
  wget \
  libgdal-dev \
  libmpich-dev \
  zip \ 
  unzip \
  p7zip-full \
  texlive-xetex \
  texlive-latex-recommended \
  htop \
  libnetcdff-dev \
  curl \
  gfortran \
# NextGen System Dependencies
  tar \
  g++ \
  gcc \
  make \
  cmake \
  bzip2 \
  libudunits2-dev \
  texinfo \
  && rm -rf /var/lib/apt/lists/*
USER $NB_UID
# ---------------------


# ---------------------
# Directory Setup
# ---------------------
# set the home dir
ENV HOME=/home/$NB_USER

# set the default terminal start path to $HOME
RUN echo 'cd $HOME' >> .profile

# remove work dir b/c we're using "data"
RUN rm -rf ~/work

# create directory for compiled code
USER root
RUN mkdir /opt/src \
 && chown -R jovyan:users /opt/src
USER $NB_UID

# set Environment Variables
ENV XDG_CACHE_HOME=/home/$NB_USER/.cache/ \
    GDAL_DATA=/opt/conda/share/gdal \
    PROJ_LIB=/opt/conda/share/proj \
    GDAL_DRIVER_PATH=/opt/conda/lib/gdalplugins \
    CLAW=/opt/src/clawpack_src/clawpack-v5-9-0 \
    FC=gfortran \
    DATA=${HOME}/downloads \
    OAUTH=${HOME}/.hs_auth
# ---------------------


# ---------------------
# Python Deps - MultiStage
# ---------------------
COPY --from=pythondeps /opt/conda/ /opt/conda
COPY --from=pythondeps /opt/src/clawpack_src /opt/src/clawpack_src

# Import matplotlib the first time to build the font cache.
RUN MPLBACKEND=Agg python -c "import matplotlib.pyplot" && \
    fix-permissions /home/$NB_USER
# ---------------------


# ---------------------
# CLAWPACK
# ---------------------

# register clawpack
RUN cd $CLAW \
 && pip install -e .
# ---------------------

# ------------------------- 
# NextGen
# ------------------------- 
COPY --from=ngen /opt/src/ngen/ngen /usr/local/bin/ngen
ENV VIRTUAL_ENV=/opt/conda/lib/python3.9
# ---------------------



# ---------------------
# SWMM5 Installation
# ---------------------
COPY --from=swmm /opt/source51013/swmm5 /usr/local/bin/swmm5
ENV PATH=$PATH:/opt/src/swmm

# ---------------------
# EISALAB/GB-RFSM
# ---------------------
RUN git clone https://github.com/EISALab/GB-RFSM.git /opt/src/GB-RFSM
ENV PYTHONPATH=$PYTHONPATH:/opt/src/GB-RFSM


# ----------------------------------
# JupyterLab Extension Configuration
# ----------------------------------
# Dask Server Extension Configuration
# https://github.com/dask/dask-labextension/issues/109 
ENV DASK_DISTRIBUTED__DASHBOARD__LINK="proxy/{port}/status"

RUN jupyter server extension enable --py nbfetch --sys-prefix

# install and configure hydroshare on jupyter
# RUN pip install git+https://github.com/hydroshare/hydroshare_on_jupyter.git@0.2.1 && \
#   python -m hydroshare_on_jupyter configure
# ----------------------------------


# ---------------------
# Jupyter Desktop
# ---------------------
# https://github.com/yuvipanda/jupyter-desktop-server/tree/master
USER root
RUN apt-get -y update \
 && apt-get install -y dbus-x11 \
   firefox \
   xfce4 \
   xfce4-panel \
   xfce4-session \
   xfce4-settings \
   xorg \
   xubuntu-icon-theme

# Remove light-locker to prevent screen lock
ARG TURBOVNC_VERSION=2.2.6
RUN wget -q "https://sourceforge.net/projects/turbovnc/files/${TURBOVNC_VERSION}/turbovnc_${TURBOVNC_VERSION}_amd64.deb/download" -O turbovnc_${TURBOVNC_VERSION}_amd64.deb && \
   apt-get install -y -q ./turbovnc_${TURBOVNC_VERSION}_amd64.deb && \
   apt-get remove -y -q light-locker && \
   rm ./turbovnc_${TURBOVNC_VERSION}_amd64.deb && \
   ln -s /opt/TurboVNC/bin/* /usr/local/bin/

# apt-get may result in root-owned directories/files under $HOME
RUN chown -R $NB_UID:$NB_GID $HOME
USER $NB_UID

RUN git clone https://github.com/yuvipanda/jupyter-desktop-server.git /opt/src/jupyter-desktop-server \
 && cd /opt/src/jupyter-desktop-server \
 && mamba env update -n base --file environment.yml
## ---------------------


# ---------------------
# HEC-RAS 6.10
# ---------------------
USER root
RUN mkdir /opt/src/hecras \
 && chown -R jovyan:users /opt/src/hecras
USER $NB_UID

RUN cd /opt/src/hecras \
 && wget https://www.hec.usace.army.mil/software/hec-ras/downloads/HEC-RAS_610_Linux.zip \
 && unzip HEC-RAS_610_Linux.zip \
 && cd HEC-RAS_610_Linux \
 && unzip RAS_Linux_test_setup.zip \
 && chmod +x /opt/src/hecras/HEC-RAS_610_Linux/RAS_Linux_test_setup/Ras_v61/Release/*
 
ENV LD_LIBRARY_PATH=$LD_LIBRARY_PATH:/opt/src/hecras/HEC-RAS_610_Linux/RAS_Linux_test_setup/libs:/opt/src/hecras/HEC-RAS_610_Linux/RAS_Linux_test_setup/libs/mkl:/opt/src/hecras/HEC-RAS_610_Linux/RAS_Linux_test_setup/libs/rhel_8 \
    PATH=$PATH:/opt/src/hecras/HEC-RAS_610_Linux/RAS_Linux_test_setup/Ras_v61/Release
# ---------------------


# ---------------------
# Cleaning
# ---------------------
USER $NB_UID
WORKDIR /home/$NB_USER/data 

# clean cache files
RUN rm -rf XDG_CACHE_HOME/*
RUN conda config --append envs_dirs /home/jovyan/data/conda-envs



# Extra Libs
RUN mamba install -y \
   --channel conda-forge \
   --channel anaconda \
   s3fs \
   sidecar \
   zarr \
   s3fs \
   kerchunk \
   && mamba clean --all -f -y

RUN pip install jupyterhub==3.1.1


# -------------------------
# NextGen Fixes
# -------------------------
USER root
RUN rm -rf /opt/src/ngen \
    rm -rf /opt/src/hecras

COPY ngen/ngen /usr/local/bin/ngen
COPY ngen/shared /opt/shared
COPY ngen/troute/wheels /opt/troute

RUN chmod +x /usr/local/bin/ngen

ENV LD_LIBRARY_PATH=/opt/shared
USER $NB_UID

RUN pip install /opt/troute/*.whl
