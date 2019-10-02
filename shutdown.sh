#!/bin/bash

mydir="$(dirname $(realpath $0))"

./mongodb/bin/mongod --port 28003 --dbpath ${mydir}/data/28003 --shutdown
./mongodb/bin/mongod --port 28002 --dbpath ${mydir}/data/28002 --shutdown
./mongodb/bin/mongod --port 28001 --dbpath ${mydir}/data/28001 --shutdown
rm -f ./log/*.pid
