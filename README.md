This repository contains a variety Docker images designed to be used for water
science research and education. It also contains all CUAHSI JupyterHub images,
the hierarchy of these is shown below.

## JupyterHub Singleuser Image Inheritance

``` mermaid
graph TB;

Base-Ubuntu-->Scientific-Python;
Base-CentOS-->ParFlow;

Base-Ubuntu-->Scientific-R
Base-Ubuntu-->WRF-Hydro;
Base-Ubuntu-->SUMMA;
Base-Ubuntu-->CSDMS-Toolbox;
Base-Ubuntu-->Binder-Base;
Base-Ubuntu-->IAHS-MODFLOW;
Scientific-R-->HydroLearn-Intelligent-Earth;
Base-Ubuntu-->SI-2021;
Base-Ubuntu-->SI-2022;

```
