#!/bin/bash

mydir="$(dirname $(realpath $0))"
fresh=0

# Read command line options
TEMP=$(getopt -o "" -l fresh -- "$@")
if [ $? -ne 0 ]; then
    echo "Usage: runrs.sh [--fresh]"
    exit 1
fi
eval set -- "$TEMP"

# Extract options and their arguments into variables
while true ; do
    case "$1" in
        --fresh)
            fresh=1 ; shift ;;
        --) shift ; break ;;
        *) echo "Internal error!" ; exit 1 ;;
    esac
done

function healthcheck() {
    ./mongodb/bin/mongo --port 28001 healthcheck.js &> /dev/null
}

function replsetinfo() {
    local host="$(hostname)"
    echo "mongodb://${host}:28001 -> pid $(cat log/28001.pid)"
    echo "mongodb://${host}:28002 -> pid $(cat log/28002.pid)"
    echo "mongodb://${host}:28003 -> pid $(cat log/28003.pid)"
}

# Fork 3 mongod daemons
function fork() {
    ./mongodb/bin/mongod --replSet rs0 --bind_ip_all --port 28001 --dbpath ${mydir}/data/28001 \
        --logpath ${mydir}/log/mongodb-28001.log --pidfilepath ${mydir}/log/28001.pid --fork
    ./mongodb/bin/mongod --replSet rs0 --bind_ip_all --port 28002 --dbpath ${mydir}/data/28002 \
        --logpath ${mydir}/log/mongodb-28002.log --pidfilepath ${mydir}/log/28002.pid --fork
    ./mongodb/bin/mongod --replSet rs0 --bind_ip_all --port 28003 --dbpath ${mydir}/data/28003 \
        --logpath ${mydir}/log/mongodb-28003.log --pidfilepath ${mydir}/log/28003.pid --fork
}

function freshinstall() {
    rm -f mongodb*.tgz
    rm -rf mongodb
    rm -rf data
    rm -rf log

    # Download TGZ package and extract into `mongodb` directory
    wget https://fastdl.mongodb.org/linux/mongodb-linux-x86_64-ubuntu1804-4.2.2.tgz
    tar -zxvf mongodb-linux-x86_64-ubuntu1804-4.2.2.tgz
    mv mongodb-linux-x86_64-ubuntu1804-4.2.2 mongodb

    mkdir -p data/28001 data/28002 data/28003
    mkdir -p log
}

healthcheck
if [ $? -eq 0 ]; then
    echo "MongoDB replica set 'rs0' is already running."
    replsetinfo
    exit 1
fi

# Now we know that the replica set is not running.
# If the `mongodb` directory is missing or the --fresh option is given, do a fresh install.
if [ ! -d mongodb ] || [ $fresh -eq 1 ]; then
    freshinstall
fi

# Fork mongod daemons and wait for replica set to be ready
fork
./mongodb/bin/mongo --port 28001 rsinitiate.js

replsetinfo
