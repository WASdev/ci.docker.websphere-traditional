#!/bin/bash
#####################################################################################
#                                                                                   #
#  Script to start the Deployment Manager                                           #
#                                                                                   #
#  Usage : startDmgr.sh                                                             #
#                                                                                   #
#####################################################################################

echo "Starting deployment manager ............"

if [ "$UPDATE_HOSTNAME" = "true" ] && [ ! -f "/work/hostnameupdated" ]
then
    #Get the container hostname
    host=`hostname`

    #Check whether node name is provided or use default
    if [ "$NODE_NAME" = "" ]
    then
       NODE_NAME="DefaultNode01"
    fi

    # Update the hostname
    /opt/IBM/WebSphere/AppServer/bin/wsadmin.sh -lang jython -conntype NONE -f /work/updateHostName.py \
    $NODE_NAME $host

    touch /work/hostnameupdated

fi

if [ "$PROFILE_NAME" = "" ]
then
    PROFILE_NAME="Dmgr01"
fi

/opt/IBM/WebSphere/AppServer/bin/startManager.sh

if [ $? != 0 ]
then
    echo " Dmgr startup failed , exiting....."
fi

sleep 10

while [ -f "/opt/IBM/WebSphere/AppServer/profiles/$PROFILE_NAME/logs/dmgr/dmgr.pid" ]
do
    sleep 5
done
