#!/bin/bash

service sshd start

service mysqld start

echo "Starting namenode"
service hadoop-hdfs-namenode start

echo "Starting secondarynamenode"
service hadoop-hdfs-secondarynamenode start

echo "Starting datanode"
service hadoop-hdfs-datanode start

echo "Starting Apache Spark"
$SPARK_HOME/sbin/start-all.sh

echo "Starting hive-metastore"
service hive-metastore start

if [[ $1 == "-d" ]]; then
  while true; do sleep 5s; done
fi

if [[ $1 == "-bash" ]]; then
  /bin/bash
fi

echo "CDH 5.3.0 with Spark-1.3.1 is now running"