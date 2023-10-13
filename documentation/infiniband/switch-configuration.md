#### Switch configuration

* The configuration may vary depending on the switch and the OS on the switch.
..* Onyx, Cumulus, MLX-OS, etc.
..*
* [Example configuration via CLI and web](https://lambdalabs.com/blog/setting-up-a-mellanox-infiniband-switch-sb7800-36-port-edr)
```
$ ssh admin@10.1.10.136
Password (type admin for the password):
Mellanox Switch

switch-hostname > enable
switch-hostname # configure terminal
switch-hostnam (config) # ib smnode my-sm enable
  * Where 'my-sm' is the switches hostname
switch-hostnam (config) # configuration write
```

