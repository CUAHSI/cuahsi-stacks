FROM debian:bookworm-slim

RUN apt update \
    && apt install -y \
    wget \
    libfontconfig1 \
    libxrender1 \
    libxext-dev \
    gfortran \
    cdo \
    && rm -rf /var/lib/apt/lists/*


WORKDIR /home


ARG TARGETARCH

RUN if [ "$TARGETARCH" = "amd64" ]; then \
        ARCH=x86_64; \
    elif [ "$TARGETARCH" = "arm64" ]; then \
        ARCH=aarch64; \
    else \
        echo "Unsupported architecture: $TARGETARCH" ; exit 1 ; \
    fi && \
    wget "https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-${ARCH}.sh" \
    && mkdir /root/.conda \
    && bash "Miniconda3-latest-Linux-${ARCH}.sh" -b \
    && rm -f "Miniconda3-latest-Linux-${ARCH}.sh"


ENV NCARG_ROOT="/root/miniconda3"
ENV PATH="${NCARG_ROOT}/bin:/root/miniconda3/bin:${PATH}"

RUN conda tos accept \
    && conda install -c conda-forge ncl xesmf netcdf4 -y \
    && conda clean -a -y \
    && rm -rf /root/miniconda3/pkgs/*

# make directories for mounting dataset
RUN mkdir /home/input_files \
    mkdir /home/output_files 

COPY NLDAS2WRFHydro_generate_weights.ncl NLDAS2WRFHydro_regrid.ncl /home/
COPY entry.py /home/

ENTRYPOINT ["/root/miniconda3/bin/python", "entry.py"]

