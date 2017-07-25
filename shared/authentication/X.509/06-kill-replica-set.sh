#!/bin/bash

authType="authentication/X.509"
workingDir="$HOME/${authType}"

kill $(lsof -i :31130 -t)

kill $(lsof -i :31131 -t)

kill $(lsof -i :31132 -t)

rm -rf "$workingDir"
