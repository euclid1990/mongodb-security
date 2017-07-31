#!/bin/bash

ports=(31250 31251 31252)

# After restarted, Instance 31250 become to secondary.
# Run 'rs.slaveOk()' to allow you to read from secondaries.
mongo --port ${ports[0]} --eval "rs.slaveOk();db=db.getSiblingDB('store');db.products.findOne({});"
