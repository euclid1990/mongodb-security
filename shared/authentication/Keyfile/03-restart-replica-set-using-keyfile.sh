#!/bin/bash

authType="authentication/Keyfile"
workingDir="$HOME/${authType}"
dbDir="$workingDir/db"
keyDir="$HOME/shared/$authType"
keyfile="mongodb-keyfile"
logName="mongo.log"

ports=(31120 31121 31122)
replSetName="TO_BE_SECURED"

# Generate key-file
openssl rand -base64 755 > "$keyfile"
sudo chmod 400 "$keyDir/$keyfile"

# Start replica set. From secondaries -> primary
for ((i=0; i < ${#ports[@]}; i++))
do
  mongod --dbpath "$workingDir/r$i" --logpath "$workingDir/r$i/$logName" --logappend --port ${ports[$i]} --replSet $replSetName --fork --keyFile "$keyDir/$keyfile"
done

# Wait for all the mongods to exit
sleep 5
