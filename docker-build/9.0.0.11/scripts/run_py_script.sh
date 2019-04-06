ADMIN_USER_NAME=${ADMIN_USER_NAME:-"wsadmin"}
WSADMIN_PASS=$(cat /tmp/PASSWORD)
/opt/IBM/WebSphere/AppServer/bin/wsadmin.sh -user $ADMIN_USER_NAME -password $WSADMIN_PASS -lang jython -f $1 $2
