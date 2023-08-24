#!/bin/bash

if [ -z "$1" ]
  then
    IMG='cuahsi/singleuser-si:latest'
  else
    IMG=$1
fi

docker run --rm -ti \
    --entrypoint=/bin/bash \
    --user=root \
    $IMG


# --mount type=bind,source="$(pwd)"/ngen/data,target=/data \
# --mount type=bind,source="$(pwd)"/tests,target=/tmp \
# Test model execution using the following command
# ngen data/catchment_data.geojson "" data/nexus_data.geojson "" data/example_realization_config.json

