#!/bin/bash
#####################################################################################
#                                                                                   #
#  Script to update HostName  and Federate AppServer profile                        #
#                                                                                   #
#  Usage : updateHostAndFederateServer.sh                                           # 
#                                                                                   #
#####################################################################################

setEnv()
{
     #Check whether profile name is provided or use default
     if [ "$PROFILE_NAME" = "" ] 
     then
          PROFILE_NAME="AppSrv01"
     fi

     #Check whether node name is provided or use default
     if [ "$NODE_NAME" = "" ] 
     then
          NODE_NAME="ServerNode"
     fi

     #Check whether dmgr host is provided or use default
     if [ "$DMGR_HOST" = "" ]
     then
          DMGR_HOST="dmgr"
     fi

     #Check whether dmgr port is provided or use default
     if [ "$DMGR_PORT" = "" ]
     then
          DMGR_PORT="8879"
     fi

     #Get the container hostname
     host=`hostname`
}

startNodeAndServer()
{
     echo "Starting nodeagent..............."
     /opt/IBM/WebSphere/AppServer/profiles/$PROFILE_NAME/bin/startNode.sh

     #if nodeagent started successfully , start the server
     if [ $? = 0 ]
     then
           echo "Starting server......................."
           /opt/IBM/WebSphere/AppServer/profiles/$PROFILE_NAME/bin/startServer.sh server1
     else
           echo " Nodeagent startup failed , exiting....... "
           exit 1
     fi
}

stopServerAndNode()
{
     echo "Stopping server......................."
     /opt/IBM/WebSphere/AppServer/profiles/$PROFILE_NAME/bin/stopServer.sh server1

     if [ $? = 0 ]
     then
           echo " Server stopped successfully. "
     fi

     echo "Stopping nodeagent..............."
     /opt/IBM/WebSphere/AppServer/profiles/$PROFILE_NAME/bin/stopNode.sh

     if [ $? = 0 ]
     then
           echo " Nodeagent stopped successfully. "
     fi
}

updateHostNameAndAddNode()
{
     # Update the hostname
     /opt/IBM/WebSphere/AppServer/bin/wsadmin.sh -lang jython -conntype NONE -f /work/updateHostName.py \
     ServerNode $host
    
     # Add the node
     /opt/IBM/WebSphere/AppServer/bin/addNode.sh $DMGR_HOST $DMGR_PORT

     touch /work/nodefederated
}

renameNode()
{
      # rename the node
      /opt/IBM/WebSphere/AppServer/profiles/$PROFILE_NAME/bin/renameNode.sh $DMGR_HOST $DMGR_PORT $NODE_NAME
}

if [ "$WAIT" != "" ] && [ ! -f "/work/nodefederated" ]
then
      sleep $WAIT
fi

setEnv

# check if nodeagent already created
if [ -d /opt/IBM/WebSphere/AppServer/profiles/$PROFILE_NAME/logs/nodeagent ]
then
      startNodeAndServer
else
      updateHostNameAndAddNode
        
      # Rename the node name and start the node
      if [ $NODE_NAME != "ServerNode" ]
      then
           renameNode
           startNodeAndServer
      fi
fi

trap "stopServerAndNode" SIGTERM

sleep 10

while [ -f "/opt/IBM/WebSphere/AppServer/profiles/$PROFILE_NAME/logs/nodeagent/nodeagent.pid" ]
do
    sleep 5
done
