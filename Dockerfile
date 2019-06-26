FROM ubuntu:14.04
MAINTAINER lc
USER root
WORKDIR /root
#拷贝必要的文件配置
COPY /docker-config $WORKDIR
#构建参数设置
ARG AXEL=axel-2.4-9
# axel下载线程数
ARG AXELT=1000
ARG JDK=jdk-8u201-linux-x64.tar.gz
ARG HADOOP=hadoop-3.1.2.tar.gz
#=========注意这两个参数影响 docker-config 中的 .bashrc 环境变量配置
ARG JDK_FILE_HOME=jdk1.8.0_201
ARG HADOOP_FILE_HOME=hadoop-3.1.2
#设置环境变量
ENV JAVA_HOME=/usr/java/$JDK_FILE_HOME
ENV JRE_HOME=$JAVA_HOME/jre
ENV JAVA_BIN=$JAVA_HOME/bin
ENV CLASSPATH=.:$JAVA_HOME/lib/dt.jar:$JAVA_HOME/lib/tools.jar:$JRE_HOME/lib
ENV HADOOP_HOME=/usr/local/hadoop/$HADOOP_FILE_HOME
ENV PATH=$PATH:$JAVA_HOME/bin:$JRE_HOME/bin:$HADOOP_HOME/bin:$HADOOP_HOME/sbin
#安装必要的工具
RUN apt-get update \
    && apt-get install -y axel vim openssh-server tar \
    #下载sunjdk
   && axel -a -n $AXELT http://pubqn.ayouran.com/$JDK  \
   # 安装jdk
    && mkdir /usr/java \
    && tar -zxvf $JDK -C /usr/java \
    #下载hadoop
    &&  axel -a -n $AXELT http://mirror.bit.edu.cn/apache/hadoop/common/$HADOOP_FILE_HOME/$HADOOP  \
    #安装hadoop
    #创建hadoop需要的文件目录
    && mkdir -p ~/hdfs/namenode ~/hdfs/datanode $HADOOP_HOME/log \
    && tar -zxvf $HADOOP -C /usr/local/hadoop \
    #复制配置文件
    && cp -f hadoop/* /usr/local/hadoop/$HADOOP_FILE_HOME/etc/hadoop \
    ##配置hadoop
    #格式化hdfs文件系统
    && hdfs namenode -format \
    #生成sshkey
    && ssh-keygen -t rsa -f ~/.ssh/id_rsa -P '' \
    #配置本机免密登录
    && cat ~/.ssh/id_rsa.pub >> ~/.ssh/authorized_keys \
    && mv ssh/ssh_config ~/.ssh/config \
    #清理
    && rm -rf  hadoop ssh $HADOOP $JDK \
    && chmod +x ~/start-hadoop.sh  \
    && chmod +x ~/run-wordcount.sh  \
    && chmod +x $HADOOP_HOME/sbin/start-dfs.sh  \
    && chmod +x $HADOOP_HOME/sbin/start-yarn.sh

CMD [ "sh", "-c", "service ssh start; bash"]