# vnc-webclient
Image with a VNC server on port 5900 and a webclient on port 5901 for containerized GUI applications

Here is a screenshot:
![Alt](https://raw.githubusercontent.com/bandi13/vnc-webclient/master/screenshot.png "Example screenshot")

This is based on Ubuntu 17.10 and installs x11vnc for the VNC server, and uses noVNC for the HTML5-based webclient. You can start the container with:

`docker run --shm-size=256m -it -p 5900:5900 -p 5901:5901 -p 5902:5902 bandi13/vnc-webclient`

The shm-size argument is to make sure that the webclient does not run out of shared memory and crash.

Port 5900 is exposing the VNC Server port. The port 5901 and 5902 are using the noVNC webclient. Both ports are connecting to the same server, and are just there to facilitate shared VNC sessions.

Containers that build on this will be able to have scripts run inside the Fluxbox window manager. Any custom scripts can be placed in /opt/startup_scripts.

You can change the default VNC password of '1234' by having the following line in your Dockerfile:

`RUN x11vnc -storepasswd <NewVNCPassword> ~/.vnc/passwd`

Adding in additional menu items to the bottom is as easy as:

`RUN sed -i '$ d' /etc/X11/fluxbox/fluxbox-menu && echo "\t##Your Menu Item Here##\n[end]" >> /etc/X11/fluxbox/fluxbox-menu`
