#!/bin/bash

mkdir output


python nwm-subset.py \
    -llat 571663.2008999996 \
    -ulat 591703.6239999996 \
    -llon 2011337.7544 \
    -ulon 2029842.1457 \
    -o output \
    -v
