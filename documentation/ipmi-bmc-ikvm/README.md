
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
<p><b>Install ipmitool:</b>
   <p>   $ sudo apt-get install ipmitool
<p><b>List the users</b>
   <p>  $ sudo ipmitool user list
<p><b>Change the password for User ID 2 (from previous ‘user list’)</b>
   <p>  $ sudo ipmitool user set password 2
   <p>       Then, enter the new password twice.
<p><b>Cold reset the BMC - normally only needed when the BMC is not getting updates:</b>
   <p>  $ sudo ipmitool mc reset cold
<p><b>Print the BMC network information:</b>
   <p>  $ sudo ipmitool lan print
<p><b>Print the BMC Event log</b>
   <p>  $ sudo ipmitool sel elist
<p><b>Print Sensor information:</b>
   <p>  $ sudo ipmitool sdr
   <p>  $ sudo ipmitool sensor
<p><b>Print Information about the system:</b>
   <p>  $ sudo ipmitool fru
<p>
<p><b>IPMI Example setting up a static IP address:</b>
  <p>If you were given:
       <p>  IPMI/BMC IP address: 10.0.1.120
       <p>  Netmask: 255.255.255.0
       <p>  Gateway: 10.0.1.1

  <p>Then the configuration would be:
    <p><b>Confirm current settings:</b>
            <p>  $ sudo ipmitool lan print 1
    <p><b>Set the IPMI Interface to Static (default is dhcp)</b>
            <p>  $ sudo ipmitool lan set 1 ipsrc static
    <p><b>Set the IP Address:</b>
            <p>  $ sudo ipmitool lan set 1 ipaddr 10.0.1.120
    <p><b>Set the netmask for this network:</b>
            <p>  $ sudo ipmitool lan set 1 netmask 255.255.255.0
    <p><b>Set the Default Gateway</b>
            <p>  $ sudo ipmitool lan set 1 defgw ipaddr 10.0.1.1
    <p><b>Set/confirm that LAN (network) access is enabled:</b>
            <p>  $ sudo ipmitool lan set 1 access on

<p>Common request is getting the sensor and event log output..
<p>1. On the node from linux:
         <p>  $ sudo apt install ipmitool
         <p>  $ sudo ipmitool sdr >& ipmi-sdr.txt
         <p>  $ sudo ipmitool sel elist >& ipmi-sel.txt
        
      <p>Or from a remote linux machine:
          <p>  $ ipmitool -I lanplus -H IP_ADDRESS -U ADMIN -P "PASSWORD" sel elist >& ipmi-sel.txt
          <p>  $ ipmitool -I lanplus -H IP_ADDRESS -U ADMIN -P "PASSWORD" sdr >& ipmi-sdr.txt
             <p>  -> Where 'PASSWORD' would be your IPMI password, and IP_ADDRESS is your 
               machines BMC/IPMI ip address.
 
<p>Or at least the Web GUI can save the cvs of the eventlog.
      <p>  BMC/IPMI -> Logs and Reports -> Event Log -> Save to excel (CSV).
