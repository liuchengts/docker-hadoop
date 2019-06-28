#!/bin/bash

# N is the node number of hadoop cluster
N=$1

if [[ $# = 0 ]]
then
	echo "Please specify the node number of hadoop cluster!"
	exit 1
fi

# change slaves file
i=1
echo > docker-config/hadoop/workers
echo >  docker-config/hbase/regionservers
echo "hadoop-master" >> docker-config/hadoop/workers
while [[ ${i} -lt ${N} ]]
do
	echo "hadoop-slave$i" >> docker-config/hadoop/workers
	((i++))
done 
mv -f docker-config/hadoop/workers docker-config/hbase/regionservers
echo ""

echo -e "\nbuild docker hadoop image\n"

# rebuild kiwenlau/hadoop image
sudo docker build -t registry.cn-hangzhou.aliyuncs.com/lcts/hadoop:1.0 .

echo ""
