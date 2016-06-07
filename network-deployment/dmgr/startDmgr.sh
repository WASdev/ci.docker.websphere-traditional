#!/bin/bash
#####################################################################################
#                                                                                   #
#  Script to start the Deployment Manager                                           #
#                                                                                   #
#  Usage : startDmgr.sh                                                             #
#                                                                                   #
#####################################################################################

update_host_node_name()
{
    #Get the container hostname
    host=`hostname`

    #Check whether node name is provided or use default
    if [ "$NODE_NAME" = "" ]
    then
       NODE_NAME="DefaultNode01"
    else
       # Update the nodename
       /opt/IBM/WebSphere/AppServer/bin/wsadmin.sh -lang jython -conntype NONE -f /work/updateNodeName.py \
       DefaultNode01 $NODE_NAME
       
       echo "WAS_NODE=$NODE_NAME" >> /opt/IBM/WebSphere/AppServer/bin/setupCmdLine.sh

    fi

    # Update the hostname
    /opt/IBM/WebSphere/AppServer/bin/wsadmin.sh -lang jython -conntype NONE -f /work/updateHostName.py \
    $NODE_NAME $host

    touch /work/host_nodenameupdated
}

startDmgr()
{
    if [ "$PROFILE_NAME" = "" ]
    then
        PROFILE_NAME="Dmgr01"
    fi

    echo "Starting deployment manager ............"
    /opt/IBM/WebSphere/AppServer/bin/startManager.sh

    if [ $? != 0 ]
    then
        echo " Dmgr startup failed , exiting....."
    fi
}

stopDmgr()
{
    if [ "$PROFILE_NAME" = "" ]
    then
        PROFILE_NAME="Dmgr01"
    fi

    echo "Stopping deployment manager ............"
    /opt/IBM/WebSphere/AppServer/bin/stopManager.sh

    if [ $? = 0 ]
    then
        echo " Dmgr stopped successfully. "
    fi
}

if [ ! -f "/work/host_nodenameupdated" ]
then
    update_host_node_name
fi

startDmgr

trap "stopDmgr" SIGTERM

sleep 10

while [ -f "/opt/IBM/WebSphere/AppServer/profiles/$PROFILE_NAME/logs/dmgr/dmgr.pid" ]
do
    sleep 5
done
