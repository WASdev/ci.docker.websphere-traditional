#!/bin/bash
#####################################################################################
#                                                                                   #
#  Script to update the Hostname and add the node to deployment manager             #
#                                                                                   #
#  Usage : updateHostAndAddNode.sh                                                  # 
#                                                                                   #
#####################################################################################

setEnv()
{
     #Check whether profile name is provided or use default
     if [ "$PROFILE_NAME" = "" ] 
     then
          PROFILE_NAME="Custom01"
     fi

     #Check whether node name is provided or use default
     if [ "$NODE_NAME" = "" ] 
     then
          NODE_NAME="CustomNode"
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

addNodeAndUpdateHostName()
{
     # Add the node
     /opt/IBM/WebSphere/AppServer/bin/addNode.sh $DMGR_HOST $DMGR_PORT

     # Update the hostname
     /opt/IBM/WebSphere/AppServer/bin/wsadmin.sh -lang jython -conntype SOAP -host $DMGR_HOST \
     -port $DMGR_PORT -f /work/updateHostName.py CustomNode $host

    touch /work/nodefederated
}

startNode()
{
     # Start the node
     echo "Starting nodeagent.................."
     /opt/IBM/WebSphere/AppServer/profiles/$PROFILE_NAME/bin/startNode.sh

     # Exit the container , if nodeagent startup fails
     if [ $? != 0 ]
     then
          "NodeAgent startup failed , exiting......"
          exit 1
     fi
}

stopNode()
{
     # Stop the node
     echo "Stopping nodeagent.................."
     /opt/IBM/WebSphere/AppServer/profiles/$PROFILE_NAME/bin/stopNode.sh
 
     if [ $? = 0 ]
     then
          echo "NodeAgent stopped successfully."
     fi
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

if [ -d /opt/IBM/WebSphere/AppServer/profiles/$PROFILE_NAME/logs/nodeagent ]
then
     startNode
else
     addNodeAndUpdateHostName
     # Rename and start the node
     if [ $NODE_NAME != "CustomNode" ]
     then
          renameNode
          startNode
     fi
fi

trap "stopNode" SIGTERM
    
sleep 10

while [ -f "/opt/IBM/WebSphere/AppServer/profiles/$PROFILE_NAME/logs/nodeagent/nodeagent.pid" ]
do
    sleep 5
done
