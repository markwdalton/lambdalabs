## Install OFED mellanox firmware, commands and tools

### Make sure you have OFED driver and tools installed as shown in:
   * <A HREF=https://github.com/markwdalton/lambdalabs/tree/main/documentation/infiniband/OFED-Install.md>Install OFED and tools</A>

### Explaining a few variables:
  * LINK_TYPE has 1 is Infiniband, 2 is Ethernet
  * If it is one port card you would just put: (Setting to GigE)
```
    ** set LINK_TYPE_P1=2
```
  * If it is a two port card you would set port 1 to Infiniband and Port 2 to GigE:
```
    ** set LINK_TYPE_P1=1
    ** set LINK_TYPE_P2=2
```

### Setup the Cards for and linux server on Ubuntu
1. Run 'mst start'
```
   root@lambda-server:~$ sudo mst start
```
2. Check the status to find the card path:
```
   root@lambda-server:~$ sudo mst status

   MST modules:
   ------------
    MST PCI module is not loaded
    MST PCI configuration module loaded

   MST devices:
   ------------
   /dev/mst/mt4123_pciconf0         - PCI configuration cycles access.
                                      domain:bus:dev.fn=0000:01:00.0 addr.reg=88 data.reg=92 cr_bar.gw_offset=-1
                                      Chip revision is: 00
   /dev/mst/mt4123_pciconf1         - PCI configuration cycles access.
                                      domain:bus:dev.fn=0000:81:00.0 addr.reg=88 data.reg=92 cr_bar.gw_offset=-1
                                      Chip revision is: 00
```
3. Configure  (NOTE from 'sudo mst status' you will see available cards)
```
root@lambda-server:~$ ibstat will show how many ports per card
root@lambda-server:~$ sudo mlxconfig -d /dev/mst/mt4123_pciconf0 set LINK_TYPE_P1=1 LINK_TYPE_P2=2
   Device #1:
   ----------
   Device type:    ConnectX6
   Name:           MCX653106A-HDA_Ax
   Description:    ConnectX-6 VPI adapter card; HDR IB (200Gb/s) and 200GbE; dual-port QSFP56; PCIe4.0 x16; tall bracket; ROHS R6
   Device:         /dev/mst/mt4123_pciconf0
   Configurations:                              Next Boot       New
         LINK_TYPE_P1                        IB(1)           IB(1)
         LINK_TYPE_P2                        IB(1)           ETH(2)
    Apply new Configuration? (y/n) [n] : y
   Applying... Done!
   -I- Please reboot machine to load new configurations.


   root@lambda-server:~$ sudo mlxconfig -d /dev/mst/mt4123_pciconf0 query | grep ETH
         LINK_TYPE_P1                        IB(1)
         LINK_TYPE_P2                        ETH(2)
         KEEP_ETH_LINK_UP_P1                 True(1)
         KEEP_ETH_LINK_UP_P2                 True(1)
```

4. Lambda server card was just a 1 port card:
```
   root@lambda-server:~$ mlxconfig -d /dev/mst/mt4123_pciconf1 set LINK_TYPE_P1=2

   Device #1:
   ----------
   Device type:    ConnectX6
   Name:           MCX653105A-HDA_Ax
   Description:    ConnectX-6 VPI adapter card; HDR IB (200Gb/s) and 200GbE; single-port QSFP56; PCIe4.0 x16; tall bracket; ROHS R6
   Device:         /dev/mst/mt4123_pciconf1
   Configurations:                              Next Boot       New
         LINK_TYPE_P1                        IB(1)           ETH(2)


   ## Confirm: For the Lambda-server card:
   root@lambda-server:/etc/netplan# mlxconfig -d /dev/mst/mt4123_pciconf1 query | grep ETH
         LINK_TYPE_P1                        ETH(2)          
         KEEP_ETH_LINK_UP_P1                 True(1)         
```

5. Then you need to reboot to get this machine up with the new interface type
```
root@lambda-server:~$ sudo reboot
```

