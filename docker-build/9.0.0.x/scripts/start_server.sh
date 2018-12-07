#!/bin/bash
#####################################################################################
#                                                                                   #
#  Script to start the server and wait.                                             #
#                                                                                   #
#  Usage : start_server                                                             #
#                                                                                   #
#####################################################################################

PROFILE_NAME=${PROFILE_NAME:-"AppSrv01"}
SERVER_NAME=${SERVER_NAME:-"server1"}

update_hostname()
{
  wsadmin.sh -lang jython -conntype NONE -f /work/updateHostName.py ${NODE_NAME:-"DefaultNode01"} $(hostname)
  touch /work/hostnameupdated
}

start_server()
{
  echo "Starting server ..................."
  /opt/IBM/WebSphere/AppServer/profiles/$PROFILE_NAME/bin/startServer.sh $SERVER_NAME
}

run_logviewer(){
  echo "run logViewer.sh"
  /opt/IBM/WebSphere/AppServer/bin/logViewer.sh -monitor -resumable -resume -format json | grep "^{" &
}

stop_server()
{
  echo "Stopping server ..................."
  kill -s INT $PID 
}

applyConfigs(){
  if [ ! -z "$(ls /etc/websphere)" ]; then
    echo "+ Found config-files under /etc/websphere. Executing..."
    find /etc/websphere -name "*.props" -exec /work/applyConfig.sh {} \;
  fi
}

applyConfigs

if [ ! -z "$EXTRACT_PORT_FROM_HOST_HEADER" ]; then
  /work/applyConfig.sh /work/config-ibm/webContainer.props
fi

if [ ! -f "/work/passwordupdated" ]; then
  /work/set_password.sh
fi

if [ "$UPDATE_HOSTNAME" = "true" ] && [ ! -f "/work/hostnameupdated" ]; then
  update_hostname.sh
fi

trap "stop_server" TERM INT
start_server || exit $?

PID=$(ps -C java -o pid= | tr -d " ")
echo "$LOGGING_MODE"
LOGGING_MODE=${LOGGING_MODE:-"HPEL"}

if [ -e "/opt/IBM/WebSphere/AppServer/profiles/$PROFILE_NAME/logs/$SERVER_NAME/logdata" ]; then
  echo "HPEL is enabled"
  rm -f /opt/IBM/WebSphere/AppServer/profiles/$PROFILE_NAME/logs/$SERVER_NAME/SystemOut.log*
  rm -f /opt/IBM/WebSphere/AppServer/profiles/$PROFILE_NAME/logs/$SERVER_NAME/SystemErr.log*
  run_logviewer
else
  tail -F /opt/IBM/WebSphere/AppServer/profiles/$PROFILE_NAME/logs/$SERVER_NAME/SystemOut.log --pid $PID -n +0 &
  tail -F /opt/IBM/WebSphere/AppServer/profiles/$PROFILE_NAME/logs/$SERVER_NAME/SystemErr.log --pid $PID -n +0 >&2 &
fi

while [ -e "/proc/$PID" ]; do
  sleep 1
done