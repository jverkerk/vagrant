#!/bin/bash

rm -rf ~/cascor/*
curl -L https://s3.amazonaws.com/datastax-training/DISTRIBUTION/cascor.zip > ~/cascor.zip
cd ~/
unzip cascor.zip
rm cascor.zip
