#!/bin/bash

ports=(31120 31121 31122)

# Stop secondary -> primary
for ((i=${#ports[@]} - 1; i>=0; i--))
do
  if [ "$i" -eq 0 ]; then
    mongo --port ${ports[$i]} --eval "db=db.getSiblingDB('admin');db.auth({user:'admin', pwd:'webscale'});db.shutdownServer({force: true});"
  else
    mongo --port ${ports[$i]} --eval "db=db.getSiblingDB('admin');db.auth({user:'admin', pwd:'webscale'});db.shutdownServer();"
  fi
done
