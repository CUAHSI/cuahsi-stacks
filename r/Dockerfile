FROM jupyter/scipy-notebook


USER root
RUN conda update conda -y \
&& conda clean --all -y

RUN apt-get update \
&& apt-get install -y gfortran build-essential

USER jovyan

RUN mkdir $HOME/.userRLib \
&& echo "options(repos=structure(c(CRAN=\"http://archive.linux.duke.edu/cran\")))" >> $HOME/.Rprofile \
&& conda config --add channels r \
&& conda config --add channels conda-forge \
&& conda create -y -n R 

RUN conda install -n R -c r \
  r-base=3.4.1 \
  r-irkernel \
  r-essentials \
  r-devtools \
  r-xml \
  r-rjsonio \
  r-ncdf4 \
  r-sf \
&& conda clean --all -y 


#RUN /bin/bash -c "source activate R" \
RUN /opt/conda/envs/R/bin/Rscript -e "install.packages('WaterML')" \
&& /opt/conda/envs/R/bin/Rscript -e "install.packages('dplyr')" \
&& /opt/conda/envs/R/bin/Rscript -e "install.packages('dataRetrieval',repos='https://owi.usgs.gov/R')" \
&& /opt/conda/envs/R/bin/Rscript -e "install.packages('stringi')" \
&& /opt/conda/envs/R/bin/Rscript -e "IRkernel::installspec(name = 'ir34', displayname = 'R 3.4')" 


RUN echo "source activate R" > ~/.bashrc
ENV PATH /opt/conda/envs/R/bin:$PATH

ENTRYPOINT ["/bin/bash"]

