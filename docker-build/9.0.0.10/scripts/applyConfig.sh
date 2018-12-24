#!/bin/bash
if [ ! -z "$1" ]; then
        /opt/IBM/WebSphere/AppServer/bin/wsadmin.sh -conntype None -f /work/applyConfig.py $1
        exit 0
elif [ $( ls -larth /work/config/*.props | wc -l) -gt 1  ]; then
         for i in $(ls /work/config/*.props); do
           /work/applyConfig.sh $i
         done
fi

