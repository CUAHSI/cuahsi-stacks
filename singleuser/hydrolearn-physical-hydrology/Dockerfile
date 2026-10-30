ARG BASE_VERSION

# Build the scientific image here
FROM cuahsi/singleuser-base:$BASE_VERSION

USER root
RUN apt-get update \
    && apt-get install -y --no-install-recommends \
    cmake \
    && rm -rf /var/lib/apt/lists/*

ARG TAG=Develop
ARG SHA="98137bb6541a0d0077a9c95becfed4e56d0aa0ac"
RUN git clone --depth=5 --branch $TAG https://github.com/dtarb/TauDEM.git /tmp/TauDEM \
    && cd /tmp/TauDEM \
    && git checkout $SHA \
    && mkdir -p /tmp/TauDEM/src/build \
    && cd /tmp/TauDEM/src/build \
    && cmake .. \
    && make \
    && mv /tmp/TauDEM/src/build/* /usr/local/bin \
    && rm -rf /tmp/TauDEM
USER $NB_UID


ENV XDG_CACHE_HOME /home/$NB_USER/.cache/
#ENV GDAL_DATA=/opt/conda/share/gdal
#ENV PROJ_LIB=/opt/conda/share/proj

#RUN > /opt/conda/conda-meta/pinned # clear conda pins
COPY --chown=$NB_UID:$NB_UID environment.yaml /tmp/environment.yaml
RUN mamba env create --file /tmp/environment.yaml \
    && mamba clean -afy

# Import matplotlib the first time to build the font cache.
RUN MPLBACKEND=Agg python -c "import matplotlib.pyplot" \
    && fix-permissions /home/$NB_USER

RUN rm -rf XDG_CACHE_HOME/*

# add the modified start-singleuser script
USER root
COPY start-singleuser.sh /usr/local/bin/start-singleuser.sh
RUN chmod +x /usr/local/bin/start-singleuser.sh
USER $NB_UID
