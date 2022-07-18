# WRF-Hydro Simulation

This directory contains the Docker build scripts for creating the `cuahsi/wrfhydro-nwm` image. This image is used to streamline the execution of the WRF-Hydro within Docker containers. 

## Execution

```
python wrfhydro.py 
       --image-version <docker image tag> \
       --forcing-path <path to forcing dir> \
       --domain-path <path to domain dir> \
       --output-path <path where output will be saved> \
       --wrfhydro-namelist <path to hydro.namelist> \
       --lsm-namelist <path to namelist.nldas> 
```

Example:

```
python wrfhydro.py \
    --image-version 5.2.0 \
    --forcing-path test/FORCING \
    --domain-path test/DOMAIN \
    --output-path test/OUTPUT/ \
    --wrfhydro-namelist test/hydro.namelist \
    --lsm-namelist test/namelist.hrldas
```

## Requirements

1. Docker installed on the client machine
2. Python runtime 3.7+
3. Python libraries: `docker`, `tqdm`, `f90nml`

## Description of Files

- `Dockerfile`: the docker build file for creating the `cuahsi/wrfhydro-nwm` image
- `build.sh`: helper script for building and tagging the docker image
- `entry.py`: the entrypoint of the `cuahsi/wrfhydro-nwm` image. This script manages model simulation and is added into the container within the `Dockerfile`.
- `wrfhydro.py`: client-side CLI for invoking model simulations. This script handles docker volume mounting so the `cuahsi/wrfhydro-nwm` container can be executed as if it was a compiled executable on the client machine.

## Build Instructions

```
# ./build.sh <wrfhydro-version>

./build 5.2.0
```
