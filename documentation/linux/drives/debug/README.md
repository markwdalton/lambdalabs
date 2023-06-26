# What to do if the drive is not found.

1. If it is a ASUS WRX80E motherboard see <A HREF="https://github.com/markwdalton/lambdalabs/blob/main/documentation/motherboards/ASUS-WRX80E/missing-USB-or-drives.md">Missing drive on the WRX80E motherboard</A>
2. The other ways to find if there is a issue:
..*If there were past fsck's done.  fsck needing to be done is a sign of a problem.
..*You can check the BIOS to see if it can see the drive.
..*The most reliable way is to boot from a 'Ubuntu Install USB' and select 'Try Ubuntu' on the desktop install or hit 'control-z' on server installs. (instructions below).


# Boot from USB Install Drive and do a drive check (smartctl).
1. Download either Ubuntu 22.04 LTS (Desktop or Server for servers).
2. On the Desktop version:
..*Select 'Try Ubuntu' versus install
..*Open a Terminal (control-alt-t)
..*Install 'smartmontools':
```
   $ sudo apt install smartmontools
```
..*Run lsblk to see what drives are found:
```
$ sudo lsblk
```
3. Run a script that will find and check each drive:
..*Download script:
```
   $ wget https://github.com/markwdalton/lambdalabs/blob/main/hw-debugging-scripts/check-drives.sh
```

..*Run the script:
```
  $ sudo sh ./check-drives.sh
    - This will create a directory check-drives
    - And tar the results to 'check-drives.tgz'
      Attach this to your ticket.
```

