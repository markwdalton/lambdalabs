#### Setting Up Slurm from source with gres, cgroups, nvml, and accounting
##### These are just basic instructions, with MIG you may want to use NVML in the gres.conf 
##### Ubuntu packages do not have the NVML plugin.

* [General Slurm Quick Start](https://slurm.schedmd.com/quickstart_admin.html)
* [Slurm configuration tool](https://slurm.schedmd.com/configurator.html)

NOTE:
1. If you have srun jobs hanging, specifically with mpirun + tensorflow it may be the version.  A work around was to use 'salloc' and 'sbatch' but the fix is likely to upgrade slurm.   There was a known issue in 20.11.00 to 20.11.02 (fixed in 20.11.03).
2. If you have a commercial GPU like A100/H100 and want to do MIG, then you may want to recompile slurm to add nvml. NVML is also helpful for mapping based on PCI Bus IDs versus the relative index 0-N (/dev/nvidia#). To build:
```
Example:
 * Prepare for building from source:
   $ sudo apt install git build-essential libhwloc-dev libssl-dev libtirpc-dev libmotif-dev libxext-dev libncurses-dev libdb5.3-dev libpam0g-dev pkgconf libsystemd-dev cmake
 * Make sure ldap or local users for slurm and group slurm (and munge) are on each node.
 * Install database for accounting: (on each node)
   $ sudo apt install mariadb-server munge
 * Install cgroup for control: (on each node)
   $ sudo apt install cgroup-tools cgroupfs-mount

 * Configure to create makefiles:
   $ ./configure --with-nvml=/usr --with-munge=/usr/ --prefix=/opt/slurm/22.05.10 --sysconfdir=/etc/slurm --with-systemdsystemunitdir=/usr/lib/systemd/system 
   -> You may not want the 'systemdsystemunitdir' on new builds if you are doing something like a 'default' link so you can build
      without swapping over until you are ready.  And just create a /opt/slurm/default link to the current default version.
   -> There are also options to built for accounting based on the type of storage MySQL or use MariaDB
       Compile option: --with-mysql_config=PATH
       If installed it should automatically find it.
   $ make
 * Install (note it will go to /opt/slurm/<version> and update /usr/lib/systemd/system/slurm* files.
   $ sudo make install
         * Repeat the 'sudo make install' on each node
```
3. On newer Ubuntu versions you may run into a issue with a error message:
```
$ sudo /opt/slurm/22.05.10/sbin/slurmd -D -s -f /etc/slurm/slurm.conf
slurmd: fatal: Hybrid mode is not supported. Mounted cgroups are: 2:devices:/
1:freezer:/
0::/user.slice/user-1000.slice/user@1000.service/app.slice/app-org.gnome.Terminal.slice/vte-spawn-bd4b89cc-37c2-41a9-8e5e-71633dffd47a.scope
```
To get the cgroups happy now have added 'cgroup_no_v1=all' (disabling cgroups v1):
```
sudo sed -iE '/^GRUB_CMDLINE.*DEFAULT/ s/"$/ cgroup_no_v1=all"/' /etc/default/grub
sudo update-grub
```
4. For Other kernel parameters for cgroups memory and swap:
```
sudo sed -iE '/^GRUB_CMDLINE.*DEFAULT/ s/"$/ cgroup_enable=memory swapaccount=1"/' /etc/default/grub
sudo update-grub
```

=====
#### Installing
##### All nodes should have the same /etc/slurm/slurm.conf
##### All nodes should have the same /etc/munge/munge.key ; and have munge restarted:
```
   After the new munge.key from slurm server is copied on each node, and correct permissions.
   $ sudo ls -l /etc/munge/munge.key
       -r-------- 1 munge munge 1024 May 14  2022 /etc/munge/munge.key
   $ sudo systemctl restart munge
```
##### Head node:
* Main Slurm controller: enable and start 'slurmctld' 
* For accounting enable, start 'slurmctld'
* For running jobs on the head node you can start 'slurmd'
* Setup the /etc/slurm/slurm.conf, /etc/slurm/cgroup.conf (and if using gres.conf at least a empty gres.conf)
* For accounting: Add infor in slurm.conf and setup /etc/slurm/slurmdbd.conf
##### For compute nodes:
* Setup the /etc/slurm/slurm.conf,  /etc/slurm/gres.conf and /etc/slurm/cgroup.conf
* Enable and start the 'slurmd'

* Some optional tools:
```
  slurm-wlm-basic-plugins-dev/focal 19.05.5-1 amd64
  slurm-wlm-emulator/focal 19.05.5-1 amd64
  slurm-wlm-torque/focal 19.05.5-1 all
```
* Setup the cgroup files:
```
  cd /etc/slurm
  sudo vi cgroup.conf

##### Add to the cgroup.conf:
* Slurm cgroup support configuration file.
===== NOTE: This cores for the head node you may not want to constrain all cores/memory.
CgroupAutomount=yes
CgroupMountpoint=/sys/fs/cgroup
ConstrainCores=yes
ConstrainDevices=yes
ConstrainRAMSpace=yes
ConstrainSwapSpace=yes
```
* I have Cgroup.conf disabled for cores/swap/memory, due to issues on single node configs.
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
  And if you want jobs on the head node:
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
or with NVML:
 $ cat /etc/slurm/gres.conf
   AutoDetect=nvml

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
   $ cat /etc/slurm/gres.conf  (or use NVML)
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
     NodeName=lambda-hyperplane01 CPUs=64 Boards=1 SocketsPerBoard=2 CoresPerSocket=16 ThreadsPerCore=2 RealMemory=1031736 State=UNKNOWN  Gres=gpu:a100:8
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
