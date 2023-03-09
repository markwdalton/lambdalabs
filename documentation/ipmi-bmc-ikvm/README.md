
<b>IPMI - is the standard for hardware based platform management<\b>
+This is common on servers, but some workstations have this to a degree.

-> [IPMI Wikipedia](https://en.wikipedia.org/wiki/Intelligent_Platform_Management_Interface)
-> This allows you to remotely manage your system:
  +Read sensors even when the OS is not running
  +Remote console via the web GUI or with setup using ipmi command line

- You may have heard of forks of this that are vendor specific:
   +idrac - for Dell
   +ilo - for HP

Common command line options:
For servers with IPMI:
<b>Install ipmitool:</b>
   $ sudo apt-get install ipmitool
<b>List the users</b>
  $ sudo ipmitool user list
<b>Change the password for User ID 2 (from previous ‘user list’)</b>
  $ sudo ipmitool user set password 2
        Then, enter the new password twice.
<b>Cold reset the BMC - normally only needed when the BMC is not getting updates:</b>
  $ sudo ipmitool mc reset cold
<b>Print the BMC network information:</b>
  $ sudo ipmitool lan print
<b>Print the BMC Event log</b>
  $ sudo ipmitool sel elist
<b>Print Sensor information:</b>
  $ sudo ipmitool sdr
  $ sudo ipmitool sensor
<b>Print Information about the system:</b>
  $ sudo ipmitool fru

<b>IPMI Example setting up a static IP address:</b>
  If you were given:
      IPMI/BMC IP address: 10.0.1.120
      Netmask: 255.255.255.0
      Gateway: 10.0.1.1

  Then the configuration would be:
    <b>Confirm current settings:</b>
           $ sudo ipmitool lan print 1
    <b>Set the IPMI Interface to Static (default is dhcp)</b>
           $ sudo ipmitool lan set 1 ipsrc static
    <b>Set the IP Address:</b>
           $ sudo ipmitool lan set 1 ipaddr 10.0.1.120
    <b>Set the netmask for this network:</b>
           $ sudo ipmitool lan set 1 netmask 255.255.255.0
    <b>Set the Default Gateway</b>
           $ sudo ipmitool lan set 1 defgw ipaddr 10.0.1.1
    <b>Set/confirm that LAN (network) access is enabled:</b>
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
