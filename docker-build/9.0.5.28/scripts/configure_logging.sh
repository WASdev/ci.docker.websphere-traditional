ENABLE_BASIC_LOGGING="${ENABLE_BASIC_LOGGING:-false}"

if [ "$ENABLE_BASIC_LOGGING" = false ]; then
	/opt/IBM/WebSphere/AppServer/bin/wsadmin.sh -conntype None -f /work/configHPEL.py
fi
