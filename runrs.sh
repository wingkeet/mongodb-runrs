#!/bin/bash

mydir="$(dirname $(realpath $0))"

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
    ./mongodb/bin/mongod --replSet rs0 --bind_ip_all --port 28001 --dbpath ${mydir}/data/28001 --logpath ${mydir}/log/mongodb-28001.log --pidfilepath ${mydir}/log/28001.pid --fork
    ./mongodb/bin/mongod --replSet rs0 --bind_ip_all --port 28002 --dbpath ${mydir}/data/28002 --logpath ${mydir}/log/mongodb-28002.log --pidfilepath ${mydir}/log/28002.pid --fork
    ./mongodb/bin/mongod --replSet rs0 --bind_ip_all --port 28003 --dbpath ${mydir}/data/28003 --logpath ${mydir}/log/mongodb-28003.log --pidfilepath ${mydir}/log/28003.pid --fork
}

healthcheck
if [ $? -eq 0 ]; then
    echo "MongoDB replica set 'rs0' is already running."
    replsetinfo
    exit 1
fi

# Now we know that the replica set is not running.
# If the 'mongod' directory exists, just fork the 3 mongod daemons and we're done.
# Otherwise, set up everything from the beginning.
if [ -d mongodb ]; then
    fork
else
    rm -f mongodb-linux-x86_64-ubuntu1804-4.2.0.tgz
    wget https://fastdl.mongodb.org/linux/mongodb-linux-x86_64-ubuntu1804-4.2.0.tgz
    tar -zxvf mongodb-linux-x86_64-ubuntu1804-4.2.0.tgz
    mv mongodb-linux-x86_64-ubuntu1804-4.2.0 mongodb

    rm -rf data
    rm -rf log
    mkdir -p data/28001 data/28002 data/28003
    mkdir -p log
    fork
    ./mongodb/bin/mongo --port 28001 rsinitiate.js
fi

replsetinfo
