```
 |================================================================================/
 ||                                                                             //
 ||                                                                            //
 ||                   ___      __    __ _     __  ____  __                ////
  \\\\\\             /   |    /  |  / /| |   / / /  _/ / /            /////
        \\\         / /| |   /   | / / | |  / /  / /  / /         /////
          ||       / ___ |  / /| |/ /  | | / /  / /  / /        //
          ||      / /  | | / / |   /   | |/ /  / /  / /___     ||
          ||     /_/   |_|/_/  |__/    |___/ /___/ /_____/     ||
          ||                                                   ||
          ||            /==========================\           ||
          //          //                            \\          \\
         //==========//                              \\==========\\
```
# Auxiliary Networked deVice Interface Link
This project provides a standardized interface for embedded hardware.

## SEGGER JLink Package
This image includes the latest version of SEGGER's JLink software package;  the software is used to
communicate with embedded hardware via an in-circuit programmer/debugger (ie a JLink).
### Technical Details
#### Linux
To allow the non-root user inside the container to have access to the usb device, 
"50-segger-usb.rules" must be placed at "/etc/udev/rules.d/" on the host computer;  this rule
allows Linux users (for host and container) which belong to the "segger_usb_devices" group to have
read and write permissions to devices which have the SEGGER vendor-ID.

When starting the container one should use the following command.  The "-v /dev..." portion creates
a bind mount between the container and the host.  The "--device-cgroup-rule=..." portion allows the
running container to have access to the device even after the JLink has been plugged/replugged;  
the rule depends on the "major group" for the device (in this case 189).
```
docker run -it -v /dev/bus/usb:/dev/bus/usb --device-cgroup-rule='c 189:* rmw' anvil /bin/bash
```
##### How to Identify "Major Group"
Running 'lsusb' will show the bus number, and assignment number for the J-Link device.  Next, run
'ls -al /dev/bus/usb/<BUS_NUMBER>/<ASSIGNMENT_NUMBER>'.  The number before the date will be the 
"Major Group" number.

## Workflow
- Attempting to use Trunk-Based Workflow (https://trunkbaseddevelopment.com)
- Attempting to adhere to Semantic Versioning
