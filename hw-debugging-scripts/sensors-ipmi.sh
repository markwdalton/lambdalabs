#!/bin/bash

# README
# sudo apt install ipmitool
# mkdir sensors
# cd sensors
# cp ~/Downloads/sensors-ipmi.sh .
# sudo sh sensors-ipmi.sh
# And control-C or kill it off when done
# Then tar up the directory to share.
# If applicable you can change the FREQUENCY (Default every 10 seconds).

# How often to check in seconds
FREQUENCY=10

sudo ipmitool sel elist > ipmi-sel.txt 2>&1

i=1
while [ $i = 1 ]; do
    DATE=$(date +%Y%m%dT%H%M%S)
    DATE2=$(date +%Y-%m-%dT%H:%M:%S)
    TODAY=$(date +%Y%m%d)
    TIME=$(echo ${DATE} | cut -f2 -d"T")
    mkdir -p ${TODAY}
    sleep 1 

    nvidia-smi -q > ${TODAY}/nvidia-smi-q.${DATE}  2>&1
    ipmitool sdr > ${TODAY}/ipmitool-sdr.${DATE} 2>&1
    nvidia-smi --query-gpu=index,pci.bus_id,uuid,pstate,fan.speed,utilization.gpu,utilization.memory,temperature.gpu,temperature.memory,power.draw --format=csv | sed "s/^/${DATE2},/g" >> gpu-summary.csv
    sleep ${FREQUENCY}
done
