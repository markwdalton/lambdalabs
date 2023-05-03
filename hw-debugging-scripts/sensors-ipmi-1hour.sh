#!/bin/bash

# README
# sudo apt install ipmitool
# sudo sh ~/Downloads/sensors-ipmi-1hour.sh .
# Then send the resulting 'sensors.tgz'
# If applicable you can change:
#   The FREQUENCY (Default every 10 seconds).
#   The DURATION (Default is for 10 minutes).

mkdir sensors
cd sensors
# Duration how long to run in minutes:
DURATION_MINUTES=60
# How often to check in seconds
FREQUENCY=10

COUNT=$(echo "${DURATION_MINUTES} * 60 / ${FREQUENCY}" | bc)
DURATION_SEC=$(echo "${DURATION_MINUTES} * 60" | bc)

sudo ipmitool sel elist > ipmi-sel.txt 2>&1

i=1
while [ ${i} -le ${COUNT} ]; do
    DATE=$(date +%Y%m%dT%H%M%S)
    DATE2=$(date +%Y-%m-%dT%H:%M:%S)
    TODAY=$(date +%Y%m%d)
    TIME=$(echo ${DATE} | cut -f2 -d"T")
    mkdir -p ${TODAY}
    sleep 1 

    nvidia-smi -q > ${TODAY}/nvidia-smi-q.${DATE}  2>&1
    sudo ipmitool sdr > ${TODAY}/ipmitool-sdr.${DATE} 2>&1
    nvidia-smi --query-gpu=index,pci.bus_id,uuid,pstate,fan.speed,utilization.gpu,utilization.memory,temperature.gpu,temperature.memory,power.draw --format=csv | sed "s/^/${DATE2},/g" >> gpu-summary.csv
    nvidia-smi --query-gpu=index,pci.bus_id,uuid,clocks_throttle_reasons.applications_clocks_setting,clocks_throttle_reasons.sw_power_cap,clocks_throttle_reasons.hw_slowdown,clocks_throttle_reasons.hw_thermal_slowdown,clocks_throttle_reasons.hw_power_brake_slowdown,clocks_throttle_reasons.sw_thermal_slowdown --format=csv | sed "s/^/${DATE2},/g" >>  gpu-throttle.csv
    sleep ${FREQUENCY}
    i=$(echo "$i + 1" | bc)
done
cd ..
tar -zcf sensors.tgz sensors
echo "Please send the resulting 'sensors.tgz' file."
ls -ld sensors.tgz
