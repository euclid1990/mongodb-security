#!/bin/bash

authType="authentication/X.509"
workingDir="$HOME/${authType}"
dbDir="$workingDir/db"
certDir="$HOME/shared/$authType/certs"
logName="mongo.log"

ports=(31130 31131 31132)
replSetName="TO_BE_SECURED"

host=`hostname -f`
initiateStr="rs.initiate({
                _id: '$replSetName',
                members: [
                    { _id: 1, host: '$host:31130' },
                    { _id: 2, host: '$host:31131' },
                    { _id: 3, host: '$host:31132' }
                ]
            })"

# Create replica set
for ((i=0; i < ${#ports[@]}; i++))
do
    # Create working folder
    mkdir -p "$workingDir/r$i"
    # Launch mongod's
    mongod --dbpath "$workingDir/r$i" --logpath "$workingDir/r$i/$logName" --port ${ports[$i]} --replSet $replSetName --sslMode requireSSL --clusterAuthMode x509 --sslPEMKeyFile "$certDir/server.pem" --sslCAFile "$certDir/ca.pem" --fork
done

# Wait for all the mongods to exit
sleep 3

# Initiate the set
mongo --quiet --host database.mongodb.local --ssl --sslPEMKeyFile "$certDir/client.pem" --sslCAFile "$certDir/ca.pem" --port 31130 --eval "$initiateStr"

# Wait for all the mongods to exit
sleep 3
