#!/bin/bash
#####################################################################################
#                                                                                   #
#  Script to start the Deployment Manager                                           #
#                                                                                   #
#                                                                                   #
#  Usage : startDmgr.sh                                                             #
#                                                                                   #
#  Author : Kavitha                                                                 #
#                                                                                   #
#####################################################################################

echo "Starting deployment manager ............"

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




