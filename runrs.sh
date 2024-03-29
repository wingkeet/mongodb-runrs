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
        ./mongodb/bin/mongod \
            --replSet $mongodb_rsname \
            --bind_ip_all \
            --port ${port} \
            --dbpath ${mydir}/data/${port} \
            --logpath ${mydir}/log/mongodb-${port}.log \
            --pidfilepath ${mydir}/log/${port}.pid \
            --fork \
            &> /dev/null
        if [ $? -eq 0 ]; then
            echo "${host}:${port} -> pid $(cat log/${port}.pid)"
        else
            echo "mongod failed with exit code $?"
            exit 3
        fi
    done
}

function freshinstall() {
    rm -f mongodb*.tgz
    rm -rf mongodb data log

    # Download TGZ package and extract into `mongodb` directory
    wget $mongodb_url
    if [ $? -ne 0 ]; then
        exit 2
    fi
    tar -zxvf $(basename $mongodb_url)
    mv $(basename $mongodb_url .tgz) mongodb

    for port in "${mongodb_ports[@]}"; do
        mkdir -p data/$port
    done
    mkdir log
}

# Convert an array to a comma-separated list.
# Example usage:
#     array=(28001 28002 28003)
#     join , "${array[@]}"
# Outputs: 28001,28002,28003
function join() {
    local IFS="$1"
    shift
    echo "$*"
}

# Here we assume that the replica set is not running.
# If the `mongodb` directory is missing or the --fresh option is given, do a fresh install.
if [ ! -d mongodb ] || [ $fresh -eq 1 ]; then
    freshinstall
fi

# Fork mongod daemons and wait for the replica set to be ready
mongo_vars="const ports=[ $(join , ${mongodb_ports[@]}) ]; const rsname='${mongodb_rsname}';"
fork
./mongodb/bin/mongo --port ${mongodb_ports[0]} --eval "$mongo_vars" rsinitiate.js
