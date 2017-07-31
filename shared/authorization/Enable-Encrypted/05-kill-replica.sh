#!/bin/bash

authType="authorization/Enable-Encrypted"
workingDir="$HOME/${authType}"

[ ! -z "$(lsof -i :31250 -t)" ] && kill $(lsof -i :31250 -t)

[ ! -z "$(lsof -i :31251 -t)" ] && kill $(lsof -i :31251 -t)

[ ! -z "$(lsof -i :31252 -t)" ] && kill $(lsof -i :31252 -t)

rm -rf "$workingDir"
