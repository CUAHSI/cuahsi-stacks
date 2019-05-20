#!/bin/bash

# install testing dependencies
/opt/conda/bin/pip install moto

## test xarray
#/opt/conda/bin/python -m pytest --pyargs xarray

# test pandas
#/opt/conda/bin/python -m pytest --pyargs pandas

## test landlab
#/opt/conda/bin/python -m pytest --pyargs landlab

# test PySUMMA
/opt/conda/bin/python -m pytest --pyargs pysumma
