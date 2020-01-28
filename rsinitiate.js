// These variables are passed in through the mongo --eval option.
// See mongodb.conf for the actual values.
// const ports = [ 28001, 28002, 28003 ]
// const rsname = 'rstest'

// Call rs.initiate() only upon fresh install
if (rs.status().ok === 0) {
    const host = hostname()
    const members = ports.map((port, index) => ({ _id: index, host: `${host}:${port}` }) )
    members[0].priority = 10
    const rsconf = {
        _id: rsname,
        members
    }

    const error = rs.initiate(rsconf)
    printjson(error)
}

// Wait until this node becomes primary
print(`Waiting for replica set '${rsname}' to be ready...`)
while (!rs.isMaster().ismaster) {
    sleep(2000)
}
