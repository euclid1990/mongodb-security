#!/bin/bash

authType="authentication/X.509"
certDir="$HOME/shared/$authType/certs"

ports=(31130 31131 31132)

# Stop replica set. From secondaries -> primary
for ((i=${#ports[@]} - 1; i>=0; i--))
do
  if [ "$i" -eq 0 ]; then
    mongo --host database.mongodb.local --ssl --sslPEMKeyFile "$certDir/client.pem" --sslCAFile "$certDir/ca.pem" --port ${ports[$i]} --eval "db=db.getSiblingDB('admin');db.auth({user: 'will', pwd: '\$uperAdmin'});db.shutdownServer({force: true});"
  else
    mongo --host database.mongodb.local --ssl --sslPEMKeyFile "$certDir/client.pem" --sslCAFile "$certDir/ca.pem" --port ${ports[$i]} --eval "db=db.getSiblingDB('admin');db.auth({user: 'will', pwd: '\$uperAdmin'});db.shutdownServer();"
  fi
done
