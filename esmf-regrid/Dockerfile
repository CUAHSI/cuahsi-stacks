FROM debian:stretch-slim

RUN apt update \
    && apt install -y \
    wget \
    libfontconfig1 \
    libxrender1 \
    libxext-dev \
    gfortran \
    && rm -rf /var/lib/apt/lists/*


ENV NCARG_ROOT="/usr/local/ncl-6.6.2" 
ENV PATH="${NCARG_ROOT}/bin:${PATH}"

WORKDIR /home


RUN wget https://www.earthsystemgrid.org/dataset/ncl.662.dap/file/ncl_ncarg-6.6.2-Debian9.8_64bit_gnu630.tar.gz \
    && mkdir /usr/local/ncl-6.6.2 \
    && tar -zxf ncl_ncarg-6.6.2-Debian9.8_64bit_gnu630.tar.gz -C /usr/local/ncl-6.6.2 \ 
    && rm ncl_ncarg-6.6.2-Debian9.8_64bit_gnu630.tar.gz



RUN wget \
    https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh \
    && mkdir /root/.conda \
    && bash Miniconda3-latest-Linux-x86_64.sh -b \
    && rm -f Miniconda3-latest-Linux-x86_64.sh

# make directories for mounting dataset
RUN mkdir /home/input_files \
    mkdir /home/output_files 

COPY NLDAS2WRFHydro_generate_weights.ncl NLDAS2WRFHydro_regrid.ncl /home/
COPY entry.py specs.py /home/

ENTRYPOINT ["/root/miniconda3/bin/python3.9", "entry.py"]

