#!/bin/bash

echo -e "\n"

${HADOOP_HOME}/sbin/start-dfs.sh

echo -e "\n"

${HADOOP_HOME}/sbin/start-yarn.sh

echo -e "\n"

${HBASE_HOME}/bin/start-hbase.sh

echo -e "\n"