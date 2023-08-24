#!/bin/bash


CWD=$(pwd)
WRF_PATH=/home/jovyan/wrfhydro

function setup_wrfhydro() {
	cp $WRF_PATH/*TBL $CWD
	cp $WRF_PATH/namelist.hrldas $CWD
	cp $WRF_PATH/hydro.namelist $CWD
	ln -sf $WRF_PATH/wrf_hydro.exe $CWD/wrf_hydro.exe
}



echo ""
echo "****************************************************"
echo "*** WRF-Hydro Setup Script for CUAHSI JupyterHub ***"
echo "****************************************************"
echo ""
echo The purpose of this script is to prepare your current directory for running WRF-Hydro. It will performe the following operations:
echo ""
echo "   1. Create a symbolic link from the system WRF-Hydro.exe to the current directory"
echo "   2. Copy namelist template files into the current directory"
echo "   3. Copy TBL files into the current directory"
echo ""
echo "If any of these files exist in the current directory they will be overwritten."

read -r -p "Do you wish to continue [y/N] " response
case "$response" in
    [yY][eE][sS]|[yY])
        
	    setup_wrfhydro;
        ;;
    *)
        exit 0
        ;;
esac



