*At times you may see GPUs or Drives not seen*
*BAR Memory shows:
* BAR #; failed to assign ...
* BAR #: no space for ...
You can see the errors in dmesg during the boot:
```
[   23.869384] pci 0000:51:00.0: BAR 15: no space for [mem size 0x04000000 64bit pref]
[   23.869386] pci 0000:51:00.0: BAR 15: failed to assign [mem size 0x04000000 64bit pref]
[   23.869389] pci 0000:52:10.0: BAR 15: no space for [mem size 0x04000000 64bit pref]
[   23.869392] pci 0000:52:10.0: BAR 15: failed to assign [mem size 0x04000000 64bit pref]
[   23.869395] pci 0000:53:00.0: BAR 0: no space for [mem size 0x02000000 64bit pref]
[   23.869398] pci 0000:53:00.0: BAR 0: failed to assign [mem 0x8fffc000000-0x8fffdffffff 64bit pref]
[   23.869400] pci 0000:53:00.1: BAR 0: no space for [mem size 0x02000000 64bit pref]
[   23.869403] pci 0000:53:00.1: BAR 0: failed to assign [mem 0x8fffa000000-0x8fffbffffff 64bit pref]
```

The most common solution for this is:
* Set SR-IOV to enabled in the BIOS
* Set Above 4G Decoding to enabled in the BIOS (it should be already enabled on servers)

Then also set the kernel boot parameter pci=realloc=off
* Either edit on the boot grub or you can set it in /etc/default/grub
```
sudo sed -iE '/^GRUB_CMDLINE.*DEFAULT/ s/".*$/ pci=realloc=off"/' /etc/default/grub && \
sudo update-grub 
```
