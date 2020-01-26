#!/bin/bash

source mongodb.conf

if [ -z $1 ]; then
    port=${mongodb_ports[0]}
else
    port=$1
fi

./mongodb/bin/mongo --port $port
