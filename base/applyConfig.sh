#!/bin/bash
if [ -f /work/was-config.props ]; then
	/opt/IBM/WebSphere/AppServer/bin/wsadmin.sh -conntype None -f /work/applyConfig.py
fi
