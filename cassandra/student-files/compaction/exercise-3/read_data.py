#!/usr/bin/python

# This Python script will read a number of keys into
# musicdb.user
from cassandra.cluster import Cluster
from random import randint
from sets import Set
from uuid import uuid4
import os,sys,time,binascii

if len(sys.argv) < 2:
    print "Usage: read_data.py <number of keys>"
    sys.exit()

cluster = Cluster(['127.0.0.1'])
session = cluster.connect()

select_id = session.prepare("SELECT id FROM musicdb.user LIMIT " + sys.argv[1])
select_row = session.prepare("SELECT * FROM musicdb.user where id = ?")

quarter=int(int(sys.argv[1])/4)
half=int(int(sys.argv[1])/2)
three_quarter=int(int(sys.argv[1])/4)+int(int(sys.argv[1])/2)

id = session.execute(select_id.bind([]))

for x in range(0,int(sys.argv[1])):
  select_row_bind = select_row.bind([id[x][0]])

  session.execute(select_row_bind)

  if (x+1) == int(sys.argv[1]):
    print "100% completed - " + str(x+1) + " rows read."
  elif (x+1) == quarter:
    print "25% completed - " + str(x+1) + " rows read."
  elif (x+1) == half:
    print "50% completed - " + str(x+1) + " rows read."
  elif (x+1) == three_quarter:
    print "75% completed - " + str(x+1) + " rows read."

time.sleep(1)
cluster.shutdown()
