ARG BASE_VERSION
FROM cuahsi/singleuser-base:$BASE_VERSION

USER root

# ffmpeg for matplotlib anim
RUN apt-get update && \
    apt-get install -y --no-install-recommends ffmpeg && \
    rm -rf /var/lib/apt/lists/*

USER $NB_UID

ENV XDG_CACHE_HOME /home/$NB_USER/.cache/

RUN conda update conda -y \
&& pip install --upgrade pip \
&& conda clean --all -y

## set anaconda channels
RUN conda config --add channels conda-forge \
&& conda config --add channels landlab \
&& conda config --add channels odm2 

RUN conda create -n Python3.6 -y python=3.6
RUN conda install --quiet -y -n Python3.6 \
 celery \
 geopandas \
 graphviz \
 python-wget \
 requests \
 requests-toolbelt \
 requests-oauthlib \
 ipython \
 paramiko \
 gdal=2.4* \
 landlab=1.5* \
 ogh=0.2* \
 basemap-data-hires \
 ulmo=0.8* \
 pandas=0.24.* \
 ipywidgets=7.4* \
 conda-forge::blas=*=openblas \
 pandas=0.24* \
 numexpr=2.6* \
 matplotlib=3.0* \
 scipy=1.2* \
 seaborn=0.9* \
 scikit-learn=0.20* \
 scikit-image=0.14* \
 sympy=1.3* \
 cython=0.29* \
 patsy=0.5* \
 statsmodels=0.9* \
 cloudpickle=0.8* \
 dill=0.2* \
 dask=1.1.* \
 numba=0.42* \
 bokeh=1.0* \
 sqlalchemy=1.3* \
 hdf5=1.10* \
 h5py=2.9* \
 beautifulsoup4=4.7.* \
&& conda clean --all -f -y \
&& npm cache clean --force \
&& rm -rf $CONDA_DIR/share/jupyter/lab/staging \
&& rm -rf /home/$NB_USER/.cache/yarn \
&& rm -rf /home/$NB_USER/.node-gyp \
&& fix-permissions $CONDA_DIR \
&& fix-permissions /home/$NB_USER

# Import matplotlib the first time to build the font cache.
RUN MPLBACKEND=Agg /opt/conda/envs/Python3.6/bin/python -c "import matplotlib.pyplot" && \
    fix-permissions /home/$NB_USER

RUN /opt/conda/envs/Python3.6/bin/python -m ipykernel install --prefix=/opt/conda --name 'Python3.6' 
#&& ipython kernel install --sys-prefix

RUN pip uninstall -y ipykernel

#CMD ["start-notebook.sh", "--KernelSpecManager.ensure_native_kernel=0"]

USER root
RUN rm -rf XDG_CACHE_HOME/* \
USER $NB_UID

