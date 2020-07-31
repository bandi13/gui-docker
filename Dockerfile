FROM    ubuntu:18.04

# for the VNC connection
EXPOSE 5900
# for the browser VNC client
EXPOSE 5901
# Use environment variable to allow custom VNC passwords
ENV VNC_PASSWD=123456

# Make sure the dependencies are met
ENV APT_INSTALL_PRE="apt -o Acquire::ForceIPv4=true update && DEBIAN_FRONTEND=noninteractive apt -o Acquire::ForceIPv4=true install -y --no-install-recommends"
ENV APT_INSTALL_POST="&& apt clean -y && rm -rf /var/lib/apt/lists/*"
# Make sure the dependencies are met
RUN eval ${APT_INSTALL_PRE} tigervnc-standalone-server tigervnc-common fluxbox eterm xterm git net-tools python python-numpy ca-certificates scrot ${APT_INSTALL_POST}

# Install VNC. Requires net-tools, python and python-numpy
RUN git clone --branch v1.2.0 --single-branch https://github.com/novnc/noVNC.git /opt/noVNC
RUN git clone --branch v0.9.0 --single-branch https://github.com/novnc/websockify.git /opt/noVNC/utils/websockify
RUN ln -s /opt/noVNC/vnc.html /opt/noVNC/index.html

# Copy various files to their respective places
COPY container_startup.sh /opt/container_startup.sh
COPY x11vnc_entrypoint.sh /opt/x11vnc_entrypoint.sh
# Subsequent images can put their scripts to run at startup here
RUN mkdir /opt/startup_scripts

# Add menu entries to the container
RUN echo "?package(bash):needs=\"X11\" section=\"DockerCustom\" title=\"Xterm\" command=\"xterm -ls -bg black -fg white\"" >> /usr/share/menu/custom-docker && update-menus

ENTRYPOINT ["/opt/container_startup.sh"]
