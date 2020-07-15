#!/bin/bash

## TODO: check if docker is installed
## TODO: check if the wrf-hydro docker image is installed

function getValue() {
    # $1: field name
    # $2: file name 
    VALUE=`grep "$1" "$2" | grep -v '!' | head -n 1 | tr -s ' ' | sed s/\ //g`
    if [ "$VALUE" != "" ]; then
        export $VALUE
    fi 
}

progressBarWidth=20

# Function to draw progress bar
progressBar () {
  
  taskCount=$1
  tasksDone=$2
  text="${@:3}"

  # Calculate number of fill/empty slots in the bar
  progress=$(echo "$progressBarWidth/$taskCount*$tasksDone" | bc -l)  
  fill=$(printf "%.0f\n" $progress)
  if [ $fill -gt $progressBarWidth ]; then
    fill=$progressBarWidth
  fi
  empty=$(($fill-$progressBarWidth))

  # Percentage Calculation
  percent=$(echo "100/$taskCount*$tasksDone" | bc -l)
  percent=$(printf "%0.2f\n" $percent)
  if [ $(echo "$percent>100" | bc) -gt 0 ]; then
    percent="100.00"
  fi

  # Output to screen
  printf "\r["
  printf "%${fill}s" '' | tr ' ' '#'
  printf "%${empty}s" '' | tr ' ' '-'
  printf "] $percent%% - $text "
}



FILE_NAME="configs/namelist.hrldas"

getValue START_YEAR   $FILE_NAME
getValue START_MONTH  $FILE_NAME
getValue START_DAY    $FILE_NAME
getValue START_HOUR   $FILE_NAME
getValue START_MIN    $FILE_NAME
getValue KDAY         $FILE_NAME
getValue KHOUR        $FILE_NAME

dt=$START_YEAR$START_MONTH$START_DAY$START_HOUR$START_MIN
st=$(date -j -f '%Y%m%d%H%M' $dt +'%Y%m%d%H%M')

day=${KDAY:-notset}
if [ "$day" != "notset" ]; then
    et=$(date -j -v +$(($KDAY))d -f "%Y%m%d%H%M" $st +"%Y%m%d%H%M")
    step=86400
else
    et=$(date -j -v +$(($KHOUR))H -f "%Y%m%d%H%M" $st +"%Y%m%d%H%M")
    step=3600
fi

#echo EndDate: $et


printf '\n%s\n' '----------------------------------'
printf "Begin WRF-Hydro v5.0.3 Simulation\n"
printf "StartDate: $(date -j -f "%Y%m%d%H%M" $st +"%Y-%m-%d %H:%M")\n"
printf "EndDate: $(date -j -f "%Y%m%d%H%M" $et +"%Y-%m-%d %H:%M")\n"
printf "Docker Image: cuahsi/wrfhydro-nwm:5.0.3\n"
printf '%s\n\n' '----------------------------------'

if [ -d "OUTPUT" ]; then
  rm OUTPUT/* >/dev/null 2>&1
else
  mkdir OUTPUT
fi

docker run -d --rm \
   --mount type=bind,source="$(pwd)"/DOMAIN,target=/home/docker/RUN/DOMAIN \
   --mount type=bind,source="$(pwd)"/OUTPUT,target=/home/docker/RUN/OUTPUT \
   --mount type=bind,source="$(pwd)"/FORCING,target=/home/docker/RUN/FORCING \
   --mount type=bind,source="$(pwd)"/configs/hydro.namelist,target=/home/docker/RUN/hydro.namelist \
   --mount type=bind,source="$(pwd)"/configs/namelist.hrldas,target=/home/docker/RUN/namelist.hrldas \
   cuahsi/wrfhydro-nwm:5.0.3 \
   -c "./wrf_hydro.exe && mv *_DOMAIN* OUTPUT" >/dev/null 2>&1



echo "Running Simulation"
current_progress=0
sleeptime=3 # initial sleeptime to wait for output to be created
d1=$(date -j -f "%Y%m%d%H%M" $st +%s)
d3=$(date -j -f "%Y%m%d%H%M" $et +%s)
while [ $current_progress -lt 100 ]; do
    sleep $sleeptime
    sleeptime=1

    # get the latest file
    latestdate=$(ls OUTPUT | grep .*LDASOUT.* | tail -1 | cut -d/ -f2 | cut -d. -f1)

    if [ ! -z "$latestdate" ]; then

	# calculate date diff
        d2=$(date -j -f "%Y%m%d%H%M" $latestdate +%s)
	diff=$(bc -l <<< "scale=2; ($d2 - $d1) / ($d3 - $d1) * 100")

        # Draw the progress bar
	current_progress=${diff%.*}
        formatted_date=$(date -j -f "%Y%m%d%H%M" $latestdate +"%Y-%m-%d %H:%M")
	label=$(echo "Simulation Time: $formatted_date")
        progressBar 100 $current_progress $label
    fi
done
printf "\n\nComplete\n"
printf "Output data is located in ./OUTPUT\n"
printf '%s\n\n' '----------------------------------'
