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
rm docker-config/workers
while [[ ${i} -lt ${N} ]]
do
	echo "hadoop-slave$i" >> docker-config/workers
	((i++))
done 

echo ""

echo -e "\nbuild docker hadoop image\n"

# rebuild kiwenlau/hadoop image
sudo docker build -t registry.cn-hangzhou.aliyuncs.com/lcts/hadoop:1.0 .

echo ""
