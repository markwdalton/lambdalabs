
From kern.log or dmesg
```
      Xid (PCI:0000:??:00): 119 - Timeout waiting for RPC from GSP!
      Xid (PCI:0000:??:00): 79  - GPU has fallen off the bus
```

This can be fixed by disabling GSP.

* To disable the GSP, a known fix on other GPUs:
...* To disable GSP-RM:
```
sudo su -c 'echo options nvidia NVreg_EnableGpuFirmware=0 > /etc/modprobe.d/nvidia-gsp.conf'
```
* Enable the kernel
```
sudo update-initramfs -u
```
* Reboot
* Check if work. If EnableGpuFirmware: 0 then GSP-RM is disabled.
```
cat /proc/driver/nvidia/params | grep EnableGpuFirmware
```
 
