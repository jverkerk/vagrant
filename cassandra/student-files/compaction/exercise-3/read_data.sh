#!/bin/bash

if [ $# -ne 1 ]; then
  echo "Usage: read_data.sh <number of keys>"
  exit 0
fi
 
if [ `ccm status | grep "node1: UP" | wc -l` -ne 1 ]; then
  echo "Cassandra cluster not up"
  exit 0
fi

./read_data.py $1
