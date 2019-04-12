#!/bin/bash
#####################################################################################
#                                                                                   #
#  Script to create AppServer profile.                                              #
#                                                                                   #
#  Usage : create_profile                                                           #
#                                                                                   #
#####################################################################################

PROFILE_NAME=${PROFILE_NAME:-"AppSrv01"}
SERVER_NAME=${SERVER_NAME:-"server1"}
ADMIN_USER_NAME=${ADMIN_USER_NAME:-"wsadmin"}

if [ ! -d /opt/IBM/WebSphere/AppServer/profiles/$PROFILE_NAME/logs/$SERVER_NAME ]; then
  HOST_NAME=${HOST_NAME:-"localhost"}
  NODE_NAME=${NODE_NAME:-"DefaultNode01"}
  CELL_NAME=${CELL_NAME:-"DefaultCell01"}
  echo "Creating profile ...................."
  /opt/IBM/WebSphere/AppServer/bin/manageprofiles.sh -create -profileName $PROFILE_NAME \
    -profilePath /opt/IBM/WebSphere/AppServer/profiles/$PROFILE_NAME  \
    -templatePath /opt/IBM/WebSphere/AppServer/profileTemplates/default \
    -nodeName $NODE_NAME -cellName $CELL_NAME -hostName $HOST_NAME \
    -serverName $SERVER_NAME -enableAdminSecurity true -adminUserName $ADMIN_USER_NAME -adminPassword "CHANGEME" -omitAction defaultAppDeployAndConfig deployIVTApplication
  /work/applyConfig.sh /work/config-ibm/jvmUserRoot.props
fi
