#!/usr/bin/env python3


"""
Purpose: This script executes a Docker container that queries NWM domain data
         from the CUAHSI Domain Subsetter: https://subset.cuahsi.org
Requirements: Docker installed on system, python-docker, python 3.8+

Author: Tony Castronova <acastronova@cuahsi.org>
Date: 09.09.2022
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


def _execute(
    image: str,
    llat: float,
    llon: float,
    ulat: float,
    ulon: float,
    output_path: Union[str, Path, None]=None,
    verbose: bool=False,
) -> bool:
    
    # define required volume mounts
    container_output_path = '/home/output_files'
    output_path = Path(output_path)
    mnt = {
            f"{output_path.absolute()}": {
                "bind": f"{container_output_path}",
                "mode": "rw"
                }
            }


    # define the execution command
    cmd = f"-o {container_output_path} -llat {llat} -llon {llon} -ulat {ulat} -ulon {ulon}"

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
        print(f"Error encountered while executing the subsetting operation: \n\t {e}")
        return False


    return True


if __name__ == "__main__":

    # argparse
    parser = argparse.ArgumentParser()

    # required args
    parser.add_argument(
        "-o",
        "--output-path",
        required=True,
        help="directory to save output files",
    )

    parser.add_argument(
        "-llat",
        "--lower-latitude",
        type=float,
        help="lower latitude of the bounding box to subset.",
    )

    parser.add_argument(
        "-ulat",
        "--upper-latitude",
        type=float,
        help="upper latitude of the bounding box to subset.",
    )

    parser.add_argument(
        "-llon",
        "--lower-longitude",
        type=float,
        help="lower longitude of the bounding box to subset.",
    )

    parser.add_argument(
        "-ulon",
        "--upper-longitude",
        type=float,
        help="upper longitude of the bounding box to subset.",
    )

    # optional args
    parser.add_argument(
        "-i",
        "--image-version",
        required=False,
        default=0.1,
        help='version of the nwm subsetting image to use',
    )
    parser.add_argument(
        "-v",
        "--verbose",
        default=False,
        action='store_true',
        help="flag to enable verbose output",
    ) 

    args = parser.parse_args()

    image = f'cuahsi/nwm-domain-subset:{args.image_version}'

    # print user supplied arguments/parameters
    print(
        f"""
    ----------------------------------------------------
    Executing WRFHydro-Regrid with the following Options
    ----------------------------------------------------
       Docker Image:  {image}
       Lower Lat   : {args.lower_latitude}
       Upper Lat   : {args.upper_latitude}
       Lower Lon   : {args.lower_longitude}
       Upper Lon   : {args.upper_longitude}
       Output Path:   {args.output_path}
    ----------------------------------------------------
    """
    )

    # checking the user supplied paths for errors
    errors = []
    for input_val in [args.output_path]:
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
    success = _execute(
        image,
        args.lower_latitude,
        args.lower_longitude,
        args.upper_latitude,
        args.upper_longitude,
        args.output_path,
        args.verbose,
    )
