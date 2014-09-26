#!/bin/bash

if [ $UID != 0 ]
then
   echo "Error! Please run this script again with root privileges!"
   exit 1
fi

rm /opt/DevCenter
ln -s /opt/DevCenter-1.1.0 /opt/DevCenter
