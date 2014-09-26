CREATE KEYSPACE "Keyspace1" WITH replication = {
  'class': 'SimpleStrategy',
  'replication_factor': '1'
};

USE "Keyspace1";

CREATE TABLE "Standard1" (
  key blob,
  "C0" blob,
  "C1" blob,
  "C2" blob,
  "C3" blob,
  "C4" blob,
  PRIMARY KEY (key)
) WITH COMPACT STORAGE AND
  caching='NONE';
