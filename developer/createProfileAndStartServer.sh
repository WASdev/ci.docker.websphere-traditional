#!/bin/bash
#####################################################################################
#                                                                                   #
#  Script to create AppServer profile and start the server                          #
#                                                                                   #
#  Usage : createProfileAndStartServer.sh                                           #
#                                                                                   #
#####################################################################################

setEnv()
{
   #Check whether profile name is provided or use default
   if [ "$PROFILE_NAME" = "" ] 
   then
      PROFILE_NAME="AppSrv01"
   fi

   #Check whether cell name is provided or use default
   if [ "$CELL_NAME" = "" ] 
   then
      CELL_NAME="DefaultCell01"
   fi

   #Check whether node name is provided or use default
   if [ "$NODE_NAME" = "" ] 
   then
      NODE_NAME="DefaultNode01"
   fi

   #Check whether host name is provided or use default
   if [ "$HOST_NAME" = "" ] 
   then
      HOST_NAME="localhost"
   fi
}

startServer()
{
   echo "Starting server ..................."
   /opt/IBM/WebSphere/AppServer/profiles/$PROFILE_NAME/bin/startServer.sh server1

   if [ $? != 0 ]
   then
      echo " Application Server startup  failed , exiting ........"
      exit 1
   fi
}

stopServer()
{
   echo "Stopping server ..................."
   /opt/IBM/WebSphere/AppServer/profiles/$PROFILE_NAME/bin/stopServer.sh server1

   if [ $? = 0 ]
   then
      echo " Application Server stopped successfully."
   fi
}

createProfile()
{
   echo "Creating profile ...................."
   /opt/IBM/WebSphere/AppServer/bin/manageprofiles.sh -create -profileName $PROFILE_NAME \
      -profilePath /opt/IBM/WebSphere/AppServer/profiles/$PROFILE_NAME  \
      -templatePath /opt/IBM/WebSphere/AppServer/profileTemplates/default \
      -nodeName $NODE_NAME -cellName $CELL_NAME -hostName $HOST_NAME
}


setEnv

#if profile is already created just start the server
if [ -d /opt/IBM/WebSphere/AppServer/profiles/$PROFILE_NAME/logs/server1 ]
then
   startServer
else
   createProfile
   if [ $? = 0 ]
   then
      startServer
   else
      echo " Profile creation failed , exiting ........"
      exit 1
   fi
fi

trap "stopServer" SIGTERM

sleep 10

#Check the existence of server process
while [ -f "/opt/IBM/WebSphere/AppServer/profiles/$PROFILE_NAME/logs/server1/server1.pid" ]
do
   sleep 5
done
