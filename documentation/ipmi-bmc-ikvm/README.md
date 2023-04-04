
IPMI - is the standard for hardware based platform management<\b>
+This is common on servers, but some workstations have this to a degree.

-> [IPMI Wikipedia](https://en.wikipedia.org/wiki/Intelligent_Platform_Management_Interface)
-> This allows you to remotely manage your system:
  +Read sensors even when the OS is not running
  +Remote console via the web GUI or with setup using ipmi command line

- You may have heard of forks of this that are vendor specific:
   +idrac - for Dell
   +ilo - for HP

Common command line options:
```
For servers with IPMI:
Install ipmitool:
      $ sudo apt-get install ipmitool
List the users
     $ sudo ipmitool user list
Change the password for User ID 2 (from previous ‘user list’)
     $ sudo ipmitool user set password 2
          Then, enter the new password twice.
Cold reset the BMC - normally only needed when the BMC is not getting updates:
     $ sudo ipmitool mc reset cold
Print the BMC network information:
     $ sudo ipmitool lan print
Print the BMC Event log
     $ sudo ipmitool sel elist
Print Sensor information:
     $ sudo ipmitool sdr
     $ sudo ipmitool sensor
Print Information about the system:
     $ sudo ipmitool fru
Power Status:
     $ sudo ipmitool power status
Power control server:
     $ sudo ipmitool power [status|on|off|cycle|reset|diag|soft]
Power on server:
     $ sudo ipmitool power on
Power off server:
     $ sudo ipmitool power off
Power cycle server:
     $ sudo ipmitool power cycle
Power reset the server:
     $ sudo ipmitool power reset

IPMI Example setting up a static IP address:
  If you were given:
         IPMI/BMC IP address: 10.0.1.120
         Netmask: 255.255.255.0
         Gateway: 10.0.1.1

  Then the configuration would be:
    Confirm current settings:
              $ sudo ipmitool lan print 1
    Set the IPMI Interface to Static (default is dhcp)
              $ sudo ipmitool lan set 1 ipsrc static
    Set the IP Address:
              $ sudo ipmitool lan set 1 ipaddr 10.0.1.120
    Set the netmask for this network:
              $ sudo ipmitool lan set 1 netmask 255.255.255.0
    Set the Default Gateway
              $ sudo ipmitool lan set 1 defgw ipaddr 10.0.1.1
    Set/confirm that LAN (network) access is enabled:
              $ sudo ipmitool lan set 1 access on

Common request is getting the sensor and event log output..
1. On the node from linux:
           $ sudo apt install ipmitool
           $ sudo ipmitool sdr >& ipmi-sdr.txt
           $ sudo ipmitool sel elist >& ipmi-sel.txt
        
      Or from a remote linux machine:
            $ ipmitool -I lanplus -H IP_ADDRESS -U ADMIN -P "PASSWORD" sel elist >& ipmi-sel.txt
            $ ipmitool -I lanplus -H IP_ADDRESS -U ADMIN -P "PASSWORD" sdr >& ipmi-sdr.txt
               -> Where 'PASSWORD' would be your IPMI password, and IP_ADDRESS is your 
               machines BMC/IPMI ip address.
 
Or at least the Web GUI can save the cvs of the eventlog.
        BMC/IPMI -> Logs and Reports -> Event Log -> Save to excel (CSV).
```
