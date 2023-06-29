ARG BASE_VERSION
FROM cuahsi/singleuser-base:$BASE_VERSION

USER $NB_UID

ENV XDG_CACHE_HOME /home/$NB_USER/.cache/
# test

# pymt
RUN mamba install -y \
--channel conda-forge \
numpy==1.23.5 \
pymt==1.3.1 \
landlab==2.5.0 \
child==21.03.12 \
pymt_child==0.2.1 \
hydrotrend==3.1.4 \
pymt_hydrotrend==0.2.2 \
pymt_sedflux==0.2.0 \
sedflux==2.3.1 \
pymt_ecsimplesnow==0.2.6 \
pymt_gipl==0.1.1 \
pymt_rafem==0.1.4 \
&& mamba clean --all -f -y

# upgrade pyopenssl to fix an issue that is preventing
# nbfetch from loading correctly.
RUN mamba upgrade pyopenssl -y


# data component
RUN mamba install -y \
--channel conda-forge \
pymt_topography==0.1 \
pymt_nwis==0.2 \
pymt_era5==0.1 \
pymt_soilgrids==0.1.2 \
pymt_geotiff==0.2 \
bmi-wavewatch3==0.2 \
&& mamba clean --all -f -y

RUN pip install git+https://github.com/pymt-lab/pymt_wavewatch3.git

# other pkg
RUN mamba install -y \
--channel conda-forge \
descartes \
&& mamba clean --all -f -y


RUN mamba install -y \
geopandas \
seaborn \
matplotlib \
rasterio \
dask \
holoviews \
ffmpeg \
imagemagick \
rioxarray \
imageio>=2.19.1 \
xesmf \
cdsapi \
windrose \
&& mamba clean --all -f -y

RUN pip install imageio_ffmpeg

USER root
# Set GDAL and Proj env vars. This is necessary to ensure gdal commands don't error out when the base
# conda environment is not explicitly activated.
# see https://gis.stackexchange.com/questions/326968/ogr2ogr-error-1-proj-pj-obj-create-cannot-find-proj-db
ENV GDAL_DATA=/opt/conda/share/gdal \
    PROJ_LIB=/opt/conda/share/proj


RUN rm -rf XDG_CACHE_HOME/* \
USER $NB_UID
