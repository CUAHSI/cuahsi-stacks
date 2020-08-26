ARG BASE_VERSION
FROM cuahsi/singleuser-base:$BASE_VERSION

USER root

# install system libs
RUN export DEBIAN_FRONTEND=noninteractive \
&& apt-get update && apt-get install -y --no-install-recommends \
mpich \
cmake \ 
&& rm -rf /var/lib/apt/lists/*

USER $NB_UID

ENV XDG_CACHE_HOME /home/$NB_USER/.cache/

# WHW Dependencies
RUN conda create -n whw -y \
python \
ipython \
ipykernel \
nb_conda_kernels \
requests \
geopandas \
descartes \
geojson \
rasterio \
netcdf4 \
xarray \
rioxarray \
regionmask \
dask \
ulmo \
hydrodata \
owslib \
boto3 \
s3fs \
zarr \
matplotlib \
seaborn \
cartopy \
folium \
contextily \
xlrd \
&& conda clean --all -f -y

RUN pip install "jupyterlab>=1.0" jupyterlab-dash==0.1.0a3
RUN jupyter labextension install @jupyter-widgets/jupyterlab-manager
RUN jupyter labextension install @bokeh/jupyter_bokeh

# remove nbserverproxy
RUN jupyter serverextension disable nbserverproxy \
&& pip install nbserverproxy 

# install jupyter-server-proxy
RUN conda install jupyter-server-proxy -c conda-forge -y
RUN jupyter labextension install @jupyterlab/server-proxy
RUN jupyter serverextension enable --sys-prefix jupyter_server_proxy

USER root
# install TauDEM
ARG TAG=Develop
RUN git clone --depth=1 --branch $TAG https://github.com/dtarb/TauDEM.git /tmp/TauDEM \
&& mkdir -p /tmp/TauDEM/src/build \
&& cd /tmp/TauDEM/src/build \
&& cmake .. \
&& make \
&& mv /tmp/TauDEM/src/build/* /usr/local/bin \
&& rm -rf /tmp/TauDEM

# Set GDAL and Proj env vars. This is necessary to ensure gdal commands don't error out when the base
# conda environment is not explicitly activated.
# see https://gis.stackexchange.com/questions/326968/ogr2ogr-error-1-proj-pj-obj-create-cannot-find-proj-db
ENV GDAL_DATA=/opt/conda/share/gdal \
    PROJ_LIB=/opt/conda/share/proj

RUN rm -rf XDG_CACHE_HOME/* \
USER $NB_UID

