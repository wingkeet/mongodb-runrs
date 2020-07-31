# mongodb-runrs
Run a MongoDB replica set for learning and development, using just one command.

### Introduction
Setting up a MongoDB replica set is an involved process, requiring quite a number of configurations to be made.
With mongodb-runrs, you can now invoke a single command to set up an N-member replica set in less than 60 seconds.
The resultant replica set is designed such that it doesn't interfere with any existing mongod processes you might have.

### Prerequisites
- Ubuntu 18.04 LTS is required.
- A copy of MongoDB is *not* required as it will be downloaded automatically.
- There are zero dependencies as only Bash shell scripts are used.

### Installing
You can use an ordinary user account; superuser privilege is not required.
Go to your home directory and clone a local copy of this repository:
```
$ cd ~
$ git clone https://github.com/wingkeet/mongodb-runrs.git
```

### Getting Started
There are 3 Bash shell scripts: `runrs.sh`, `mongoshell.sh` and `shutdown.sh`.
To run a replica set consisting of a primary node and two secondary nodes:
```
$ cd ~/mongodb-runrs
$ ./runrs.sh
```

To get into the mongo shell, use one of the following commands.
If no port number is provided, it defaults to 28001 (primary).
```
$ ./mongoshell.sh
$ ./mongoshell.sh 28001
$ ./mongoshell.sh 28002
$ ./mongoshell.sh 28003
```

To shutdown the entire replica set:
```
$ ./shutdown.sh
```

To remove the entire project from your disk drive:
```
$ cd ~
$ rm -rf mongodb-runrs
```

### Additional Notes
The `runrs.sh` shell script does the following things:
1. Reads configuration information from `mongodb.conf`.
2. Downloads the TGZ tarball of the MongoDB Community Server and extracts the contents into the `mongodb` subdirectory.
3. Creates the `data` and `log` subdirectories.
4. Runs 3 copies of the mongod daemon using port numbers 28001 (primary), 28002 and 28003 (secondaries).
The name of the replica set is `rstest`. All of these parameters are configurable in `mongodb.conf`.
5. Calls `rs.initiate(rsconf)` to initialize the replica set.
6. Waits for the replica set to be ready. This step alone takes 13 seconds on my machine.

By default, runrs.sh retains any databases found in the `data` directory.
If you want a fresh install, use the `--fresh` option:
```
$ ./shutdown.sh
$ ./runrs.sh --fresh
```

Before doing a fresh install, you can configure your replica set by editing `mongodb.conf`.
I will try my best to update it to reflect the latest version of MongoDB.
Refer to `mongodb.conf` for details.

### Authors
* **Steve Leong** - *Initial work*

### License
This project is licensed under the MIT License - see the LICENSE file for details.
