#!/bin/bash

echo ""

echo -e "\nbuild docker hadoop image\n"
sudo docker build -t registry.cn-hangzhou.aliyuncs.com/lcts/hadoop:1.0 .

echo ""