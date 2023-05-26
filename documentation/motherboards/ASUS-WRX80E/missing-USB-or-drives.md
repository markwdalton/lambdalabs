**NVMe Issues with missing devices (USB/Drives) on the WRX80E motherboard**

Specific issues:
1. Recently there has been a issue were the USB or a drive may not be seen.
2. Or the USB Ubuntu live would boot, but would crash/reboot
3. Or the USB Ubuntu live would get to grub and start, but could not find the USB root.

The workaround has been:
a. Fastboot should always be disabled in the BIOS
b. The new thing is SR-IOV needed to be <b>Enabled</b> in the BIOS (image below).
c. At times we have seen the need to set on the kernel line: pci=realloc=off

As shown in the following images:
      ![alt text](https://github.com/markwdalton/lambdalabs/blob/main/documentation/motherboards/ASUS-WRX80E/ASUS-WRX80E-SR-IOV-BIOS-Setting.png "Enable SR-IOV in the BIOS")</p>
      ![alt text](https://github.com/markwdalton/lambdalabs/blob/main/documentation/motherboards/ASUS-WRX80E/ASUS-WRX80E-Disable-Fast-Boot.png "Disable Fast Boot")</p>
