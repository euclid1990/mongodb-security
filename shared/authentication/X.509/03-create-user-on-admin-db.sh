#!/bin/bash

authType="authentication/X.509"
certDir="$HOME/shared/$authType/certs"

mongo --host database.mongodb.local --ssl --sslPEMKeyFile "$certDir/client.pem" --sslCAFile "$certDir/ca.pem" --port 31130 --eval "db=db.getSiblingDB('admin');db.createUser({user: 'will', pwd: '\$uperAdmin', roles: ['root']});"

pemUser="db.getSiblingDB('\$external').runCommand(
  {
    createUser: 'CN=Client,OU=MyUniversity,O=MongoDB,L=New York City,ST=New York,C=US',
    roles: [
        { role: 'userAdminAnyDatabase', db: 'admin' }
    ],
  }
)"

mongo --host database.mongodb.local --ssl --sslPEMKeyFile "$certDir/client.pem" --sslCAFile "$certDir/ca.pem" --port 31130 --eval "db=db.getSiblingDB('admin');db.auth({user:'will', pwd:'\$uperAdmin'});$pemUser;"
