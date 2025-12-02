#!/bin/bash
#####################################################################################
#                                                                                   #
#  Script to set the wsadmin password.                                              #
#  If a value exists in /tmp/PASSWORD that value will be used,                      #
#  otherwise a random value will be generated and used (and also                    #
#  persisted in /tmp/PASSWORD).                                                     #
#                                                                                   #
#  Usage : set_password                                                             #
#                                                                                   #
#####################################################################################

ADMIN_USER_NAME=${ADMIN_USER_NAME:-"wsadmin"}

if [ -f /tmp/PASSWORD ]
then
  password=$(cat /tmp/PASSWORD)
else
  password=$(openssl rand -base64 6)
  echo $password > /tmp/PASSWORD
fi

/opt/IBM/WebSphere/AppServer/bin/wsadmin.sh -lang jython -conntype NONE -f /work/updatePassword.py $ADMIN_USER_NAME $password > /dev/null 2>&1
echo $password > /tmp/passwordupdated
