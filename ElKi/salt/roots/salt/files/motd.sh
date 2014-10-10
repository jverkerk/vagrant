#!/bin/bash
#
# Only show this to users and not again when sudo-ing to root
if [ $(whoami) != 'root' ]; then
echo -e "
##################################
#
#  Welcome to `hostname`
#  This system is running the following:
#  - Elasticsearch 1.4.0 Beta 1  (/usr/share/elasticsearch)
#  - Kibana 4 Beta 1	(/opt/Kibana-4_B1)
#  - Oracle JDK 1.7_67	(/usr/share/java)
#
#  All done with a bit of Salt!
#
##################################
"
fi
