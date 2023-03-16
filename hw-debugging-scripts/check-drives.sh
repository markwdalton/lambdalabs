#!/bin/sh

# This requires smartmontools.
#
# How to run:
#    $ sudo apt install smartmontools
#    $ sudo sh ~/Downloads/check-drives.sh
#
# This runs 'lsblk' to check for drives installed/seen on the system.
# Then checks for errors on the drives then on each drive runs:
#    sudo smartctl -x /dev/<drive>
# Then packages the data up to send.
#
DRIVES=$(lsblk | egrep "^sd|^nvm"  | awk '{print $1}')

mkdir -p check-drives
lsblk > check-drives/lsblk.txt

for DRIVE in ${DRIVES} ; do
   smartctl -x /dev/${DRIVE} > check-drives/smartctl-${DRIVE}.txt 2>&1
done

tar -zcf check-drives.tgz check-drives
echo " "
echo "Please send the file 'check-drives.tgz' which contains the following:"
echo " "
tar -ztvf check-drives.tgz

