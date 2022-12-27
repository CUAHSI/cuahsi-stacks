ARG BASE_VERSION
FROM cuahsi/singleuser-base:$BASE_VERSION

USER $NB_UID

ENV XDG_CACHE_HOME /home/$NB_USER/.cache/

# pymt
RUN mamba install -y -c conda-forge \
pymt==1.3.1 \
child \
pymt_child \
hydrotrend \
pymt_hydrotrend \
pymt_sedflux \
sedflux \
pymt_ecsimplesnow \
pymt_gipl \
pymt_rafem \
&& conda clean --all -f -y


# prms
RUN mamba install -y -c csdms-stack -c conda-forge \
pymt_prms_groundwater \
pymt_prms_soil \
pymt_prms_streamflow \
pymt_prms_surface \
&& conda clean --all -f -y


# other pkg
RUN mamba install -y -c conda-forge \
descartes \
&& conda clean --all -f -y


RUN mamba install -y \
requests \
geopandas \
seaborn \
matplotlib \
rasterio \
dask \
holoviews \
ffmpeg \
imagemagick \
&& conda clean --all -f -y


USER root
# Set GDAL and Proj env vars. This is necessary to ensure gdal commands don't error out when the base
# conda environment is not explicitly activated.
# see https://gis.stackexchange.com/questions/326968/ogr2ogr-error-1-proj-pj-obj-create-cannot-find-proj-db
ENV GDAL_DATA=/opt/conda/share/gdal \
    PROJ_LIB=/opt/conda/share/proj

RUN rm -rf XDG_CACHE_HOME/* \
USER $NB_UID
