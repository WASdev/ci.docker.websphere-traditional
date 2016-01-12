#!/bin/bash
#####################################################################################
#                                                                                   #
#  Script to update the Hostname and add the node to deployment manager             #
#                                                                                   #
#                                                                                   #
#  Usage : updateHostAndAddNode.sh                                                  # 
#                                                                                   #
#  Author : Kavitha                                                                 #
#                                                                                   #
#####################################################################################

if [ "$PROFILE_NAME" = "" ] 
then
     PROFILE_NAME="Custom01"
fi

if [ "$NODE_NAME" = "" ] 
then
     NODE_NAME="CustomNode"
fi

if [ "$DMGR_HOST" = "" ]
then
     DMGR_HOST="dmgr"
fi

if [ "$DMGR_PORT" = "" ]
then
     DMGR_PORT="8879"
fi

host=`hostname`

if [ -d /opt/IBM/WebSphere/AppServer/profiles/$PROFILE_NAME/logs/nodeagent ]
then
        # Start the node
        echo "Starting nodeagent.................."
	/opt/IBM/WebSphere/AppServer/profiles/$PROFILE_NAME/bin/startNode.sh
else
        # Add the node
        /opt/IBM/WebSphere/AppServer/bin/addNode.sh $DMGR_HOST $DMGR_PORT

        # Update the hostname
        /opt/IBM/WebSphere/AppServer/bin/wsadmin.sh -lang jython -conntype SOAP -host $DMGR_HOST \
        -port $DMGR_PORT -f /opt/IBM/WebSphere/AppServer/bin/updateHostName.py CustomNode $host
 
        # Rename and start the node
        if [ $NODE_NAME != "CustomNode" ]
        then
                # rename the node
                /opt/IBM/WebSphere/AppServer/profiles/$PROFILE_NAME/bin/renameNode.sh $DMGR_HOST $DMGR_PORT $NODE_NAME
                
                echo "Starting nodeagent ........................"
                /opt/IBM/WebSphere/AppServer/profiles/$PROFILE_NAME/bin/startNode.sh
        fi

       
fi

# Exit the container , if nodeagent startup fails
if [ $? != 0 ]
then
     " NodeAgent startup failed , exiting......"
     exit 1
fi
    
sleep 10

while [ -f "/opt/IBM/WebSphere/AppServer/profiles/$PROFILE_NAME/logs/nodeagent/nodeagent.pid" ]
do
    sleep 5
done




