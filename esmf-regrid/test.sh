#!/bin/bash

docker run --rm -ti \
  -v $(pwd)/input_files:/home/input_files \
  -v $(pwd)/input_data_nc:/home/input_data_nc \
  -v $(pwd)/output:/home/output_files \
  -v $(pwd)/geo_em.d01.nc:/home/geo_em.d01.nc \
  --entrypoint=/bin/bash cuahsi/wrfhydro-regrid:0.2
#docker run --rm -ti --entrypoint=/bin/bash cuahsi/wrfhydro-regrid:0.1
