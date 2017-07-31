#!/bin/bash

authType="authorization/Enable-Encrypted"
workingDir="$HOME/${authType}"
keyDir="$HOME/shared/$authType"
keyfile="mongodb-keyfile"
logName="mongo.log"

ports=(31250 31251 31252)
replSetName="UNENCRYPTED"

# Generate key-file
[ -f "$keyfile" ] && rm -f "$keyfile"
openssl rand -base64 32 > "$keyfile"
chmod 600 "$keyDir/$keyfile"

# Restart replica set. From primary -> secondaries
for ((i=${#ports[@]} - 1; i>=0; i--))
do
    # Stop one by one instance in replica set
    if [ "${ports[$i]}" -eq "31250" ]; then
        # Upon successful stepdown, rs.stepDown() forces all clients currently connected to the database to disconnect
        mongo admin --port ${ports[$i]} --eval "rs.stepDown();"
        mongo admin --port ${ports[$i]} --eval "db.shutdownServer();"
    else
        mongo admin --port ${ports[$i]} --eval "db.shutdownServer();"
    fi
    sleep 5
    # Restarts each instance with encryption enabled after deleting the files
    rm -rf "$workingDir/r$i"
    mkdir -p "$workingDir/r$i"
    mongod --dbpath "$workingDir/r$i" --logpath "$workingDir/r$i/$logName" --port ${ports[$i]} --replSet $replSetName --fork --enableEncryption --encryptionKeyFile "$keyDir/$keyfile"
    sleep 5
done
