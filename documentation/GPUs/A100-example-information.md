
Example order:
Processor   2x AMD EPYC 7763: 64 cores, 2.45 GHz, 256 MB cache, PCIe 4.0
GPUs    8x NVIDIA A100 (80 GB): With NVLink and NVSwitch fabric
Memory  2048 GB
Operating system drive  2x 2 TB | NVMe | M.2
Extra storage   6x 3.84 TB | 2.5" | NVMe
It looks like from the order you have:

Chassis Documentation:
- Supermicro | AS-4124GO-NART (AMD) | 8x A100 SXM4 80GB with NVSwitch and AMD CPUs
- https://www.supermicro.com/en/Aplus/system/4U/4124/AS-4124GO-NART.cfm
   *  The Specifications section has a good summary of requirements and what is supported
- https://www.supermicro.com/manuals/superserver/4U/MNL-2379.pdf
   * With SXM GPUs we do need to RMA the entire chassis due to the GPUs are soldered to the GPU Board, and the OEM needs to repair.

So for Software, configuration, debugging (on a machine with A100 and NVLink/NVSwitch):
- Kernel parameter should be set:  iommu=soft (this can be seen in /etc/default/grub) and from cat /proc/cmdline
- The Lambda Stack will keep the version of NVIDIA Driver matched with nvidia-fabricmanager. 
- If you choose to  install other drivers, just make sure the Driver version is the same as the nvidia-fabricmanager version.
- You can check on the status of the fabric manager and nvlinks with:
   * systemctl status nvidia-fabricmanager
   * nvidia-smi topo -m
   * nvidia-smi nvlink -s
- On the A100's you can check for remapped memory and if it succeeded:
   * nvidia-smi --query-remapped-rows=gpu_bus_id,gpu_uuid,remapped_rows.correctable,remapped_rows.uncorrectable,remapped_rows.pending,remapped_rows.failure --format=csv
   *  or use nvidia-smi -q and look for the section.
 - Examples on images:
![alt text](https://github.com/markwdalton/lambdalabs/blob/main/documentation/GPUs/NVIDIA-GPU-Remapping-worked.png "Remapping Worked")</p>
![alt text](https://github.com/markwdalton/lambdalabs/blob/main/documentation/GPUs/NVIDIA-GPU-Remapping-failure.png "Remapping Failed")</p>

Useful Debugging information:

GPU/nvidia-fabric Errors and information for reference:</p>
General GPU Errors:
- https://docs.nvidia.com/deploy/xid-errors/index.html
    * The main one would be Xid 79 * a reboot is needed to recover, but if it repeats and it is not due to the below or a fabric issue it may need to be RMAed
- For A100's there are some special Xid (NVIDIA GPU) errors:
    * https://docs.nvidia.com/deploy/gpu-debug-guidelines/index.html
    * https://docs.nvidia.com/deploy/a100-gpu-mem-error-mgmt/index.html
- For NVSwitch various issues can be seen:
    * https://docs.nvidia.com/datacenter/tesla/pdf/fabric-manager-user-guide.pdf

NVIDIA A100 GPU Temperature and Power per GPU:
```
    Temperature
        GPU Shutdown Temp                 : 92 C
        GPU Slowdown Temp                 : 89 C
        GPU Max Operating Temp            : 85 C
        Memory Current Temp               : 47 C
        Memory Max Operating Temp         : 95 C
    Power Readings
        Power Management                  : Supported
        Power Limit                       : 400.00 W
        Default Power Limit               : 400.00 W
        Enforced Power Limit              : 400.00 W
        Min Power Limit                   : 100.00 W
```
