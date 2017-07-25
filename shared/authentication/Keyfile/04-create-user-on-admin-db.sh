#!/bin/bash

mongo --port 31120 --eval "db=db.getSiblingDB('admin');db.createUser({user: 'admin', pwd: 'webscale', roles: ['root']});"
