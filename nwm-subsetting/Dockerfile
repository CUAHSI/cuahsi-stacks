FROM debian:stretch-slim

RUN apt update \
    && apt install -y \
    wget \
    && rm -rf /var/lib/apt/lists/*



WORKDIR /home

RUN wget \
    https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh \
    && mkdir /root/.conda \
    && bash Miniconda3-latest-Linux-x86_64.sh -b \
    && rm -f Miniconda3-latest-Linux-x86_64.sh

ENV PATH="/root/miniconda3/bin:${PATH}"

RUN pip install requests

# make directories for mounting dataset
RUN mkdir /home/output_files 

COPY entry.py specs.py /home/

ENTRYPOINT ["/root/miniconda3/bin/python3.9", "entry.py"]

