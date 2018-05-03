FROM    ubuntu:17.10

# Needed for 'apt install'
ENV DEBIAN_FRONTEND noninteractive

# for the VNC connection
EXPOSE 5900
# for the browser VNC client
EXPOSE 5901
# for the browser VNC client (Shared session)
EXPOSE 5902

# Make sure the package repository is up to date
RUN apt-get update
RUN apt install -y x11vnc xvfb fluxbox git net-tools python python-numpy

# Install VNC. Requires net-tools, python and python-numpy
RUN git clone https://github.com/novnc/noVNC.git /opt/noVNC
RUN git clone https://github.com/novnc/websockify.git /opt/noVNC/utils/websockify
RUN ln -s /opt/noVNC/vnc_lite.html /opt/noVNC/index.html

# Copy various files to their respective places
COPY container_startup.sh /opt/container_startup.sh
COPY x11vnc_entrypoint.sh /opt/x11vnc_entrypoint.sh
# Subsequent images can put their scripts to run at startup here
RUN mkdir /opt/startup_scripts

# Initial fluxbox menu
RUN mkdir -p /root/.fluxbox && echo "[begin] (fluxbox)\n[include] (/etc/X11/fluxbox/fluxbox-menu)\n[end]" > /root/.fluxbox/menu

ENTRYPOINT ["/opt/container_startup.sh"]
CMD "/bin/bash"
