FROM ubuntu:focal

ARG DEBIAN_FRONTEND="noninteractive"

# for the VNC connection
EXPOSE 5900
# for the browser VNC client
EXPOSE 5901
# Use environment variable to allow custom VNC passwords
ENV VNC_PASSWD=123456

# Make sure the dependencies are met
RUN apt update -y
RUN apt install -y tigervnc-standalone-server tigervnc-common fluxbox eterm xterm git net-tools python python-numpy ca-certificates scrot software-properties-common
RUN add-apt-repository ppa:obsproject/obs-studio && apt update
RUN apt install -y obs-studio
RUN apt clean -y

# Install VNC. Requires net-tools, python and python-numpy
RUN git clone --branch v1.2.0 --single-branch https://github.com/novnc/noVNC.git /opt/noVNC
RUN git clone --branch v0.9.0 --single-branch https://github.com/novnc/websockify.git /opt/noVNC/utils/websockify
RUN ln -s /opt/noVNC/vnc.html /opt/noVNC/index.html

# Add menu entries to the container
RUN echo "?package(bash):needs=\"X11\" section=\"DockerCustom\" title=\"Xterm\" command=\"xterm -ls -bg black -fg white\"" >> /usr/share/menu/custom-docker && update-menus
RUN echo "?package(bash):needs=\"X11\" section=\"DockerCustom\" title=\"OBS\" command=\"obs\"" >> /usr/share/menu/custom-docker

# Set timezone to UTC
RUN ln -snf /usr/share/zoneinfo/UTC /etc/localtime && echo UTC > /etc/timezone

# Add OBS config to root
RUN mkdir -p /config/obs-studio /root/.config/
RUN ln -s /config/obs-studio/ /root/.config/obs-studio

# Add in a health status
HEALTHCHECK --start-period=10s CMD bash -c "if [ \"`pidof -x Xtigervnc | wc -l`\" == "1" ]; then exit 0; else exit 1; fi"

# Add in non-root user
ENV UID_OF_DOCKERUSER 1000
RUN useradd -m -s /bin/bash -g users -u ${UID_OF_DOCKERUSER} dockerUser
RUN chown -R dockerUser:users /home/dockerUser && chown dockerUser:users /opt

USER dockerUser

# Copy various files to their respective places
COPY --chown=dockerUser:users container_startup.sh /opt/container_startup.sh
COPY --chown=dockerUser:users x11vnc_entrypoint.sh /opt/x11vnc_entrypoint.sh

ENTRYPOINT ["/opt/container_startup.sh"]
