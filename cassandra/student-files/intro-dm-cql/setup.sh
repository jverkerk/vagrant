#!/bin/bash

# Dependencies
#  Check if Cassandra version provided
#  Check if CCM is installed
#  Remove any running Cassandra instances
#  Remove defined CCM clusters
#  Extract the Cassandra tarball to the expected location
#  Create and start 3 node Cassandra cluster 
#  Populate cluster with musicdb (from tools module)
#  Create cassandra-stress schema (from architecture module) 

#  Check if Cassandra version provided
if [ $# -ne 1 ] || [[ $1 != [0-9]\.[0-9]\.[0-9]* ]]
then
  echo "Usage: $0 <Cassandra version>"
  exit 0
fi

#  Check if CCM is installed
if [ `ccm | grep "command not found" | wc -l` != "0" ]
then
  echo "Error: CCM is not installed."
  exit 0
fi

echo "  Remove existing Cassandra clusters..."

#  Remove any running Cassandra instances
if [ `ccm status | grep "No currently active cluster" | wc -l` != "1" ]
then
  ccm stop
fi
pkill java

#  Remove defined CCM clusters
while [ `ccm list | wc -l` != "0" ]
do
  cluster_name=`ccm list | head -1 | tr -d '* '`
  ccm switch $cluster_name
  ccm remove
done

echo "  Installing Cassandra binary tarball..."

#  Extract the Cassandra tarball to the expected location
rm -rf ~/cassandra/
if [ -e ~/apache-cassandra-$1-bin.tar.gz ]
then
  tar xzf ~/apache-cassandra-$1-bin.tar.gz -C ~/
  mv ~/apache-cassandra-$1/ ~/cassandra
elif [ -e ~/Downloads/apache-cassandra-$1-bin.tar.gz ]
then
  tar xzf ~/Downloads/apache-cassandra-$1-bin.tar.gz -C ~/
  mv ~/apache-cassandra-$1/ ~/cassandra
elif [ -e ~/downloads/apache-cassandra-$1-bin.tar.gz ]
then
  tar xzf ~/downloads/apache-cassandra-$1-bin.tar.gz -C ~/
  mv ~/apache-cassandra-$1/ ~/cassandra
elif [ -e ~/Desktop/apache-cassandra-$1-bin.tar.gz ]
then
  tar xzf ~/Desktop/apache-cassandra-$1-bin.tar.gz -C ~/
  mv ~/apache-cassandra-$1/ ~/cassandra
elif [ -e ~/dsc-cassandra-$1-bin.tar.gz ]
then
  tar xzf ~/dsc-cassandra-$1-bin.tar.gz -C ~/
  mv ~/dsc-cassandra-$1/ ~/cassandra
elif [ -e ~/Downloads/dsc-cassandra-$1-bin.tar.gz ]
then
  tar xzf ~/Downloads/dsc-cassandra-$1-bin.tar.gz -C ~/
  mv ~/dsc-cassandra-$1/ ~/cassandra
elif [ -e ~/downloads/dsc-cassandra-$1-bin.tar.gz ]
then
  tar xzf ~/downloads/dsc-cassandra-$1-bin.tar.gz -C ~/
  mv ~/dsc-cassandra-$1/ ~/cassandra
elif [ -e ~/Desktop/dsc-cassandra-$1-bin.tar.gz ]
then
  tar xzf ~/Desktop/dsc-cassandra-$1-bin.tar.gz -C ~/
  mv ~/dsc-cassandra-$1/ ~/cassandra
else
  echo "Error: Cannot find the Cassandra $1 binary tarball. Please download the correct version of the tarball and place it in the $HOME/Downloads directory."
  exit 0
fi

echo "  Setting up 3 node cluster..."

#  Create and populate 3 node Cassandra cluster with musicdb
ccm create demo_3node -v $1 -n 3 -s --vnodes >/dev/null

echo "  Populating musicdb keyspace..."

#  Populate cluster with musicdb (from tools module)
cd ~/student-files/tools/exercise-2
ccm node1 cqlsh -f musicdb.cql
ccm node1 cqlsh -f musicdata.cql
ccm flush

#  Create cassandra-stress schema (from architecture module)
echo "CREATE KEYSPACE \"Keyspace1\" with replication = {'class':'SimpleStrategy','replication_factor':3};" | ccm node1 cqlsh

echo ""
echo "  Setup complete!"
echo ""
