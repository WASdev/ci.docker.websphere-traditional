#!/bin/bash
#####################################################################################
#                                                                                   #
#  Script to set the keystore password.                                              #
#  If a value exists in /tmp/KEYSTORE_PASSWORD that value will be used,                      #
#  otherwise a random value will be generated and used (and also                    #
#  persisted in /tmp/KEYSTORE_PASSWORD).                                                     #
#                                                                                   #
#  Usage : set_keystore_password                                                             #
#                                                                                   #
#####################################################################################

KEYSTORE=${KEYSTORE:-"CellDefaultTrustStore"}
NEW_PASSWORD=${NEW_PASSWORD:-$(openssl rand -base64 6)}

if [ -f /tmp/KEYSTORE_PASSWORD ]
then
  oldPassword=$(cat /tmp/KEYSTORE_PASSWORD)
else
  oldPassword="\"\""
fi

echo $NEW_PASSWORD > /tmp/KEYSTORE_PASSWORD

/opt/IBM/WebSphere/AppServer/bin/wsadmin.sh -lang jython -conntype NONE -f /work/updateKeyStorePassword.py $KEYSTORE $oldPassword $NEW_PASSWORD > /dev/null 2>&1
echo $NEW_PASSWORD > /tmp/keystorepasswordupdated