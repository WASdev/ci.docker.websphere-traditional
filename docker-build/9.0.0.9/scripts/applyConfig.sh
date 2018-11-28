#!/bin/bash
if [ ! -z "$1" ]; then
	/opt/IBM/WebSphere/AppServer/bin/wsadmin.sh -conntype None -f /work/applyConfig.py $1
	exit 0
fi

if [ -f /work/config/was-config.props ]; then
	/opt/IBM/WebSphere/AppServer/bin/wsadmin.sh -conntype None -f /work/applyConfig.py /work/config/was-config.props
fi
