#!/usr/bin/python

# This Python script will insert a number of keys into
# musicdb.user
from cassandra.cluster import Cluster
from random import randint
from sets import Set
from uuid import uuid4
import os,sys,time,binascii

if len(sys.argv) < 2:
    print "Usage: write_data.py <number of keys>"
    sys.exit()

cluster = Cluster(['127.0.0.1'])
session = cluster.connect()

insert_row_prepare = session.prepare("INSERT INTO musicdb.user (id,preferences) VALUES(?,?)")

quarter=int(int(sys.argv[1])/4)
half=int(int(sys.argv[1])/2)
three_quarter=int(int(sys.argv[1])/4)+int(int(sys.argv[1])/2)

for x in range(0,int(sys.argv[1])):
  id = uuid4()
  set = Set([binascii.b2a_hex(os.urandom(100)),binascii.b2a_hex(os.urandom(100)),binascii.b2a_hex(os.urandom(100)),
             binascii.b2a_hex(os.urandom(100)),binascii.b2a_hex(os.urandom(100)),binascii.b2a_hex(os.urandom(100)),
             binascii.b2a_hex(os.urandom(100)),binascii.b2a_hex(os.urandom(100)),binascii.b2a_hex(os.urandom(100)),
             binascii.b2a_hex(os.urandom(100)),binascii.b2a_hex(os.urandom(100)),binascii.b2a_hex(os.urandom(100))])
  insert_row_bind = insert_row_prepare.bind([id,set])
  session.execute(insert_row_bind)

  if (x+1) == int(sys.argv[1]):
    print "100% completed - " + str(x+1) + " rows inserted."
  elif (x+1) == quarter:
    print "25% completed - " + str(x+1) + " rows inserted."
  elif (x+1) == half:
    print "50% completed - " + str(x+1) + " rows inserted."
  elif (x+1) == three_quarter:
    print "75% completed - " + str(x+1) + " rows inserted."

time.sleep(1)
cluster.shutdown()
