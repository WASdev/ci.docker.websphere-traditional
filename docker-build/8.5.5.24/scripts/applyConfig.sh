#!/bin/bash
if [ ! -z "$1" ]; then
        /opt/IBM/WebSphere/AppServer/bin/wsadmin.sh -conntype None -f /work/applyConfig.py $1
        exit 0
else 
      find /work/config -type f -name "*.props"  -print0 | sort -z | xargs -0 -n 1 -r /work/applyConfig.sh
fi