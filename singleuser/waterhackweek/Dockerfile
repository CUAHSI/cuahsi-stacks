ARG BASE_VERSION
FROM cuahsi/singleuser-scientific-py3:$BASE_VERSION

USER $NB_UID

ENV XDG_CACHE_HOME /home/$NB_USER/.cache/

# WHW Dependencies
RUN conda install -y \
python=3.6 \
ipython \
ipykernel \
requests \
geopandas \
descartes \
geojson \
rasterio \
netcdf4 \
xarray \
dask \
ulmo \
owslib \
matplotlib \
seaborn \
cartopy \
folium \
xlrd \
&& conda clean --all -f -y


USER root
RUN rm -rf XDG_CACHE_HOME/* \
USER $NB_UID

