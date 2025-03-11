#!/bin/bash

docker run --rm -ti \
  -u root \
  -v $(pwd)/test:/tmp/test \
  -w "/tmp" \
  --entrypoint=/bin/bash \
  cuahsi/singleuser-hl-physical-hydrology:2025.03.06
