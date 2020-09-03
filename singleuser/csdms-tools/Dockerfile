ARG BASE_VERSION
FROM cuahsi/singleuser-base:$BASE_VERSION

USER $NB_UID

ENV XDG_CACHE_HOME /home/$NB_USER/.cache/


RUN conda install -y \
# pymt
pymt \
pymt_ecsimplesnow \
pymt_gipl \
pymt_rafem \
# others
requests \
geopandas \
seaborn \
matplotlib \
rasterio \
ffmpeg \
&& conda clean --all -f -y

# prms
RUN conda install -y -c csdms-stack -c conda-forge \
pymt_prms_groundwater \
pymt_prms_soil \
pymt_prms_streamflow \
pymt_prms_surface \
&& conda clean --all -f -y


USER root
# Set GDAL and Proj env vars. This is necessary to ensure gdal commands don't error out when the base
# conda environment is not explicitly activated.
# see https://gis.stackexchange.com/questions/326968/ogr2ogr-error-1-proj-pj-obj-create-cannot-find-proj-db
ENV GDAL_DATA=/opt/conda/share/gdal \
    PROJ_LIB=/opt/conda/share/proj

# install system monitor
RUN pip install nbresuse==0.3.3 \
&& jupyter labextension install jupyterlab-topbar-extension jupyterlab-system-monitor

RUN rm -rf XDG_CACHE_HOME/* \
USER $NB_UID

