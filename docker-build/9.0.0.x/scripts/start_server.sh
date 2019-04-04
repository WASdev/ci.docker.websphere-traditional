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
        find /etc/websphere -type f \( -name \*.props -o -name \*.conf \) -print0 | sort -z | xargs -0 -n 1 -r /work/applyConfig.sh
  fi
}

configure_logging(){
  echo "Configure logging mode"
  /work/configure_logging.sh
}

echo "ENABLE_BASIC_LOGGING is $ENABLE_BASIC_LOGGING"
ENABLE_BASIC_LOGGING=${ENABLE_BASIC_LOGGING:-"false"}

if [ "$ENABLE_BASIC_LOGGING" = false ]; then
  configure_logging
fi

applyConfigs

if [ "$EXTRACT_PORT_FROM_HOST_HEADER" = "true" ]; then
  /work/applyConfig.sh /work/config-ibm/webContainer.props
fi

if ! cmp -s "/tmp/passwordupdated" "/tmp/PASSWORD"; then
  /work/set_password.sh
fi

if [ "$UPDATE_HOSTNAME" = "true" ] && [ ! -f "/work/hostnameupdated" ]; then
  update_hostname
fi

trap "stop_server" TERM INT

start_server || exit $?
PID=$(ps -C java -o pid= | tr -d " ")

if [ "$ENABLE_BASIC_LOGGING" = true ]; then
  echo "Basic Logging is enabled"
  tail -F /opt/IBM/WebSphere/AppServer/profiles/$PROFILE_NAME/logs/$SERVER_NAME/SystemOut.log --pid $PID -n +0 &
  tail -F /opt/IBM/WebSphere/AppServer/profiles/$PROFILE_NAME/logs/$SERVER_NAME/SystemErr.log --pid $PID -n +0 >&2 &
else
  echo "HPEL is enabled"
  rm -f /opt/IBM/WebSphere/AppServer/profiles/$PROFILE_NAME/logs/$SERVER_NAME/SystemOut.log*
  rm -f /opt/IBM/WebSphere/AppServer/profiles/$PROFILE_NAME/logs/$SERVER_NAME/SystemErr.log*
  run_logviewer
fi

while [ -e "/proc/$PID" ]; do
  ps cax | grep logViewer > /dev/null
  if [ $? -eq 0 ]; then
    echo "logViewer is running." > /dev/null
  else
    if [ "$ENABLE_BASIC_LOGGING" = false ]; then
      echo "logViewer is not running.  Restarting" > /dev/null
      /opt/IBM/WebSphere/AppServer/bin/logViewer.sh -monitor -resumable -resume -format json | grep "^{" &
    fi
  fi
  sleep 1
done

echo "WAS server1 is not running.  Stopping logViewer"

PID=`ps cax | grep logViewer`
if [ $? -eq 0 ]; then
  kill -3 $PID
  exit 0
fi
