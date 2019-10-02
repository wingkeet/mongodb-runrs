#!/bin/bash
if [ -z $1 ]; then
  portnum=28001
else
  portnum=$1
fi
./mongodb/bin/mongo --port $portnum
