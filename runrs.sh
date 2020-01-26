#!/bin/bash

mydir="$(dirname $(realpath $0))"
fresh=0
host="$(hostname)"
source mongodb.conf

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

# Fork mongod daemons without authentication and authorization enabled
function fork() {
    for port in "${mongodb_ports[@]}"; do
        ./mongodb/bin/mongod --replSet rs0 --bind_ip_all --port ${port} \
            --dbpath ${mydir}/data/${port} \
            --logpath ${mydir}/log/mongodb-${port}.log \
            --pidfilepath ${mydir}/log/${port}.pid \
            --fork &> /dev/null
        if [ $? -eq 0 ]; then
            echo "${host}:${port} -> pid $(cat log/${port}.pid)"
        else
            echo "mongod failed with exit code $?"
            exit 2
        fi
    done
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

    for port in "${mongodb_ports[@]}"; do
        mkdir -p data/$port
    done
    mkdir log
}

# Here we assume that the replica set is not running.
# If the `mongodb` directory is missing or the --fresh option is given, do a fresh install.
if [ ! -d mongodb ] || [ $fresh -eq 1 ]; then
    freshinstall
fi

# Fork mongod daemons and wait for the replica set to be ready
fork
./mongodb/bin/mongo --port ${mongodb_ports[0]} rsinitiate.js
