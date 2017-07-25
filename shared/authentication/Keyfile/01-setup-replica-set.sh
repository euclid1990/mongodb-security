#!/bin/bash

authType="authentication/Keyfile"
workingDir="$HOME/${authType}"
dbDir="$workingDir/db"
logName="mongo.log"

ports=(31120 31121 31122)
replSetName="TO_BE_SECURED"

host=`hostname -f`
initiateStr="rs.initiate({
                _id: '$replSetName',
                members: [
                    { _id: 1, host: '$host:31120' },
                    { _id: 2, host: '$host:31121' },
                    { _id: 3, host: '$host:31122' }
                ]
            })"

# Create replica set
for ((i=0; i < ${#ports[@]}; i++))
do
    # Create working folder
    mkdir -p "$workingDir/r$i"
    # Launch mongod's
    mongod --dbpath "$workingDir/r$i" --logpath "$workingDir/r$i/$logName" --port ${ports[$i]} --replSet $replSetName --fork
done

# Wait for all the mongods to exit
sleep 3

# Initiate the set
mongo --port ${ports[0]} --eval "$initiateStr"
