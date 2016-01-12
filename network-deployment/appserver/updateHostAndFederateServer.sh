#!/bin/bash
#####################################################################################
#                                                                                   #
#  Script to update HostName  and Federate AppServer profile                        #
#                                                                                   #
#                                                                                   #
#  Usage : updateHostAndFederateServer.sh                                           # 
#                                                                                   #
#  Author : Kavitha                                                                 #
#                                                                                   #
#####################################################################################

if [ "$PROFILE_NAME" = "" ] 
then
     PROFILE_NAME="AppSrv01"
fi

if [ "$NODE_NAME" = "" ] 
then
     NODE_NAME="ServerNode"
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

# check if nodeagent already created
if [ -d /opt/IBM/WebSphere/AppServer/profiles/$PROFILE_NAME/logs/nodeagent ]
then
        echo "Starting nodeagent..............."
	/opt/IBM/WebSphere/AppServer/profiles/$PROFILE_NAME/bin/startNode.sh
else
	# Update the hostname
	/opt/IBM/WebSphere/AppServer/bin/wsadmin.sh -lang jython -conntype NONE -f /opt/IBM/WebSphere/AppServer/bin/updateHostName.py \
        ServerNode $host
     
	# Add the node
	/opt/IBM/WebSphere/AppServer/bin/addNode.sh $DMGR_HOST $DMGR_PORT

        # Rename the node name and start the node
	if [ $NODE_NAME != "ServerNode" ]
	then
	        # rename the node
        	/opt/IBM/WebSphere/AppServer/profiles/$PROFILE_NAME/bin/renameNode.sh $DMGR_HOST $DMGR_PORT $NODE_NAME
      
                echo "Starting nodeagent................"
	        /opt/IBM/WebSphere/AppServer/profiles/$PROFILE_NAME/bin/startNode.sh
        fi
fi


#if nodeagent started successfully , start the server
if [ $? = 0 ]
then
        echo "Starting server......................."
	/opt/IBM/WebSphere/AppServer/profiles/$PROFILE_NAME/bin/startServer.sh server1
else
        echo " Nodeagent startup failed , exiting....... "
	exit 1
fi

# Exit the container if server startup fails
if [ $? != 0 ]
then
	echo " Server startup failed , exiting.........."
        exit 1
fi

sleep 10

while [ -f "/opt/IBM/WebSphere/AppServer/profiles/$PROFILE_NAME/logs/nodeagent/nodeagent.pid" ]
do
    sleep 5
done




