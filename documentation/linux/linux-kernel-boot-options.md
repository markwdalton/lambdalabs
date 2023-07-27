# Linux Kernel boot parameters

A good place for a explanation of the kernel options: [Kernel Parameter guide](https://www.kernel.org/doc/html/latest/admin-guide/kernel-parameters.html)
Common Boot lines:
```
Issues with seeing GPUs?
  * You may see 'BAR memory messages' like:
    [   23.571916] pci 0000:00:1f.4: BAR 0: assigned [mem 0x40000000000-0x400000000ff 64bit]
    [   23.571952] pci 0000:00:1f.5: BAR 1: no space for [mem size 0x02000000]
    [   23.571954] pci 0000:00:1f.5: BAR 1: failed to assign [mem size 0x02000000]
    [   23.571961] pci 0000:00:1f.4: BAR 0: assigned [mem 0x40000000000-0x400000000ff 64bit]
    [   23.571989] pci 0000:00:10.0: BAR 13: no space for [io  size 0x4000]
    [   23.571991] pci 0000:00:10.0: BAR 13: failed to assign [io  size 0x4000]

  * The Fix is normally:
    1. Change the BIOS to set SR_IOV=on
    2. Add the Kernel parameter 'pci=realloc=off'
       $ sudo sed -iE '/^GRUB_CMDLINE.*DEFAULT/ s/"$/ pci=realloc=off"/' /etc/default/grub
      # It is best practice to confirm the edit or other options by viewing this:
       $ more /etc/default/grub
      # Write the config to boot settings
       $ sudo update-grub
      ..
       $ sudo reboot

 AMD: 
    Allowing PCI Pass through on AMD system:
     amd_iommu=on iommu=pt 

   Other options:
     processor.max_cstate=1
     pci=realloc pci=off
     pci=realloc=nocrs
     kvm_amd.avic=1
     kvm_amd.npt=1
     kvm.ignore_msrs=1

 Intel:
  Set the Intel system to PCI Pass through:
     intel_iommu=off iommu=pt
  Others:
     processor.max_cstate=1 intel_idle.max_cstate=0
     mitigations=off
     nohz=off
     skew_tick=1
     mce=ignore_ce
     numa_balancing=disable

     spectre_v2=retpoline

+Common topics are:
  -> ACS  - Disabled to allow NCCL to work (normally done in the BIOS)
```
