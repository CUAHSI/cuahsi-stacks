FROM jupyter/scipy-notebook

# SciUnit dependencies: backports.tempfile backports.weakref configobj contextlib2 humanfriendly monotonic poster tqdm tzlocal

RUN conda update conda -y \
&& conda clean --all -y \
&& conda create -y -n python2 python=2 \
&& conda config --add channels conda-forge \
&& conda config --add channels landlab \
&& conda config --add channels odm2 \
&& conda install -y -n python2 \
 "pandas=0.21.0" \
 gdal \
 ipykernel \
 ulmo \
 celery \
 geopandas \
 graphviz  \
 "statsmodels=0.8.0" \
 "odm2api=0.6.0.a0" \
 "landlab=1.4.0" \
 "ogh=0.1.11" \
 basemap-data-hires \
 bsddb \
 python-wget \
 ipywidgets \
 ipython \
 paramiko \
 requests \
 requests-toolbelt \
 requests-oauthlib \
 backports.tempfile \
 backports.weakref \
 configobj \
 contextlib2 \
 humanfriendly \
 monotonic \
 poster \
 tqdm \
 tzlocal \
&& conda clean --all -y

# install sciunit, and pyemu (uncertainty analysis library)
RUN /opt/conda/envs/python2/bin/pip install --no-cache-dir sciunit2 \
&& /bin/bash -c "source activate python2 && sciunit post-install" \
&& /opt/conda/envs/python2/bin/pip install --no-cache-dir pyemu

# register the python 2.7 kernel
RUN python -m ipykernel install \
    --user \
    --name "python2" \
    --display-name "Python 2.7"

ENTRYPOINT ["python"]

