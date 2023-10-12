#### Setting Up Slurm with gres and cgroups

* [General Slurm Quick Start](https://slurm.schedmd.com/quickstart_admin.html)

* [Slurm configuration tool](https://slurm.schedmd.com/configurator.html)

Installing on Ubuntu:
* Head node/Slurm node:
```
   sudo apt install slurm slurm-client slurm-wlm slurm-wlm-basic-plugins slurm-wlm-doc slurmd slurmctld slurmdbd munge
```
* Compute nodes:
```
   sudo apt install slurm slurm-client slurm-wlm slurm-wlm-basic-plugins slurm-wlm-doc slurmd munge
```

* Some optional tools:
```
  slurm-wlm-basic-plugins-dev/focal 19.05.5-1 amd64
  slurm-wlm-emulator/focal 19.05.5-1 amd64
  slurm-wlm-torque/focal 19.05.5-1 all
```

* Install cgroup for control:
  sudo apt install cgroup-tools cgroupfs-mount

* Setup the cgroup files:
```
  cd /etc/slurm
  sudo vi cgroup.conf

Add to the cgroup.conf:
###
# Slurm cgroup support configuration file.
###
CgroupAutomount=yes
CgroupMountpoint=/sys/fs/cgroup
# ConstrainCores=yes
ConstrainDevices=yes
# ConstrainRAMSpace=yes
# ConstrainSwapSpace=yes
```
* I have Cgroup.conf disable some due to issues on some machines.
* The ContrainDevices=yes is so that GPUs are dedicated

* Make sure the log directory is created:
```
sudo mkdir /var/log/slurm
sudo chown -R slurm /var/log/slurm
```

* Create or make sure your hostnames are setup for the slurm server and the compute nodes.
* --> This should be created by the install of the packages

* Create your slurm configuration [Slurm configuration tool](https://slurm.schedmd.com/configurator.html)
*  Copy this file to: /etc/slurm/slurm.conf

* Make sure you have the 'slurm' user (should have been created with the package)apt install.   
```
   grep slurm /etc/passwd
```

* Enable the controller on the scheduling host:
```
  sudo systemctl enable slurmctld
```
Optionally:
```
Optionally Enable the slurm database on the scheduling host, which needs mariadb, mysql or text file
  sudo systemctl enable slurmdbd
```
* And for compute nodes:
```
 sudo systemctl enable slurmd
```

* Start daemons on the server:
```
  sudo systemctl start slurmctld
  sudo systemctl start slurmd
``` 

* Debugging start slurmctld in the foreground: 
```
   sudo slurmctld -D -f /etc/slurm/slurm.conf
```

* Then run:
```
  sinfo
```

* If you want PBS/Torque style (qstat) you can install the slurm-wlm-torque plugin.

Now to add gres for GPUs.  Examples:
```
 $ cat /etc/slurm/gres.conf
   Name=gpu Type=3080 File=/dev/nvidia0 Cores=0,1
   Name=gpu Type=3080 File=/dev/nvidia1 Cores=0,1
 $ tail -10 /etc/slurm/slurm.conf
   #
   # COMPUTE NODES
   # NodeName=radonc-dgx-station CPUs=40 RealMemory=250 State=UNKNOWN
   # NodeName=lambda-dual CPUs=24 RealMemory=64 State=UNKNOWN
   # PartitionName=batch Nodes=ALL Default=YES MaxTime=INFINITE State=UP
   # Change to:
   # Add GPU gres
   # Gres:   grestype:optional-type:number-of-resource
   GresTypes=gpu
   NodeName=lambda-dual CPUs=16 RealMemory=64 Sockets=1 CoresPerSocket=16 ThreadsPerCore=1 State=UNKNOWN Gres=gpu:3080:2
   PartitionName=batch Nodes=ALL Default=YES MaxTime=INFINITE State=UP

 $ sudo systemctl restart slurmctld
 $ sudo systemctl restart slurmd
 $ scontrol show node
 $ sinfo
```

* Or for a 8x GPU A100 machine:
```
   $ cat /etc/slurm/gres.conf 
     Name=gpu Type=a100 File=/dev/nvidia0
     Name=gpu Type=a100 File=/dev/nvidia1
     Name=gpu Type=a100 File=/dev/nvidia2
     Name=gpu Type=a100 File=/dev/nvidia3
     Name=gpu Type=a100 File=/dev/nvidia4
     Name=gpu Type=a100 File=/dev/nvidia5
     Name=gpu Type=a100 File=/dev/nvidia6
     Name=gpu Type=a100 File=/dev/nvidia7
   $ tail /etc/slurm/slurm.conf 
     # COMPUTE NODES
     GresTypes=gpu
     NodeName=lambda-hyperplane01 NodeAddr=10.0.10.206 CPUs=64 Boards=1 SocketsPerBoard=2 CoresPerSocket=16 ThreadsPerCore=2 RealMemory=1031736 State=UNKNOWN  Gres=gpu:a100:8
     PartitionName=batch Nodes=ALL Default=YES MaxTime=INFINITE State=UP
```

Example from the commands output:
```
   $ sinfo
     PARTITION AVAIL  TIMELIMIT  NODES  STATE NODELIST
     batch*       up   infinite      1   idle lambda-hyperplane01

   $ scontrol show node
     NodeName=lambda-hyperplane01 CoresPerSocket=16 
     CPUAlloc=0 CPUTot=64 CPULoad=0.00
     AvailableFeatures=(null)
     ActiveFeatures=(null)
     Gres=gpu:a100:8
     NodeAddr=10.0.10.206 NodeHostName=lambda-hyperplane01 
     RealMemory=1031736 AllocMem=0 FreeMem=945488 Sockets=2 Boards=1
     State=IDLE ThreadsPerCore=2 TmpDisk=0 Weight=1 Owner=N/A MCS_label=N/A
     Partitions=batch 
     BootTime=None SlurmdStartTime=None
     CfgTRES=cpu=64,mem=1031736M,billing=64
     AllocTRES=
     CapWatts=n/a
     CurrentWatts=0 AveWatts=0
     ExtSensorsJoules=n/s ExtSensorsWatts=0 ExtSensorsTemp=n/s
```
  
* Again if you prefer the torque/pbs style:
```
    $ sudo apt install slurm-wlm-torque
```
