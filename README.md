# docker-hadoop
## 感谢 https://github.com/kiwenlau/hadoop-cluster-docker 出第一版的源代码，本项目是在 hadoop-cluster-docker的基础上进行了更新
* 更新hadoop版本为3.1.2 
* jdk改用 oracle jdk1.8.0_201
* 增加了3.x版本的兼容配置

# 使用步骤
## 创建网络 sudo docker network create --driver=bridge hadoop
## 下载源代码 git clone https://github.com/liuchengts/docker-hadoop.git
## 获取镜像有2种方式:
* 从仓库拉取 
```
 sudo docker pull registry.cn-hangzhou.aliyuncs.com/lcts/hadoop:1.0
```
* 编译镜像，执行 
```
./build-image.sh
```
## 默认是1主2从总共3个节点 如果需要更多节点 请先执行 
```
 ./resize-cluster.sh
 ```
## 创建容器，执行 
```
./start-container.sh
```
**output:**
```
start hadoop-master container...
start hadoop-slave1 container...
start hadoop-slave2 container...
root@hadoop-master:~# 
```
## 启动 hadoop，执行
```
./start-hadoop.sh
```

## 启动测试程序，执行
```
./run-wordcount.sh
```

**output**

```
input file1.txt:
Hello Hadoop

input file2.txt:
Hello Docker

wordcount output:
Docker    1
Hadoop    1
Hello    2
```

### Arbitrary size Hadoop cluster

##### 1. pull docker images and clone github repository

do 1~3 like section A

##### 2. rebuild docker image

```
sudo ./resize-cluster.sh 5
```
- specify parameter > 1: 2, 3..
- this script just rebuild hadoop image with different **slaves** file, which pecifies the name of all slave nodes


##### 3. start container

```
sudo ./start-container.sh 5
```
- use the same parameter as the step 2

##### 4. run hadoop cluster 

do 5~6 like section A



