#!/usr/local/env python3


"""
Entrypoint for the CUAHSI/WRFHydro container, requires Python 3.9+

Author: Tony Castronova <acastronova@cuahsi.org>
Date: 07.18.2022
Org: Consortium of Universities for the Advancement of Hydrologic Sciences, Inc
"""

import sys
import shutil
import subprocess
from pathlib import Path


class Wrfhydro:
    def __init__(self):
        pass

    def execute(self) -> bool:

        # execute the model simulation
        p = subprocess.Popen("./wrf_hydro.exe",
                             shell=True,
                             stdout=subprocess.DEVNULL)
        _, _ = p.communicate()

        if p.returncode != 0:
            return False
        return True

    def clean(self) -> bool:

        # move output files
        for src_file in Path(".").glob("*_DOMAIN*"):
            shutil.copy(src_file, "OUTPUT")

        return True


if __name__ == "__main__":

    # check that paths exist before attempting to run a simulation
    if not Path("hydro.namelist").exists():
        print(
            "'hydro.namelist' file not found. Please mount this file to '/home/docker/RUN'"
        )
        sys.exit(1)
    if not Path("namelist.hrldas").exists():
        print(
            "'namelist.hrldas' file not found. Please mount this file to '/home/docker/RUN'"
        )
        sys.exit(1)

    wrfhydro = Wrfhydro()

    # execute
    print('BEGIN WRF-HYDRO SIMULATION')
    success = wrfhydro.execute()
    if not success:
        print(f"Error encountered during model simulation")

    wrfhydro.clean()
    print('WRF-HYDRO SIMULATION COMPLETE')
