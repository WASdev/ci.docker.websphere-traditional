#!/bin/bash
#####################################################################################
#                                                                                   #
#  Script to start the server                                                       #
#                                                                                   #
#                                                                                   #
#  Usage : start.sh                                                                 # 
#                                                                                   #
#  Author : Kavitha                                                                 #
#                                                                                   #
#####################################################################################

if [ "$UPDATE_HOSTNAME" = "true" ]
then
    host=`hostname`
    
    if [ "$NODE_NAME" = "" ]
    then
       NODE_NAME="DefaultNode01" 
    fi

    # Update the hostname
    /opt/IBM/WebSphere/AppServer/bin/wsadmin.sh -lang jython -conntype NONE -f /work/updateHostName.py \
    $NODE_NAME $host

fi

if [ "$PROFILE_NAME" = "" ]
then
    PROFILE_NAME="AppSrv01"
fi

echo "Starting server......................."
/opt/IBM/WebSphere/AppServer/profiles/$PROFILE_NAME/bin/startServer.sh server1

if [ $? != 0 ]
then
    echo " AppServer startup failed , exiting......"
    exit 1
fi

sleep 10

#Check the existence of server proces
while [ -f "/opt/IBM/WebSphere/AppServer/profiles/$PROFILE_NAME/logs/server1/server1.pid" ]
do
    sleep 5
done




