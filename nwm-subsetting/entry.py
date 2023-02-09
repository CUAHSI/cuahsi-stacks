#!/usr/local/env python3


"""
Entrypoint for the CUAHSI Domain Subsetter container, requires Python 3.9+

Author: Tony Castronova <acastronova@cuahsi.org>
Date: 09.08.2022
Org: Consortium of Universities for the Advancement of Hydrologic Sciences, Inc
"""

import sys
import time
import json
import shutil
import argparse
import requests
from typing import Dict


class Subset():

    def execute(self, output_dir: str) -> bool:

        # todo: call the subsetter API and wait for a response

        # submit a job via bounding box
        print('calling subsetter API')
        submit_url = f'https://subset.cuahsi.org/nwm/v2_0/subset?llat={self.llat}&llon={self.llon}&ulat={self.ulat}&ulon={self.ulon}&hucs=[]'
        try:
            res = requests.get(submit_url)
            assert res.status_code == 200
        except AssertionError:
            print('Encountered error querying CUAHSI Subsetting service')
            return False

        # grab the job identifier
        uid = res.url.split('jobid=')[-1]

        # query job status
        print('waiting for job to complete')
        status_url = f'https://subset.cuahsi.org/jobs/{uid}'
        attempt = 0
        max_attempts = 100
        while attempt < max_attempts:
            res = requests.get(status_url)
            status = json.loads(res.text)['status']
            if status == 'finished':
                break
            attempt += 1
            time.sleep(5)

        # download the result
        print('downloading domain data')
        dl_url = f'https://subset.cuahsi.org/download-gzip/{uid}'

        local_filename = f'{uid}.tar.gz'
        with requests.get(dl_url, stream=True) as r:
            with open(local_filename, 'wb') as f:
                shutil.copyfileobj(r.raw, f)

        # move domain data into mounted directory
        print('moving results into output directory')
        shutil.move(local_filename, output_dir)

        return True

    def prepare(
        self,
        lower_latitude: float,
        upper_latitude: float,
        lower_longitude: float,
        upper_longitude: float
    ) -> bool:

        # todo: check that bounding box is valid
        print('checking bbox validity')
        try:
            assert lower_latitude < upper_latitude
            assert lower_longitude < upper_longitude
        except AssertionError:
            print('Invalid bounding box detected')
            return False

        ################################################## 
        # todo: convert into proper coordinates
        ################################################## 

        
        # save these so they can be accessed in the execute methods
        self.llat = lower_latitude
        self.llon = lower_longitude
        self.ulat = upper_latitude
        self.ulon = upper_longitude

        return True

    def fmt_message(self, msg: str, args: Dict[str, str]) -> None:
        print(f'\n{"-"*25}\n{msg}\n')
        for k, v in args.items():
            print(f"{k:<15}:\t{v}")
        print(f'{"-"*25}\n')


class Parser(argparse.ArgumentParser):
    def error(self, message):
        print(f"\nERROR: {message}\n\n")


if __name__ == "__main__":

    parser = Parser()
    parser.add_argument(
        "-llat",
        "--lower-latitude",
        type=float,
        help="lower latitude bound in Albers Equal Area Conic",
        required=True,
    )
    parser.add_argument(
        "-ulat",
        "--upper-latitude",
        type=float,
        help="upper latitude bound in Albers Equal Area Conic",
        required=True,
    )
    parser.add_argument(
        "-llon",
        "--lower-longitude",
        type=float,
        help="lower longitude bound in Albers Equal Area Conic",
        required=True,
    )
    parser.add_argument(
        "-ulon",
        "--upper-longitude",
        type=float,
        help="upper longitude bound in Albers Equal Area Conic",
        required=True,
    )
    parser.add_argument(
        "-o",
        "--output-directory",
        help="directory to save the output files",
        required=True,
    )
    parser.add_argument(
        "-v",
        "--verbose",
        help="enable verbose mode",
        action="store_true",
        default=False,
    )
    args = parser.parse_args()

    subset = Subset()

    ################################################## 
    # todo: use verbosity to set logging level
    ################################################## 

    # prepare
    success = subset.prepare(
        args.lower_latitude,
        args.upper_latitude,
        args.lower_longitude,
        args.upper_longitude
    )
    if not success:
        print("Error encountered during prepare")
        sys.exit(1)

    # execute
    success = subset.execute(args.output_directory)
    if not success:
        print(f"Error encountered collecting domain data from the CUAHSI Subsetter")
        sys.exit(1)

