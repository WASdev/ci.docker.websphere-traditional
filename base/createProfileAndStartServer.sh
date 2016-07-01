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

   #Check whether server name is provided or use default
   if [ "$SERVER_NAME" = "" ]
   then
      SERVER_NAME="server1"
   fi
}

startServer()
{
   echo "Starting server ..................."
   /opt/IBM/WebSphere/AppServer/profiles/$PROFILE_NAME/bin/startServer.sh $SERVER_NAME

   if [ $? != 0 ]
   then
      echo " Application Server startup  failed , exiting ........"
      exit 1
   fi
}

stopServer()
{
   echo "Stopping server ..................."
   /opt/IBM/WebSphere/AppServer/profiles/$PROFILE_NAME/bin/stopServer.sh $SERVER_NAME

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
      -nodeName $NODE_NAME -cellName $CELL_NAME -hostName $HOST_NAME \
      -serverName $SERVER_NAME -enableAdminSecurity true -adminUserName wsadmin -adminPassword wsadmin
      
}


setEnv

#if profile is already created just start the server
if [ -d /opt/IBM/WebSphere/AppServer/profiles/$PROFILE_NAME/logs/$SERVER_NAME ]
then
   startServer
else
   createProfile
   if [ $? = 0 ]
   then
      if [ ! -f "/work/passwordupdated" ]
      then
           /work/modifyPassword.sh
      fi
      startServer
   else
      echo " Profile creation failed , exiting ........"
      exit 1
   fi
fi

trap "stopServer" SIGTERM

sleep 10

#Check the existence of server process
while [ -f "/opt/IBM/WebSphere/AppServer/profiles/$PROFILE_NAME/logs/$SERVER_NAME/$SERVER_NAME.pid" ]
do
   sleep 5
done
