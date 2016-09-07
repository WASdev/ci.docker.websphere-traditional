#!/bin/bash
#####################################################################################
#                                                                                   #
#  Script to modify the wsadmin password                                            #
#                                                                                   #
#  Usage : modifyPassword.sh                                                        #
#                                                                                   #
#####################################################################################

if [ -f /tmp/PASSWORD ]
then
    password=`cat /tmp/PASSWORD`
else
    password=$(openssl rand -base64 6)

    touch /tmp/pass
    echo $password > /tmp/PASSWORD
fi

/opt/IBM/WebSphere/AppServer/bin/wsadmin.sh -lang jython -conntype NONE -f /work/updatePassword.py $password > /dev/null 2>&1

touch /work/passwordupdated
