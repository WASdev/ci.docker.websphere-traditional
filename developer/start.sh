#!/bin/bash
#####################################################################################
#                                                                                   #
#  Script to start the server                                                       #
#                                                                                   #
#  Usage : start.sh                                                                 #
#                                                                                   #
#####################################################################################

setEnv()
{
   #Check whether profile name is provided or use default
   if [ "$PROFILE_NAME" = "" ]
   then
      PROFILE_NAME="AppSrv01"
   fi

}

update_hostname()
{
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
}

startServer()
{
   echo "Starting server......................."
   /opt/IBM/WebSphere/AppServer/profiles/$PROFILE_NAME/bin/startServer.sh server1

   if [ $? != 0 ]
   then
      echo " AppServer startup failed , exiting......"
      exit 1
   fi
}


stopServer()
{
   #Check whether profile name is provided or use default
   if [ "$PROFILE_NAME" = "" ]
   then
      PROFILE_NAME="AppSrv01"
   fi

   echo "Stopping server......................."
   /opt/IBM/WebSphere/AppServer/profiles/$PROFILE_NAME/bin/stopServer.sh server1

   if [ $? = 0 ]
   then
      echo " AppServer stopped successfully "
   fi
}

setEnv

if [ ! -f "/work/passwordupdated" ]
then
   /work/modifyPassword.sh
fi


if [ "$UPDATE_HOSTNAME" = "true" ] && [ ! -f "/work/hostnameupdated" ]
then
   update_hostname
fi 

startServer

trap "stopServer" SIGTERM

sleep 10

#Check the existence of server process
while [ -f "/opt/IBM/WebSphere/AppServer/profiles/$PROFILE_NAME/logs/server1/server1.pid" ]
do
   sleep 5
done
