#!/bin/bash

cluster_name=demo_3node
if [ "$1" != "" ]; then
  cluster_name=$1
fi 
if [ ! -d ~/.ccm/$cluster_name ]; then
  echo "Cannot find cluster called \"$cluster_name\"."
  echo "If your cluster has a different name, please run this script as:"
  echo "   $0 <cluster name>"
  exit 1
fi

# Backup cassandra.yaml and cassandra-rackdc.properties
cp -p ~/.ccm/$cluster_name/node1/conf/cassandra.yaml ~/.ccm/$cluster_name/node1/conf/cassandra.yaml.original
cp -p ~/.ccm/$cluster_name/node1/conf/cassandra-rackdc.properties ~/.ccm/$cluster_name/node1/conf/cassandra-rackdc.properties.original
cp -p ~/.ccm/$cluster_name/node2/conf/cassandra.yaml ~/.ccm/$cluster_name/node2/conf/cassandra.yaml.original
cp -p ~/.ccm/$cluster_name/node2/conf/cassandra-rackdc.properties ~/.ccm/$cluster_name/node2/conf/cassandra-rackdc.properties.original
cp -p ~/.ccm/$cluster_name/node3/conf/cassandra.yaml ~/.ccm/$cluster_name/node3/conf/cassandra.yaml.original
cp -p ~/.ccm/$cluster_name/node3/conf/cassandra-rackdc.properties ~/.ccm/$cluster_name/node3/conf/cassandra-rackdc.properties.original

# Change the endpoint snitch
sed 's/\(endpoint_snitch: \)[^\n]*/\1GossipingPropertyFileSnitch/' <~/.ccm/$cluster_name/node1/conf/cassandra.yaml.original > ~/.ccm/$cluster_name/node1/conf/cassandra.yaml
sed 's/\(endpoint_snitch: \)[^\n]*/\1GossipingPropertyFileSnitch/' <~/.ccm/$cluster_name/node2/conf/cassandra.yaml.original > ~/.ccm/$cluster_name/node2/conf/cassandra.yaml
sed 's/\(endpoint_snitch: \)[^\n]*/\1GossipingPropertyFileSnitch/' <~/.ccm/$cluster_name/node3/conf/cassandra.yaml.original > ~/.ccm/$cluster_name/node3/conf/cassandra.yaml

# Change the rack and datacenter for each node
echo "dc=DC1
rack=RAC1" > ~/.ccm/$cluster_name/node1/conf/cassandra-rackdc.properties
echo "dc=DC1
rack=RAC1" > ~/.ccm/$cluster_name/node2/conf/cassandra-rackdc.properties
echo "dc=DC1
rack=RAC2" > ~/.ccm/$cluster_name/node3/conf/cassandra-rackdc.properties

# Learn more about changing the snitch in 6.4 - Understand how nodes communicate
