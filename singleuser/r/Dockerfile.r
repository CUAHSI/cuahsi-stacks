ARG BASE_VERSION
FROM cuahsi/singleuser-base:$BASE_VERSION

USER root

RUN conda update conda -y \
&& conda clean --all -y

USER jovyan

RUN mkdir $HOME/.userRLib \
&& echo "options(repos=structure(c(CRAN=\"http://archive.linux.duke.edu/cran\")))" >> $HOME/.Rprofile \
&& conda config --add channels r \
&& conda config --add channels conda-forge \
&& conda create -y -n R 

RUN conda install -n R -c r -y \
  r-base=3.5 \
  r-irkernel \
  r-essentials \
  r-devtools \
  r-xml \
  r-rjsonio \
  r-ncdf4 \
  r-sf \
  r-ggmap \
  r-mapdata \
  r-gridextra \
&& conda clean --all -y 


#RUN /bin/bash -c "source activate R" \
ARG PACKAGES='"WaterML","dplyer","rgrass7","dataRetrieval","stringi"'
RUN /opt/conda/envs/R/bin/Rscript -e "install.packages(c($PACKAGES))" 

# remove all registered kernels
RUN jupyter kernelspec remove -f $(jupyter kernelspec list | tr -s ' ' | cut -f 2 -d' ' | tail -n +2)

# install the R kernel
USER root
RUN /opt/conda/envs/R/bin/python -m ipykernel install --prefix=/usr --name 'R-3.5.1'
USER jovyan
