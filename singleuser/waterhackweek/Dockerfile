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

RUN pip install "jupyterlab>=1.0" jupyterlab-dash==0.1.0a3

RUN jupyter labextension install jupyterlab-dash@0.1.0-alpha.3

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
RUN rm -rf XDG_CACHE_HOME/* \
USER $NB_UID

