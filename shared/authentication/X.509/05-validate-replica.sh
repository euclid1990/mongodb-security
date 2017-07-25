#!/bin/bash

authType="authentication/X.509"
certDir="$HOME/shared/$authType/certs"

primaryPort=31130

username="will"
password="\$uperAdmin"

statusStr="var status = rs.status();
           delete status.codeName;
           print(JSON.stringify(status))"
memberStr="db = db.getSisterDB('admin');
           db.auth('$username', '$password');
           var status = rs.status();
           var statuses = status.members.map((member) => (member.stateStr)).sort();
           print(JSON.stringify(statuses));"
userStr="db = db.getSisterDB('\$external');
         db.auth({mechanism: 'MONGODB-X509',user: 'CN=Client,OU=MyUniversity,O=MongoDB,L=New York City,ST=New York,C=US'});
         db = db.getSisterDB('admin');
         var users = db.system.users.find().toArray();
         var userData = users.map((user) => ({_id: user._id, roles: user.roles})).sort();
         print(JSON.stringify(userData));"

function mongoEval {
    local port=$1
    local script=$2
    echo `mongo --quiet --host database.mongodb.local --ssl --sslPEMKeyFile "$certDir/client.pem" --sslCAFile "$certDir/ca.pem" --port $port --eval "$script"`
}

function getUnauthorizedStatus {
    local port=$1
    echo $(mongoEval $port "$statusStr")
}

function getMemberStatuses {
    local port=$1
    echo $(mongoEval $port "$memberStr")
}

function getUsers {
    local port=$1
    echo $(mongoEval $port "$userStr")
}

echo "{ unauthorizedStatus: $(getUnauthorizedStatus $primaryPort), memberStatuses: $(getMemberStatuses $primaryPort), users: $(getUsers $primaryPort) }"
