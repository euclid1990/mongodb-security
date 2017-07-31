#!/bin/bash

authType="authorization/Enable-Encrypted"
workingDir="$HOME/${authType}"
dbDir="$workingDir/db"

ports=(31250 31251 31252)
replSetName="UNENCRYPTED"

host=`hostname -f`
initiateStr="rs.initiate({
                _id: '$replSetName',
                members: [
                    { _id: 1, host: '$host:${ports[0]}' },
                    { _id: 2, host: '$host:${ports[1]}' },
                    { _id: 3, host: '$host:${ports[2]}' }
                ]
            })"
insertStr="pDb=db.getSiblingDB('store');
           pDb.products.insertOne({ item: 'canvas', qty: 100, tags: ['cotton'], size: { h: 28, w: 35.5, uom: 'cm' }});
           db = db.getSisterDB('beforeEncryption');
           db.coll.insert({str: 'The quick brown fox jumps over the lazy dog'}, {writeConcern: { w: 'majority' , wtimeout: 5000}})"

# Create replica set
for ((i=0; i < ${#ports[@]}; i++))
do
    # Create working folder
    mkdir -p "$workingDir/r$i"
    # Launch mongod's
    mongod --dbpath "$workingDir/r$i" --logpath "$workingDir/r$i/$logName.log" --port ${ports[$i]} --replSet $replSetName --fork
done

# wait for all the mongods to exit
sleep 5

# Initiate the replica set
mongo --port ${ports[0]} --eval "$initiateStr"

sleep 15

# Load some data
mongo --port ${ports[0]} --eval "$insertStr"
