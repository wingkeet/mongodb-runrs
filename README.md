# mongodb-runrs
Run a MongoDB replica set for learning and development, using just a single command.

### Prerequisites
Ubuntu 18.04 is required. A copy of MongoDB is *not* required as it will be downloaded automatically. No dependencies are needed as only bash shell scripts are used.

### Installing
To clone a local copy of this project:
```
git clone https://github.com/wingkeet/mongodb-runrs.git
```

### Getting Started
There are 3 bash shell scripts: runrs.sh, mongoshell.sh and shutdown.sh.
To run a 3-node replica set:
```
./runrs.sh
```
That's all! This bash script does the following things:
1. Downloads the TGZ version of the MongoDB Community Server. Currently, only MongoDB 4.2.0 is supported.
2. Creates the 'data' and 'log' directories.
3. Runs 3 copies of the mongod daemon using port numbers 28001 (primary), 28002 and 28003 (secondaries). The name of the replica set is rs0.
4. Call rs.initiate(conf) to initialize the replica set.
5. Wait for the replica set to finish initializing. This takes several seconds.

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

### Authors
* **Leong Wing Keet** - *Initial work*

### License
This project is licensed under the MIT License - see the LICENSE.md file for details.

### Acknowledgments
* The inspiration for this project came from https://www.npmjs.com/package/run-rs
