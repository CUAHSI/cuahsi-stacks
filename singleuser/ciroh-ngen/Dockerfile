FROM ngen:latest AS ngen
FROM quay.io/2i2c/awi-ciroh-image:latest

USER root
COPY --from=ngen /opt/src/ngen/build/ngen /usr/local/bin/ngen
COPY --from=ngen /opt/src/ngen/build/extern /opt/shared
COPY --from=ngen /opt/src/ngen/T-Route/wheels /opt/troute
RUN chmod +x /usr/local/bin/ngen
ENV LD_LIBRARY_PATH=/opt/shared

RUN apt update && apt install -y --no-install-recommends \
  libudunits2-dev \
  && rm -rf /var/lib/apt/lists/*

# create conda environment for running ngen
# this is necessary to ensure that the
# environment has the correct dependencies
RUN conda create -n ngen -y \
  python=3.10.12 \
  numpy=1.26.4 \
  pandas \
  bmipy \
  pyyaml \ 
  fiona

RUN /srv/conda/bin/conda init 

USER $NB_UID



