start_server()
{
    echo "Starting server ..................."
    /opt/IBM/WebSphere/AppServer/profiles/$PROFILE_NAME/bin/startServer.sh $SERVER_NAME
}

stop_server()
{
    echo "Stopping server ..................."
    kill -s INT $PID
}

echo "Setting Password"
/work/set_password.sh
start_server
PID=$(ps -C java -o pid= | tr -d " ")
echo "Applying configuration"
if [ ! -z "$1" ]; then
    /work/run_py_script.sh "$@"
elif [ ! -z "$(ls /work/config)" ]; then
    echo "+ Found config-files under /work/config. Executing..."
    find /work/config -name "*.py" -exec /work/run_py_script.sh {} \;
fi
work/applyConfig.sh
stop_server
