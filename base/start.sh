#!/bin/bash
#####################################################################################
#                                                                                   #
#  Script to start the server                                                       #
#                                                                                   #
#  Usage : start.sh                                                                 # 
#                                                                                   #
#####################################################################################

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

#Check whether profile name is provided or use default
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

#Check the existence of server process
while [ -f "/opt/IBM/WebSphere/AppServer/profiles/$PROFILE_NAME/logs/server1/server1.pid" ]
do
    sleep 5
done
