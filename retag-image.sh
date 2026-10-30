#!/bin/bash


if [ "$#" -ne 3 ]; then
    echo "Info:"
    echo "      Author : Tony Castronova <acastronova@cuahsi.org>"
    echo "      Date   : 03.18.2024"
    echo "      Purpose: Utility script for re-tagging JupyterHub images"
    echo ""
    echo "Usage:"
    echo "     " $(basename "$0") "<image-name> <current-tag> <new-tag>"
    echo "      image-name :  name of image in repository"
    echo "      current-tag:  image tag in in repository"
    echo "      new-tag    :  new tag to assign"

    exit 2
fi

REPOSITORY=$1
TAG_OLD=$2
TAG_NEW=$3

echo -e "\nRe-tagging Image: "
echo -e "   - SOURCE -> $REPOSITORY:$TAG_OLD"
echo -e "   - TARGET -> $REPOSITORY:$TAG_NEW"
echo 

read -p "Are you sure you want to continue [Y/n]? " prompt
if [[ $prompt == "n" || $prompt == "N" || $prompt == "no" || $prompt == "No" ]]
then
    exit 0
else
    docker manifest create $REPOSITORY:$TAG_NEW $REPOSITORY:$TAG_OLD
    docker manifest push $REPOSITORY:$TAG_NEW  
fi
