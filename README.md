# mongodb-runrs
Run a MongoDB replica set for learning and development, using just a single command.

### Introduction
Setting up a MongoDB replica set is an involved process, requiring quite a number of configurations to be made. The replica set created as a result of this project is designed such that it doesn't interfere with any existing mongod processes you might have. A copy of MongoDB is *not* required as it will be downloaded automatically. There are no dependencies as only bash shell scripts are used.

### Prerequisites
Ubuntu 18.04 is required.

### Installing
You can use an ordinary user account; no root access is required. Go to your home directory and clone a local copy of this project:
```
cd ~
git clone https://github.com/wingkeet/mongodb-runrs.git
```

### Getting Started
There are 3 bash shell scripts: 'runrs.sh', 'mongoshell.sh' and 'shutdown.sh'. To run a 3-node replica set, consisting of a primary node and two secondary nodes:
```
cd ~/mongodb-runrs
./runrs.sh
```

That's all!

This bash script does the following things:
1. Downloads and decompresses the TGZ version of the MongoDB Community Server. Currently, only MongoDB 4.2.0 is supported.
2. Purges, then creates the 'data' and 'log' directories.
3. Runs 3 copies of the mongod daemon using port numbers 28001 (primary), 28002 and 28003 (secondaries). The name of the replica set is rs0.
4. Calls rs.initiate(conf) to initialize the replica set.
5. Waits for the replica set to finish initializing. This takes several seconds.

To get into the mongo shell, use one of the following commands. If no port number is provided, it defaults to 28001 (primary).
```
./mongoshell.sh
./mongoshell.sh 28001
./mongoshell.sh 28002
./mongoshell.sh 28003
```

To shutdown the entire replica set:
```
./shutdown.sh
```

To remove the entire project from your disk drive:
```
cd ~
rm -rf mongodb-runrs
```

### Authors
* **Leong Wing Keet** - *Initial work*

### License
This project is licensed under the MIT License - see the LICENSE file for details.

### Acknowledgments
* The inspiration for this project came from https://www.npmjs.com/package/run-rs
