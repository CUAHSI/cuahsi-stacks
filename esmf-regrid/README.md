# ESMF Regridding for WRF-Hydro

This directory contains the Docker build scripts for creating the `cuahsi/wrfhydro-regrid` image. This image is used to streamline the execution of the ESMF [regridding scripts](https://ral.ucar.edu/projects/wrf_hydro/regridding-scripts) within Docker containers. 

## Execution

```
python wrfhydro-regrid.py \ 
       —image-version <docker image tag> \
       —forcing-path <path to forcing dir> \
       —geogrid-path <path to geogrid.nc> \
       —output-path <path where output will be saved> \
       —verbose
```

Example:

```
python wrfhydro-regrid.py —image-version 0.1 —forcing-path input_files/ —geogrid-path geo_em.d01.nc —output-path output/ —verbose
```

## Supported Regridding Operations
- [x] NLDAS
- [ ] GLDAS
- [ ] HRRR
- [ ] MRMS
- [ ] GFS
- [ ] RAP
- [ ] WRF

## Description of Files

- `Dockerfile`: the docker build file for creating the `cuahsi/wrfhydro-regrid` image
- `build.sh`: helper script for building and tagging the docker image
- `entry.py`: the entrypoint of the `cuahsi/wrfhydro-regrid` image. This script exposes the various regridding arguments/options and executes the specified regridding operation. This script is added into the container within the `Dockerfile`.
- `wrfhydro-regrid.py`: clientside entrypoint for the regridding operation. This script handles docker volume mounting and execution so the `cuahsi/wrfhydro-regrid` container can be executed as if it was a compiled executable on the client machine.

## Build Instructions

```
# ./build.sh <version>

./build 0.1
```
