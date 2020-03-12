#!/bin/bash 

if [ $# -eq 0 ]
then
    TAG=$(echo $(hexdump -n 6 -e '4/4 "%08X" 1 "\n"' /dev/random) | tr '[:upper:]' '[:lower:]')
else
    TAG=$1
fi

# get jupyter base files
git clone https://github.com/jupyter/docker-stacks.git
cp docker-stacks/base-notebook/fix-permissions .
cp docker-stacks/base-notebook/jupyter_notebook_config.py .
cp docker-stacks/base-notebook/start-notebook.sh .
cp docker-stacks/base-notebook/start-singleuser.sh .
cp docker-stacks/base-notebook/start.sh .
rm -rf docker-stacks

docker build -f Dockerfile -t cuahsi/singleuser-base:centos7.v$TAG .
