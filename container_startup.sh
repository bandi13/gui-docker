#!/bin/bash
OUR_IP=$(hostname -i)

#start VNC server (Uses VNC_PASSWD Docker ENV variable)
mkdir -p $HOME/.vnc && x11vnc -storepasswd $VNC_PASSWD $HOME/.vnc/passwd
# -noxrecord is to solve a 'stack smashing' bug: https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=859213
x11vnc -rfbauth $HOME/.vnc/passwd -shared -forever -usepw -create -env FD_PROG=/opt/x11vnc_entrypoint.sh -noxrecord &
#start noVNC web server
/opt/noVNC/utils/launch.sh --listen 5901 &

echo -e "\n\n------------------ VNC environment started ------------------"
echo -e "\nVNCSERVER started on DISPLAY= $DISPLAY \n\t=> connect via VNC viewer with $OUR_IP:5900"
echo -e "\nnoVNC HTML client started:\n\t=> connect via http://$OUR_IP:5901/?password=$VNC_PASSWD\n"

if [ -z "$1" ]; then
  tail -f /dev/null
else
  # unknown option ==> call command
  echo -e "\n\n------------------ EXECUTE COMMAND ------------------"
  echo "Executing command: '$@'"
  exec "$@"
fi
