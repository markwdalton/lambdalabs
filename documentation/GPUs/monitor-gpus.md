```
         $ nvidia-smi
         $ nvidia-smi topo -m
         $ nvidia-smi -q
         $ nvidia-smi -q -d TEMPERATURE
             * or many other options
         $ sudo nvidia-smi -i 3 -r
             * Reset GPU ID 3 - if no jobs running and may need to remove kernel modules
         $ nvidia-smi --query-gpu=index,pci.bus_id,uuid,pstate,fan.speed,utilization.gpu,utilization.memory,temperature.gpu,temperature.memory,power.draw --format=csv
         $ nvidia-smi --query-gpu=index,pci.bus_id,uuid,clocks_throttle_reasons.active --format=csv
         $ nvidia-smi dmon -s pc
         $ nvidia-smi dmon -s upvme

           [-s | --select]:   One or more metrics [default=puc]
                              Can be any of the following:
                              p - Power Usage and Temperature
                              u - Utilization
                              c - Proc and Mem Clocks
                              v - Power and Thermal Violations
                              m - FB and Bar1 Memory
                              e - ECC Errors and PCIe Replay errors
                              t - PCIe Rx and Tx Throughput

         NVIDIA Profiler
         $ nvprof python yourcode.py
         $ nvprof --print-gpu-trace python yourcode.py

         $ sudo nvidia-bug-report.sh
            - This generates a file 'nvidia-bug-report.log.gz'

         Xid error messages can be found in the nvidia-bug-report.log.gz and
           those come from both: /var/log/dmesg* and /var/log/kern.log*

         General Definitions: https://docs.nvidia.com/deploy/xid-errors/index.html
```

|                              **Linux/Ubuntu/NVIDIA tools for monitoring utilization**                                                                                     |
|------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| **For GPUs it is important to associate the GPUs PCI Address with the GPU UUID (index is relative)**                                                                       |
|   nvidia-smi --query-gpu=index,pci.bus_id,uuid --format=csv                                                                                                            |
|------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| **Shows the linux top process based on CPU, memory (rss) virtual memory**                                                                                                  |
|   top                                                                                                                                                                  |
|------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| **Alternate view of top:**                                                                                                                                                 |
|   htop                                                                                                                                                                 |
| **View the processes on GPUs**                                                                                                                                             |
|   nvidia-smi pmon                                                                                                                                                      |
|   nvidia-smi dmon -s pc                                                                                                                                                |
| **Show GPU view power, temp, memory on GPUs over time**                                                                                                                    |
|   nvidia-smi dmon                                                                                                                                                      |
| **Show GPU stats and environment over time in CSV format**                                                                                                                 |
|   nvidia-smi --query-gpu=index,pci.bus_id,uuid,fan.speed,utilization.gpu,utilization.memory,temperature.gpu,power.draw --format=csv -l                                 |
|   nvidia-smi --help-query-gpu                                                                                                                                          |

___


| **On Commercial GPUs like A100’s**                                                                                                                                     |
|:-----------------------------------------------------------------------------------------------------------------------------------------------------------------------|
|   **You can see these all through:**                                                                                                                                   |
|      nvidia-smi -q                                                                                                                                                     |
|   **You can monitor for memory temperature also:**                                                                                                                     |
|     nvidia-smi --query-gpu=index,pci.bus_id,uuid,pstate,fan.speed,utilization.gpu,utilization.memory,temperature.gpu,temperature.memory,power.draw --format=csv -l     | 
|   **And you can watch for remapped memory (requires a reboot/reset of the GPU):**                                                                                      |
|    nvidia-smi --query-remapped-rows=gpu_bus_id,gpu_uuid,remapped_rows.correctable,remapped_rows.uncorrectable,remapped_rows.pending,remapped_rows.failure --format=csv 
   + 8 banks in a row can be remapped, but requires a reboot between each remap.
   + After 8 banks in a row are remapped the GPU or chassis (SXM) needs to be reworked.
   + If remapped_rows.failure == yes  ; Disable GPU ; Machine needs a RMA to repair
   + If remapped_rows.pending == yes ; then GPU needs to be reset (commonly high number of aggregate errors).

|   **And you can watch for Volatile (current boot session - more accurate) and Aggregate (life time of GPU - in theory all but misses some) memory errors:**            |
|     **To see the various memory errors to track:**                                                                                                                     |
|        nvidia-smi --help-query-gpu | grep "ecc.err"                                                                                                                    |
|    For example:                                                                                                                                                        |
|     **All volatile memory errors (this boot session or since a GPU reset):**                                                                                           |
|       nvidia-smi --query-gpu=index,pci.bus_id,uuid,ecc.errors.corrected.volatile.dram,ecc.errors.corrected.volatile.sram  --format=csv                                 |
|     **All volatile uncorrected memory errors:**                                                                                                                        |
|        nvidia-smi --query-gpu=index,pci.bus_id,uuid,ecc.errors.corrected.volatile.dram,ecc.errors.corrected.volatile.sram  --format=csv                                |
|     **All Aggregate corrected memory errors:**                                                                                                                         |
|       nvidia-smi --query-gpu=index,pci.bus_id,uuid,ecc.errors.uncorrected.aggregate.dram,ecc.errors.uncorrected.aggregate.sram --format=csv                            |
|     **All Aggregate uncorrected memory errors:**                                                                                                                       |
|       nvidia-smi --query-gpu=index,pci.bus_id,uuid,ecc.errors.uncorrected.aggregate.dram,ecc.errors.uncorrected.aggregate.sram --format=csv                            |
