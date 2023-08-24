ARG BASE_VERSION

# Build the scientific image here
FROM cuahsi/singleuser-base:$BASE_VERSION

ENV XDG_CACHE_HOME /home/$NB_USER/.cache/
ENV GDAL_DATA=/opt/conda/share/gdal
ENV PROJ_LIB=/opt/conda/share/proj

COPY --chown=$NB_UID:$NB_UID environment.yaml /tmp/environment.yaml
RUN mamba env update -n base --file /tmp/environment.yaml \
    && mamba clean -afy

# Import matplotlib the first time to build the font cache.
RUN MPLBACKEND=Agg python -c "import matplotlib.pyplot" && \
    fix-permissions /home/$NB_USER

COPY --chown=$NB_UID:$NB_UID requirements.txt /tmp/requirements.txt
RUN pip install -r /tmp/requirements.txt

RUN rm -rf XDG_CACHE_HOME/*
USER $NB_UID
