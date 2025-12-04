# ESMF Regridding for WRF-Hydro

This directory contains the Docker build scripts for creating the `cuahsi/wrfhydro-regrid`
image. This image is used to streamline the execution of the ESMF
[regridding scripts](https://ral.ucar.edu/projects/wrf_hydro/regridding-scripts)
within Docker containers.

## Execution

``` bash
python wrfhydro-regrid.py \ 
       —image-version <docker image tag> \
       —forcing-path <path to forcing dir> \
       —geogrid-path <path to geogrid.nc> \
       —output-path <path where output will be saved> \
       —verbose
```

Example:

``` bash
python wrfhydro-regrid.py -f input_files_nc -g geo_em.d01.nc -o output -F NETCDF -i 0.3
```

This can also be executed directly using Docker:  

```bash
docker run --rm \
  -v $(pwd)/input_data_nc:/home/input_files \
  -v $(pwd)/output:/home/output_files \
  -v $(pwd)/geo_em.d01.nc:/home/geo_em.d01.nc \
  cuahsi/wrfhydro-regrid:0.3 -f input_files -g geo_em.d01.nc -o output_files -F NETCDF -i 0.3
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

``` bash
# ./build.sh <version>

./build 0.1
```
