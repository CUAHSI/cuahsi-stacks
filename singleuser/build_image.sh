#!/usr/bin/env bash

if [ $# -ne 4 ]; then
    echo "Incorrect number of arguments supplied"
    echo "Usage:"
    echo "build_image [path to Dockerfile] [base image name] [tag] [version]"
    echo "e.g."
    echo "build_image base/Dockerfile.base latest base 2020.06.08"
    echo "-> cuahsi/singleuser-base:2020.06.08"
    exit 1
fi

dpath=$1
vbase=$2
tag=$3
version=$4

if [ ! -z $5 ]
then
    cache=$5
else
    cache=''
fi



echo Dockerfile: $dpath 
echo Base Version: $vbase
echo Image Tag: $tag 
echo Image version: $version

img=cuahsi/singleuser-$tag:$version
echo Complete Image Name: $img

while true; do
    read -p "Do you wish to continue [Y/n]?" yn
    case $yn in
        [Nn]* ) exit;;
	* ) break;;
    esac
done

builddir=$(dirname $dpath)
dockerfile=$(basename $dpath)
currdir=$(pwd)
cd $builddir \
&& docker build $cache --build-arg BASE_VERSION=$vbase -f $dockerfile -t cuahsi/singleuser-$tag:$version . \
&& cd $currdir

