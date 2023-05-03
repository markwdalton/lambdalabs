# lambdalabs
lambdalabs scripts 

These are just drafts of my write ups.  Feel free to use/change/contribute.

check-drives.sh             - Runs lsblk, and does smartctl -x on each drive
check-nvidia-bug-report.sh  - A quick script to parse the nvidia-bug-report.log (using xid-errors.csv)
sensors-ipmi-1hour.sh       - For Servers or Workstations with IPMI collects data for 1 hour (IPMI & nvidia)
sensors-ipmi.sh             - For Servers or Workstations with IPMI collects data forever  (IPMI & nvidia)
                            - Normally when a system crashes this may be helpful
xid-errors.csv              - Used by check-nvidia-bug-report.sh
