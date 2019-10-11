const rsname = 'rs0';

// Call rs.initiate() only upon fresh install
if (rs.status().ok === 0) {
    const host = hostname();
    const rsconf = {
        _id: rsname,
        members: [
            { _id: 0, host: `${host}:28001`, priority: 10 },
            { _id: 1, host: `${host}:28002` },
            { _id: 2, host: `${host}:28003` }
        ]
    };

    const error = rs.initiate(rsconf);
    printjson(error);
}

// Wait until this node becomes primary
print(`Waiting for replica set '${rsname}' to be ready...`);
while (!rs.isMaster().ismaster) {
    sleep(2000);
}
