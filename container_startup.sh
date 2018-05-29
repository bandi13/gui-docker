#!/bin/bash
OUR_IP=$(hostname -i)

#start VNC server (Uses VNC_PASSWD Docker ENV variable)
mkdir -p /opt/.vnc && x11vnc -storepasswd $VNC_PASSWD /opt/.vnc/passwd
# -noxrecord is to solve a 'stack smashing' bug: https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=859213
x11vnc -rfbauth /opt/.vnc/passwd -shared -forever -usepw -create -env FD_PROG=/opt/x11vnc_entrypoint.sh -noxrecord &
#start noVNC web server
/opt/noVNC/utils/launch.sh --listen 5901 &
# Start up second server to allow shared sessions
/opt/noVNC/utils/launch.sh --listen 5902 &

echo -e "\n\n------------------ VNC environment started ------------------"
echo -e "\nVNCSERVER started on DISPLAY= $DISPLAY \n\t=> connect via VNC viewer with $OUR_IP:5900"
echo -e "\nnoVNC HTML client started:\n\t=> connect via http://$OUR_IP:5901/?password=$VNC_PASSWD\n"

if [ -z "$1" ]; then
    echo -e "\n------------------ $HOME/.vnc/*$DISPLAY.log ------------------"
    tail -f $HOME/.vnc/*$DISPLAY.log
else
    # unknown option ==> call command
    echo -e "\n\n------------------ EXECUTE COMMAND ------------------"
    echo "Executing command: '$@'"
    exec "$@"
fi
