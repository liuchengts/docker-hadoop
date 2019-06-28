FROM ubuntu:14.04
MAINTAINER lc
USER root
WORKDIR /root
#拷贝必要的文件配置
COPY /docker-config $WORKDIR
#构建参数设置
ARG JDK=jdk-8u201-linux-x64.tar.gz
ARG HADOOP=hadoop-3.1.2.tar.gz
ARG HBASE_V=2.2.0
ARG HBASE=hbase-${HBASE_V}-bin.tar.gz
#=========注意这两个参数影响 docker-config 中的 .bashrc 环境变量配置
ARG JDK_FILE_HOME=jdk1.8.0_201
ARG HADOOP_FILE_HOME=hadoop-3.1.2
ARG HBASE_FILE_HOME=hbase-${HBASE_V}
#设置环境变量
ENV JAVA_HOME=/usr/java/$JDK_FILE_HOME
ENV JRE_HOME=$JAVA_HOME/jre
ENV JAVA_BIN=$JAVA_HOME/bin
ENV CLASSPATH=.:$JAVA_HOME/lib/dt.jar:$JAVA_HOME/lib/tools.jar:$JRE_HOME/lib
ENV HADOOP_HOME=/usr/local/hadoop/$HADOOP_FILE_HOME
ENV HBASE_HOME=/usr/local/hbase/$HBASE_FILE_HOME
ENV PATH=$PATH:$JAVA_HOME/bin:$JRE_HOME/bin:$HADOOP_HOME/bin:$HADOOP_HOME/sbin:$HBASE_HOME/bin
#安装必要的工具
RUN apt-get update \
    && apt-get install -y wget vim openssh-server tar \
    #下载sunjdk
    && wget http://pubqn.ayouran.com/$JDK  \
    #安装jdk
    && mkdir /usr/java \
    && tar -zxvf $JDK -C /usr/java \
    #下载hadoop
    &&  wget http://mirror.bit.edu.cn/apache/hadoop/common/$HADOOP_FILE_HOME/$HADOOP  \
    #安装hadoop
    #创建hadoop需要的文件目录
    && mkdir -p ~/hdfs/namenode ~/hdfs/datanode $HADOOP_HOME/log \
    && tar -zxvf $HADOOP -C /usr/local/hadoop \
    #配置hadoop
    #复制配置文件
    && cp -f hadoop/* $HADOOP_HOME/etc/hadoop \
    #下载hbase
    && wget http://mirror.bit.edu.cn/apache/hbase/$HBASE_V/$HBASE \
    #安装hbase
    #创建hbase需要的文件目录
    && mkdir -p $HBASE_HOME \
    && tar -zxvf $HBASE -C /usr/local/hbase \
    #配置hbase
    #复制配置文件
    && cp -f hbase/* $HBASE_HOME/conf \
    #格式化hdfs文件系统
    && hdfs namenode -format \
    #生成sshkey
    && ssh-keygen -t rsa -f ~/.ssh/id_rsa -P '' \
    #配置本机免密登录
    && cat ~/.ssh/id_rsa.pub >> ~/.ssh/authorized_keys \
    && mv ssh/ssh_config ~/.ssh/config \
    #清理
    && rm -rf  hadoop ssh hbase $HADOOP $JDK $HBASE \
    && chmod +x ~/start-hadoop.sh  \
    && chmod +x ~/run-wordcount.sh  \
    && chmod +x $HADOOP_HOME/sbin/start-dfs.sh  \
    && chmod +x $HADOOP_HOME/sbin/start-yarn.sh  \
    && chmod +x $HBASE_HOME/bin/start-hbase.sh

CMD [ "sh", "-c", "service ssh start; bash"]