# mongodb-runrs
Run a MongoDB replica set for learning and development, using just one command.

### Introduction
Setting up a MongoDB replica set is an involved process, requiring quite a number of configurations to be made. With mongodb-runrs, you can now invoke a single command to set up a 3-node replica set in less than 60 seconds. The resultant replica set is designed such that it doesn't interfere with any existing mongod processes you might have. A copy of MongoDB is *not* required as it will be downloaded automatically. There are no dependencies as only bash shell scripts are used.

### Prerequisites
Ubuntu 18.04 is required.

### Installing
You can use an ordinary user account; no root access is required. Go to your home directory and clone a local copy of this repository:
```
cd ~
git clone https://github.com/wingkeet/mongodb-runrs.git
```

### Getting Started
There are 3 bash shell scripts: `runrs.sh`, `mongoshell.sh` and `shutdown.sh`. To run a replica set consisting of a primary node and two secondary nodes:
```
cd ~/mongodb-runrs
./runrs.sh
```

That's all!

This bash script does the following things:
1. Downloads and decompresses the TGZ version of the MongoDB Community Server. Currently, only MongoDB 4.2.0 is supported. A `mongodb` subdirectory that contains the MongoDB files and binaries is created.
2. Creates the `data` and `log` subdirectories.
3. Runs 3 copies of the mongod daemon using port numbers 28001 (primary), 28002 and 28003 (secondaries). The name of the replica set is `rs0`.
4. Calls `rs.initiate(rsconf)` to initialize the replica set.
5. Waits for the replica set to finish initializing. This step alone takes 13 seconds on my machine.

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

### Additional Notes
Every time runrs.sh is executed, it checks to see whether there is a mongod process listening on port 28001.
If there is one, it prints a message and exits.
By default, runrs.sh retains any databases found in the `data` directory.
If you want to start with a clean installation, use the --purge option on the command line:
```
./shutdown.sh
./runrs.sh --purge
```

### Authors
* **Steve Leong** - *Initial work*

### License
This project is licensed under the MIT License - see the LICENSE file for details.

### Acknowledgments
* The inspiration for this project came from https://www.npmjs.com/package/run-rs
