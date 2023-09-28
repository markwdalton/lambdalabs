**NCCL Would Hang**

This can happen for various reasons:
1. ACSCtl - is enabled in the BIOS
2. Hardware issue (for example one NVLink is broken) (nvidia-smi topo -m) - Avoid that GPU pair and replace the NVLink
3. On older kernels on AMD >= 4x NVIDIA GPUS without iommu=soft any multi-GPU job may hang.  Solution add iommu=soft to /etc/default/grub
4. on a Supermicro SYS-421GE-TNRT.  The solution was to run the and turn off ACSCtl on all PCI devices:
..*Taken from: https://discuss.pytorch.org/t/single-machine-ddp-issue-on-a6000-gpu/134869/14
```
#!/bin/bash
#
# Copyright (c) 2018, NVIDIA CORPORATION.  All rights reserved.
#
# NVIDIA CORPORATION and its licensors retain all intellectual property
# and proprietary rights in and to this software, related documentation
# and any modifications thereto.  Any use, reproduction, disclosure or
# distribution of this software and related documentation without an express
# license agreement from NVIDIA CORPORATION is strictly prohibited.
#

# must be root to access extended PCI config space
if [ "$EUID" -ne 0 ]; then
  echo "ERROR: $0 must be run as root"
  exit 1
fi

for BDF in `lspci -d "*:*:*" | awk '{print $1}'`; do

    # skip if it doesn't support ACS
    setpci -v -s ${BDF} ECAP_ACS+0x6.w > /dev/null 2>&1
    if [ $? -ne 0 ]; then
            #echo "${BDF} does not support ACS, skipping"
            continue
    fi

    logger "Disabling ACS on `lspci -s ${BDF}`"
    setpci -v -s ${BDF} ECAP_ACS+0x6.w=0000
    if [ $? -ne 0 ]; then
        logger "Error disabling ACS on ${BDF}"
            continue
    fi
    NEW_VAL=`setpci -v -s ${BDF} ECAP_ACS+0x6.w | awk '{print $NF}'`
    if [ "${NEW_VAL}" != "0000" ]; then
        logger "Failed to disable ACS on ${BDF}"
            continue
    fi
done
exit 0
```
