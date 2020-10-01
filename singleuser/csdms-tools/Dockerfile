ARG BASE_VERSION
FROM cuahsi/singleuser-base:$BASE_VERSION

USER $NB_UID

ENV XDG_CACHE_HOME /home/$NB_USER/.cache/

# pymt
RUN conda install -y -c conda-forge \
pymt==1.1.3 \
pymt_hydrotrend==0.1.2 \
hydrotrend==3.0.8 \
pymt_sedflux==0.1.3 \
sedflux==2.2.10 \
pymt_ecsimplesnow==0.2.5 \
pymt_gipl==0.1 \
pymt_rafem==0.1.4 \
&& conda clean --all -f -y

# prms
RUN conda install -y -c csdms-stack -c conda-forge \
pymt_prms_groundwater==0.1 \
pymt_prms_soil==0.1.2 \
pymt_prms_streamflow==0.1 \
pymt_prms_surface==0.1.2 \
&& conda clean --all -f -y

# other pkg
RUN conda install -y \
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
