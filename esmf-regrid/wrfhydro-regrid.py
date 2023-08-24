#!/usr/bin/env python3


"""
Purpose: This script executes ESMF regridding operations using Docker.
Requirements: Docker installed on system, python-docker, python 3.8+

Author: Tony Castronova <acastronova@cuahsi.org>
Date: 07.12.2022
Org: CUAHSI
"""

import sys
import docker
import argparse
from pathlib import Path
from typing import Union


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


def execute_regrid(
    image: str,
    method: str,
    interp: str,
    forcing_path: Union[str, Path],
    geogrid_path: Union[str, Path],
    output_path: Union[str, Path, None]=None,
    verbose: bool=False,
) -> bool:
    
    # define and clean the file paths needed for regridding
    forcing_path = Path(forcing_path)
    geogrid_path = Path(geogrid_path)
    
    # define required volume mounts
    mnt = {
        f"{geogrid_path.absolute()}": {
            "bind": f"/home/{geogrid_path.name}",
            "mode": "rw",
        },
        f"{forcing_path.absolute()}/": {"bind": "/home/input_files", "mode": "rw"},
    }

    if output_path is not None:
        output_path = Path(output_path)
        # add optional volume mount
        mnt[f"{output_path.absolute()}"] = {"bind": "/home/output_files", "mode": "rw"}


    # define the execution command
    cmd = f"-f /home/input_files -g /home/{geogrid_path.name} -m {method} -i {interp}"

    # add verbosity flag
    if verbose:
        cmd += " -v"
    
    client = docker.from_env()

    try:

        container = client.containers.run(
            image, cmd, volumes=mnt, auto_remove=True, detach=True, stream=True
        )

        # print stdout if verbose is True. If not, looping over 
        # logs makes the program wait for the container to exit
        # which is what we want anyway.
        for line in container.logs(stream=True, follow=True):
            if verbose:
                print(line.decode(), end="", flush=True)

    except docker.errors.APIError as e:
        print(f"Error encountered while executing regridding operation: \n\t {e}")
        return False


    return True


if __name__ == "__main__":

    # argparse
    parser = argparse.ArgumentParser()

    # required args
    parser.add_argument(
        "-f", "--forcing-path", required=True, help="path containing raw forcing files"
    )
    parser.add_argument(
        "-g",
        "--geogrid-path",
        required=True,
        help="path to geogrid file that will be used for regridding",
    )
    parser.add_argument(
        "-o",
        "--output-path",
        required=True,
        help="path to save output files",
    )

    # optional args
    parser.add_argument(
        "-i",
        "--image-version",
        default="latest",
        help="Version of the cuahsi/wrf-hydro-regrid image to use, default=latest",
    )
    parser.add_argument(
        "-m",
        "--method",
        help="regridding method to be used, default=NLDAS",
        choices=["NLDAS"],
        default="NLDAS",
    )
    parser.add_argument(
        "--interp",
        default="bilinear",
        help="regridding interpolation method to use, default=bilinear",
        choices=["conserve", "bilinear"],
    )
    parser.add_argument(
        "-v",
        "--verbose",
        default=False,
        action='store_true',
        help="flag to enable verbose output",
    ) 

    args = parser.parse_args()

    image = f'cuahsi/wrfhydro-regrid:{args.image_version}'

    # print user supplied arguments/parameters
    print(
        f"""
    ----------------------------------------------------
    Executing WRFHydro-Regrid with the following Options
    ----------------------------------------------------
       Docker Image:  {image}
       Regrid Method: {args.method}
       Interp Method: {args.interp}
       Output Path:   {args.output_path}
       Forcing Path:  {args.forcing_path}
       Geogrid Path:  {args.geogrid_path}
    ----------------------------------------------------
    """
    )

    # checking the user supplied paths for errors
    errors = []
    for input_val in [args.forcing_path, args.geogrid_path, args.output_path]:
        input_path = Path(input_val)
        if not input_path.exists():
            errors.append(f'ERROR: Path does not exist {input_path.absolute()}')
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

    # execute regridding operations
    success = execute_regrid(
        image,
        args.method,
        args.interp,
        args.forcing_path,
        args.geogrid_path,
        args.output_path,
        args.verbose,
    )
