**Common Linux issues**


1. If your machine is 'going to sleep' and not waking up.  This is often due to the machine sleep/hibernate, which only makes sense to do a notebook.
```
  Masking - making them 'invisible' effectively:
   This would disable sleep/hibernate/suspend:
      $ sudo systemctl mask sleep.target suspend.target hibernate.target hybrid-sleep.target
```
2. At times the machine may come up with a blank screen.  
```
   This is often due to either the terminal is used for the port or the /etc/X11/xorg.conf was added/modified.
   a. On a desktop you can go in to the terminal:
        'control-alt-F2' (or up to 'control-alt-F5').  And it should bring you to a text terminal login prompt
        'control-alt-F1' should bring you to the graphical login.
      You can check if there is a /etc/X11/xorg.conf
        $ ls -l /etc/X11/xorg.conf
      And remove it with:
        $ sudo rm /etc/X11/xorg.conf
   b. Other issues may require booting in recovery mode or from a USB to remove the /etc/X11/xorg.conf
   c. Another is if the grub install had a issue, and to fix that see:
        The file 'fix-grub.txt'
```
3. You can change you workstation or for a server make sure it is not running in Desktop mode.
```
This shows way to switch between server (multi-user) and Desktop (graphical) modes:
   Show the default target/runlevel:
     $ systemctl get-default
   Set the target to multi-user:
     $ sudo systemctl set-default multi-user
   Set the default target to graphical:
     $ sudo systemctl set-default graphical

   Temporarily change to multi-user:
     $ sudo systemctl isolate multi-user
   Temporarily change to graphical:
     $ sudo systemctl isolate graphical
```
