#!/bin/bash
#####################################################################################
#                                                                                   #
#  Script to create AppServer profile and start the server                          #
#                                                                                   #
#                                                                                   #
#  Usage : createProfileAndStartServer.sh                                           # 
#                                                                                   #
#  Author : Kavitha                                                                 #
#                                                                                   #
#####################################################################################

if [ "$PROFILE_NAME" = "" ] 
then
     PROFILE_NAME="AppSrv01"
fi

if [ "$CELL_NAME" = "" ] 
then
     CELL_NAME="DefaultCell01"
fi

if [ "$NODE_NAME" = "" ] 
then
     NODE_NAME="DefaultNode01"
fi

if [ "$HOST_NAME" = "" ] 
then
     HOST_NAME="localhost"
fi


#if profile already created just start the server
if [ -d /opt/IBM/WebSphere/AppServer/profiles/$PROFILE_NAME/logs/server1 ]
then
     echo "Starting server ....................."
     /opt/IBM/WebSphere/AppServer/profiles/$PROFILE_NAME/bin/startServer.sh server1
else
     echo "Creating profile ...................."
     /opt/IBM/WebSphere/AppServer/bin/manageprofiles.sh -create -profileName $PROFILE_NAME \
     -profilePath /opt/IBM/WebSphere/AppServer/profiles/$PROFILE_NAME  \
     -templatePath /opt/IBM/WebSphere/AppServer/profileTemplates/default \
     -nodeName $NODE_NAME -cellName $CELL_NAME -hostName $HOST_NAME

     if [ $? = 0 ]
     then
        echo "Starting server ..................."
     	/opt/IBM/WebSphere/AppServer/profiles/$PROFILE_NAME/bin/startServer.sh server1
     else
        echo " Profile creation failed , exiting ........"
        exit 1
     fi
fi

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




