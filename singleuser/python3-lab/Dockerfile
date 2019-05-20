FROM cuahsi/singleuser:base

RUN conda update conda -y \
&& conda clean --all -y

## set anaconda channels
RUN conda config --add channels conda-forge \
&& conda config --add channels landlab \
&& conda config --add channels odm2 

RUN conda install -y -n base \
 gdal \
 jupyterhub \
 landlab \
 ogh \
 basemap-data-hires \
 ulmo \
 celery \
 geopandas \
 graphviz \
 python-wget \
 requests \
 requests-toolbelt \
 requests-oauthlib \
 ipywidgets \
 ipython \
 paramiko \
&& conda clean --all -y

RUN /opt/conda/bin/pip install --no-cache-dir hs_restclient

# NBExtensions
# install jupyter_contrib_nbextensions dependencies
RUN conda install -y -n base \
 "jupyter_contrib_core>=0.3.3" \
 jupyter_core \
 "notebook>=4.0" \
 pyyaml \
 tornado \
 traitlets \
&& conda clean --all -y

RUN /opt/conda/bin/pip install --upgrade pip

### install pysumma (pure python)
#RUN /opt/conda/bin/pip install --no-cache-dir git+https://github.com/uva-hydroinformatics/pysumma.git@v1.0.0

RUN pip install jupyterlab

ENTRYPOINT ["jupyter", "lab","--ip=0.0.0.0","--allow-root"]
