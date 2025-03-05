FROM jupyter/scipy-notebook


RUN conda update conda -y \
&& conda clean --all -y

## set anaconda channels
RUN conda config --add channels conda-forge \
&& conda config --add channels landlab \
&& conda config --add channels odm2 

RUN conda install -y -n base \
 gdal \
 "jupyterhub=0.8.1" \
 "landlab=1.4.0" \
 "ogh=0.1.11" \
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

USER root 
RUN apt-get install -y git
USER jovyan

RUN /opt/conda/bin/pip install --upgrade pip

## install pysumma (pure python)
RUN /opt/conda/bin/pip install --no-cache-dir git+https://github.com/uva-hydroinformatics/pysumma.git@v1.0.0


ENTRYPOINT ["python"]

