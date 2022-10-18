
FROM cuahsi/singleuser-base:2022.04.04

USER root
RUN sudo apt install ca-certificates

RUN apt-get update && \
    rm -rf /var/lib/apt/lists/*

USER $NB_UID

ENV XDG_CACHE_HOME /home/$NB_USER/.cache/

# get the class materials
RUN git clone --depth 1 https://github.com/DOI-USGS/python-for-hydrology.git /opt/python_class \
        && chmod -R 777 /opt/python_class

# build the environment
RUN mamba env create -vf /opt/python_class/installation/environment.yml

# Import matplotlib the first time to build the font cache.
RUN MPLBACKEND=Agg python -c "import matplotlib.pyplot" && \
    fix-permissions /home/$NB_USER

USER root
RUN apt update && apt install -y cmake \
&& rm -rf /var/lib/apt/lists/*

# DO WE NEED THIS STUFF??????
# Set GDAL and Proj env vars. This is necessary to ensure gdal commands don't error out when the base
# conda environment is not explicitly activated.
# see https://gis.stackexchange.com/questions/326968/ogr2ogr-error-1-proj-pj-obj-create-cannot-find-proj-db

ENV GDAL_DATA=/opt/conda/share/gdal \
    PROJ_LIB=/opt/conda/share/proj

## quick update of ipykernel
RUN pip install --upgrade ipykernel

COPY setup_files.py /home/jovyan/setup_files.py

# get the MODFLOW binaries
RUN curl -L -o linux.zip https://github.com/MODFLOW-USGS/executables/releases/latest/download/linux.zip?raw=true \
&& mkdir binaries \
&& unzip linux.zip -d binaries \
&& rm linux.zip  

# add binaries to the path
ENV PATH="/home/jovyan/binaries:${PATH}"

#ENV PYTHONPATH="${PYTHONPATH}:/opt/iah2021-brazil-mf6/python_packages"

RUN echo "source activate pyclass" > ~/.bashrc

ENV PATH /opt/conda/envs/pyclass/bin:$PATH

RUN rm -rf XDG_CACHE_HOME/*

USER $NB_UID
