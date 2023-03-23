
1. If you have linux up and you want to reinstall, find the drive you want to install in 
   a. Run lsblk to determine which drives and the device name
      example:
        $ lsblk
        NAME        MAJ:MIN RM  SIZE RO TYPE MOUNTPOINT
        sda           8:0    0  1.8T  0 disk
        sdb           8:16   0  1.8T  0 disk 
        sr0          11:0    1  9.1G  0 rom
        nvme0n1     259:0    0  1.8T  0 disk
        ├─nvme0n1p1 259:1    0  1.1G  0 part /boot/efi
        └─nvme0n1p2 259:2    0  1.8T  0 part /
        nvme1n1     259:3    0  1.8T  0 disk
   b. Get the serial number of the drive:
        $ sudo apt install smartmontools
        $ sudo smartctl -i /dev/nvme1n1
        smartctl 7.2 2020-12-30 r5155 [x86_64-linux-5.15.0-67-generic] (local build)
        Copyright (C) 2002-20, Bruce Allen, Christian Franke, www.smartmontools.org

        === START OF INFORMATION SECTION ===
        Model Number:                       SAMSUNG MZQL21T9HCJR-00A07
        Serial Number:                      EXAMPLE1234567
        Firmware Version:                   GDC5302Q
          ...
      * Just to have the serial number when you boot, so you can choose where to install from Ubuntu

2. Using the Java Console:
![alt text](https://github.com/markwdalton/lambdalabs/blob/main/documentation/servers/supermicro/Supermicro-Java-remote-mount-iso.png "Using the Java Console to mount iso image")</p>

<p>   a. Login into the BMC/IPMI Web GUI with your IPMI login/password
<p>   b. Select 'Remote Control'
<p>   c. Select 'JAVA plug-in' - and save when it prompts you
<p>   d. Click on 'Launch Console' - this will download a 'launch.jlnp' file.
<p>   e. Download a Java SDK plugin, I used IcedTea (https://openjdk.org/install/)
<p>      For Ubuntu:  sudo apt install icedtea-netx
<p>          https://icedtea.classpath.org/download/
<p>          https://openjdk.org/projects/icedtea/
<p>   f. Use your 'Files' folder to open the file 'launch.jlnp' (right click) and select opening it with IcedTea
<p>   g. Select 'Virtual Media' -> 'Virtual Storage'
<p>        * 'Logical Drive Type' -> 'ISO File'
<p>        * 'Open' -> Find the ISO file image for the install, in this case 'Ubuntu 22.04 LTS Server'
<p>           Select File, then 'Open' button.
<p>        * Click 'Plug in' button
<p>        * Click 'OK' button
<p>      Now you are ready to boot
<p>
3. Booting the system with boot menu</p>

![alt text](https://github.com/markwdalton/lambdalabs/blob/main/documentation/servers/supermicro/Supermicro-boot-choices-Virtual-USB.png "F11 Boot menu selection")</p>
<p>   In the early stages of the boot while it is at the 'F2/Delete to BIOS' or 'F11 for boot menu'
<p>   * Hit - 'F11' - for boot mentu
<p>   * On the boot menu:
<p>     Select: - FI: ATEN Select Virtual CDROM - on device
<p>        * Hit return
<p>   * on blank screen you may need to hit return
  
