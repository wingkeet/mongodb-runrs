#!/bin/bash

mydir="$(dirname $(realpath $0))"
source mongodb.conf

for port in "${mongodb_ports[@]}"; do
    ./mongodb/bin/mongod --port ${port} --dbpath ${mydir}/data/${port} --shutdown
done
rm -f ./log/*.pid
