

Getting your BIOS values is pretty consistent on Supermicro:
```
export BMC_IP=10.0.10.103

Getting the BIOS configuration in json for Supermicro:
  curl -s -k -H'Content-type: application/json' -X GET https://${BMC_IP}/registries/BiosAttributeRegistry.1.0.0.json | jq
```

What BIOS values should be changed:
Examples will be per chassis:
   https://github.com/markwdalton/lambdalabs/blob/main/documentation/BIOS/redfish/Supermicro-Redfish-BIOS-change.txt

+Names are different on each chassis, CPU type and many can also be done on the kernel boot line:
```
 Common Boot lines:
 AMD:
     amd_iommu=on iommu=pt processor.max_cstate=1

   Others:
     pci=realloc pci=nocrs
     kvm_amd.avic=1
     kvm_amd.npt=1
     kvm.ignore_msrs=1

 Intel:
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
  -> ACS  - Disabled to allow NCCL to work
```
