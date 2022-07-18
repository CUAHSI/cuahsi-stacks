#!/usr/bin/env python3


"""
Purpose: This script executes WRF-Hydro simulation using Docker.
Requirements: Docker installed on system, python-docker, f90nml, tqdm, python 3.7+

Author: Tony Castronova <acastronova@cuahsi.org>
Date: 07.18.2022
Org: CUAHSI
"""

import sys
import tqdm
import time
import f90nml
import docker
import argparse
from pathlib import Path
from typing import Union
from datetime import datetime, timedelta


def display_progress(container_id, lsm_nl_path, output_path):
    client = docker.from_env()
        
    # determine the start and end time of the simulation
    lsm_nml = f90nml.read(lsm_nl_path)
    lsm = lsm_nml['noahlsm_offline']
    start_dt = datetime(lsm['start_year'],
                        lsm['start_month'],
                        lsm['start_day'],
                        lsm['start_hour'],
                        lsm['start_min'])
    curr_dt = start_dt
    if 'kday' in lsm:
        end_dt = start_dt + timedelta(days=lsm['kday'])
    else:
        end_dt = start_dt + timedelta(hours=lsm['khour'])
    simulation_total_sec = (end_dt - start_dt).total_seconds()

    # initialize the progress bar
    pbar = tqdm.tqdm(total=simulation_total_sec,
                     bar_format=('{l_bar}{bar}|[{elapsed}'
                                 '<{remaining}{postfix}'))
    
    old_dt = curr_dt
    while len(client.containers.list(filters={'id': container_id})) > 0:
        # get the last LDAS file that was created
        out_files = output_path.glob('*LDAS*')
        latest = max(out_files, key=lambda x: x.stat().st_ctime).name

        # update the progress bar
        old_dt = curr_dt
        curr_dt = datetime.strptime(latest.split('.')[0],
                                             '%Y%m%d%H%M')
        diff = (curr_dt - old_dt).total_seconds()
        pbar.set_postfix(sim_time=curr_dt)
        pbar.update(diff)
        time.sleep(1)
    
    # update to simulation end time
    curr_dt = end_dt
    diff = (curr_dt - old_dt).total_seconds()
    pbar.set_postfix(sim_time=curr_dt)
    pbar.update(diff)
    
    pbar.close()



def _check_image_exists(img: str) -> bool:
    client = docker.from_env()
    installed_images = client.images.list()
    for installed_image in installed_images:
        if len(installed_image.tags) > 0:  # make sure that a tag exists
            if img == installed_image.tags[0]:
                return True
    return False


def _pull_image(img: str) -> bool:
    client = docker.from_env()
    try:
        client.images.pull(img)
    except docker.errors.APIError as e:
        print(f"\nError encounter while pulling {img}")
        print(f'{"-"*25}\n{e}\n{"-"*25}')
        return False
    return True


def execute_simulation(
    image: str,
    hydro_nl_path: Union[str, Path],
    lsm_nl_path: Union[str, Path],
    output_path: Union[str, Path],
    domain_path: Union[str, Path],
    forcing_path: Union[str, Path, None] = None,
) -> bool:

    # define and clean the file paths needed for simulation
    output_path = Path(output_path)
    domain_path = Path(domain_path)
    hydro_nl_path = Path(hydro_nl_path)
    lsm_nl_path = Path(lsm_nl_path)

    # define required volume mounts
    mnt = {
        f"{domain_path.absolute()}": {
            "bind": "/home/docker/RUN/DOMAIN",
            "mode": "rw",
        },
        f"{output_path.absolute()}/": {
            "bind": "/home/docker/RUN/OUTPUT",
            "mode": "rw"
        },
        f"{hydro_nl_path.absolute()}/": {
            "bind": "/home/docker/RUN/hydro.namelist",
            "mode": "rw"
        },
        f"{lsm_nl_path.absolute()}/": {
            "bind": "/home/docker/RUN/namelist.hrldas",
            "mode": "rw"
        },
    }
    if forcing_path is not None:
        forcing_path = Path(forcing_path)
        mnt[f"{forcing_path.absolute()}/"] = {
            "bind": "/home/docker/RUN/FORCING",
            "mode": "rw"
        }

    client = docker.from_env()
    try:
        container = client.containers.run(
            image,
            volumes=mnt,
            auto_remove=True,
            detach=True,
        )
       
        # wait for container to start
        time.sleep(5)

        # print simulation progress to stdout
        display_progress(container.id,
                         lsm_nl_path,
                         output_path)


    except docker.errors.APIError as e:
        print(f"Error encountered while executing WRF-Hydro simulation: \n\t {e}")
        return False

    return True


if __name__ == "__main__":

    # argparse
    parser = argparse.ArgumentParser()

    # required args
    parser.add_argument(
        "-d",
        "--domain-path",
        required=True,
        help="path to the simulation DOMAIN file directory", 
    )
    parser.add_argument(
        "-o",
        "--output-path",
        required=True,
        help="path to save output files",
    )
    parser.add_argument(
        "-w",
        "--wrfhydro-namelist",
        required=True,
        help="path to the `hydro.namelist` file used to configure WRF-Hydro simulation parameters",
    )
    parser.add_argument(
        "-l",
        "--lsm-namelist",
        required=True,
        help="path to the `namelist.hrldas` file used to configure NoahMP simulation parameters",
    )

    # optional args
    parser.add_argument(
        "-f",
        "--forcing-path",
        required=False,
        default=None,
        help="path containing forcing files for the simulation. This is required unless FORC_TYP = 4 in namelist.hrldas (i.e. idealized forcing)",
    )
    parser.add_argument(
        "-i",
        "--image-version",
        default="5.2.0",
        help="Version of the cuahsi/wrfhydro-nwm image to use, default=5.2.0",
    )

    args = parser.parse_args()

    image = f"cuahsi/wrfhydro-nwm:{args.image_version}"

    # print user supplied arguments/parameters
    print(
        f"""
    -------------------------------------------------
    Executing WRFHydro-NWM with the following Options
    -------------------------------------------------
       Docker Image:    {image}
       Hydro.Namelist:  {args.wrfhydro_namelist}
       Namelist.hrldas: {args.lsm_namelist}
       Output Path:     {args.output_path}
       Forcing Path:    {args.forcing_path}
       DOMAIN Path:     {args.domain_path}
    ----------------------------------------------------
    """
    )

    # checking the user supplied paths for errors
    errors = []
    for input_val in [args.domain_path,
                      args.output_path,
                      args.wrfhydro_namelist,
                      args.lsm_namelist]:
        input_path = Path(input_val)
        if not input_path.exists():
            errors.append(f"ERROR: Path does not exist {input_path.absolute()}")
    if len(errors) > 0:
        for e in errors:
            print(e)
        sys.exit(1)

    # check if image exists on system
    img_exists = _check_image_exists(image)
    print(f'Image "{image}" exists: {img_exists}')

    # pull image
    if not img_exists:
        print(f"Attempting to pull image: {image}")
        pull_success = _pull_image(image)
        if not pull_success:
            sys.exit(1)

    # execute the WRF-Hydro simulation
    success = execute_simulation(
        image,
        args.wrfhydro_namelist,
        args.lsm_namelist,
        args.output_path,
        args.domain_path,
        args.forcing_path,
    )
