# this is the fixed NGEN image 
FROM cuahsi/singleuser-si:2023.06.21


# ----------------------
# Linux System Libraries
# ----------------------
USER root
RUN export DEBIAN_FRONTEND=noninteractive \
  && apt update && apt install -y --no-install-recommends \
  mpich \
  libgtest-dev \
  libboost-test-dev \
  p7zip-full \
  time \
  parallel \
  expect \
  tmux \
  rsync \
  tzdata \
  && rm -rf /var/lib/apt/lists/*
# ---------------------

# create directory for compiled code
RUN mkdir /opt/src/taudem \
 && mkdir /opt/src/taudem_accelerated_flowDirections \
 && chown -R jovyan:users /opt/src
USER $NB_UID


# clone taudem, taudem-test-data, and cybergis-toolkit
RUN git clone https://github.com/dtarb/taudem.git /opt/src/taudem 
RUN git clone https://github.com/fernandoa123/cybergis-toolkit.git /opt/src/taudem_accelerated_flowDirections

# remove conda install libgdal because this will cause
# taudem builds to fail
RUN mamba remove -y libgdal


# Compile Main taudem repo 
ARG taudemVersion=98137bb6541a0d0077a9c95becfed4e56d0aa0ac
RUN cd /opt/src/taudem \
 && git checkout $taudemVersion \
 && mkdir bin \
 && cd src && make


# Compile taudem repo with accelerated flow directions 
ARG taudemVersion2=81f7a07cdd3721617a30ee4e087804fddbcffa88
RUN cd /opt/src/taudem_accelerated_flowDirections/taudem \
 && git checkout $taudemVersion2 \
 && mkdir build \
 && cd build \
 && cmake .. \
 && make

USER root
RUN cd /opt/src/taudem/bin \
 && mv -t /usr/local/bin \
	flowdircond \
	aread8 \
	threshold \
	streamnet \
	gagewatershed \
	catchhydrogeo \
	dinfdistdown \
 && cd /opt/src/taudem_accelerated_flowDirections/taudem/build/bin \
 && mv -t /usr/local/bin \
	d8flowdir \
	dinfflowdir \
 && rm -rf /opt/src/taudem /opt/src/taudem_accelerated_flowDirections

# adding AWS CLI (for bash)
RUN curl https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip \
    -o /opt/src/awscliv2.zip \
 && cd /opt/src \
 && unzip awscliv2.zip \
 && ./aws/install \
 && rm -rf /opt/src/aws /opt/src/awscliv2.zip

USER $NB_UID

# add python dependencies for noaa-owp/inundation-mapping
COPY --chown=$NB_UID:$NB_UID environment.yaml /tmp/environment.yaml
RUN mamba env update -n base --file /tmp/environment.yaml \
 && mamba clean -afy

RUN git clone https://github.com/NOAA-OWP/inundation-mapping.git /opt/src/inundation-mapping

# set up whitebox as per the instructions provided in
# https://github.com/NOAA-OWP/inundation-mapping/blob/dev/Dockerfile 
RUN wbox_path=/opt/conda/lib/python3.9/site-packages/whitebox/ && \
    wget -P $wbox_path https://www.whiteboxgeo.com/WBT_Linux/WhiteboxTools_linux_musl.zip && \
    unzip -o $wbox_path/WhiteboxTools_linux_musl.zip -d $wbox_path && \
    cp $wbox_path/WBT/whitebox_tools $wbox_path && \
    mkdir $wbox_path/testdata
    
# Add inundation-mapping dirs to the PATH and
# environment variables for numba and python
ENV PATH=/opt/src/inundation-mapping:$PATH \
    PYTHONPATH=$PYTHONPATH:/opt/src/inundation-mapping/src:/opt/src/inundation-mapping/tests:/opt/src/inundation-mapping/tools \
    LC_ALL=C.UTF-8 \
    LANG=C.UTF-8 \
    PYTHONUNBUFFERED=TRUE \
    inputsDIR=/home/jovyan/data/shared-data/fim-data
