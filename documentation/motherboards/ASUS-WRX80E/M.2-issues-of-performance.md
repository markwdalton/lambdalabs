**NVMe Issues with performance on the WRX80E motherboard**

General Issues:
1. Performance issues for M.2 or U.2 NVMe drives
2. "Hardware Errors" - correctable:
```[  169.304019] {3}[Hardware Error]: Hardware error from APEI Generic Hardware Error Source: 514
[  169.304022] {3}[Hardware Error]: It has been corrected by h/w and requires no further action
[  169.304023] {3}[Hardware Error]: event severity: corrected
[  169.304024] {3}[Hardware Error]:  Error 0, type: corrected
[  169.304025] {3}[Hardware Error]:   section_type: PCIe error
[  169.304026] {3}[Hardware Error]:   port_type: 0, PCIe end point
[  169.304026] {3}[Hardware Error]:   version: 0.2
[  169.304027] {3}[Hardware Error]:   command: 0x0406, status: 0x0010
[  169.304028] {3}[Hardware Error]:   device_id: 0000:2c:00.0
[  169.304029] {3}[Hardware Error]:   slot: 0
[  169.304029] {3}[Hardware Error]:   secondary_bus: 0x00
[  169.304030] {3}[Hardware Error]:   vendor_id: 0x1022, device_id: 0xb000
[  169.304030] {3}[Hardware Error]:   class_code: 010802
[  169.304031] {3}[Hardware Error]:   bridge: secondary_status: 0x0000, control: 0x0000
```
or
```
[    4.172130] acpi PNP0A08:03: PCIe AER handled by firmware
[   59.749158] nvme 0000:2c:00.0: AER: aer_status: 0x00002001, aer_mask: 0x00000000
[   59.749860] nvme 0000:2c:00.0: AER:	  [ 0] RxErr		      (First)
[   59.750522] nvme 0000:2c:00.0: AER:	  [13] NonFatalErr
[   59.751161] nvme 0000:2c:00.0: AER: aer_layer=Physical Layer, aer_agent=Receiver ID
```

Specific issues:
1. The issue appears to be in the BIOS, and there should be a upcoming fix for this.
2. The issue seems to be with the M.2_1 slot. We have specifically noticed this with U.2 NVMe drives.

If there are 2x U.2, we need the new BIOS, as the M.2_2 will disable U.2_1 and M.2_3 will disable U.2_2.

Work arounds:
1. If there is only 1x M.2 NVMe drive, to move the drive from M.2_1 to M.2_2
2. If there is 1x M.2 NVMe drive AND 1x U.2 NVMe drive move the:
   a. M.2_1 to M.2_2
   b. U.2_1 to U.2_2

As shown in the following images:
      ![alt text](https://github.com/markwdalton/lambdalabs/blob/main/documentation/motherboards/ASUS-WRX80E/ASUS-WRX80E-motherboard-M.2-U.2-moves.png "M.2_1 to M.2_2 and U.2_1 to U.2_2")</p>
      ![alt text](https://github.com/markwdalton/lambdalabs/blob/main/documentation/motherboards/ASUS-WRX80E/ASUS-WRX80E-move-M.2-U.2-drives.png "Diagram M.2_1 to M.2_2 and U.2_1 to U.2_2")</p>
     ![alt text](https://github.com/markwdalton/lambdalabs/blob/main/documentation/motherboards/ASUS-WRX80E/WRX80E-M_2-U_2-drives-info.png "M.2 slots on the motherboard diagram")</p>
     ![alt text](https://github.com/markwdalton/lambdalabs/blob/main/documentation/motherboards/ASUS-WRX80E/WRX80E-U_2-drive-connectors.png "U.2 connectors on the motherboad diagram")</p>
