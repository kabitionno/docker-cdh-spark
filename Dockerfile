FROM centos:centos6
MAINTAINER Yogesh Pandit

USER root

ADD scripts/* /tmp/

# Install prerequisites
RUN yum install -y curl which tar sudo htop openssh-server openssh-clients automake autoconf gcc-c++ m4 perl git libtool libevent-devel zlib-devel openssl-devel openssl wget git mysql-server mysql mysql-connector-java python-devel mysql-devel sqlite-devel libxml2-devel libxslt-devel epel-release openldap-clients openldap-servers vim tree; yum update -y libselinux

RUN wget nginx.org/packages/centos/6/noarch/RPMS/nginx-release-centos-6-0.el6.ngx.noarch.rpm
RUN rpm -i nginx-release-centos-6-0.el6.ngx.noarch.rpm; rm nginx-release-centos-6-0.el6.ngx.noarch.rpm
RUN yum install nginx; yum clean all

# Passwordless SSH
RUN ssh-keygen -q -N "" -t dsa -f /etc/ssh/ssh_host_dsa_key; ssh-keygen -q -N "" -t rsa -f /etc/ssh/ssh_host_rsa_key; ssh-keygen -q -N "" -t rsa -f /root/.ssh/id_rsa
RUN cp /root/.ssh/id_rsa.pub /root/.ssh/authorized_keys

# Install Java
RUN cd /tmp; wget http://www-lry.ciril.net/client/java/jdk-7u75-linux-x64.rpm
RUN rpm -Uh /tmp/jdk-7u75-linux-x64.rpm; rm /tmp/jdk-7u75-linux-x64.rpm

# Set JAVA_HOME and PATH
ENV JAVA_HOME /usr/java/latest
ENV PATH $JAVA_HOME/bin:$PATH
RUN echo -e "export JAVA_HOME=/usr/java/latest\nexport PATH=$JAVA_HOME/bin:$PATH" > /etc/profile.d/java.sh; source /etc/profile.d/java.sh

# CDH-5.3.0
RUN wget archive.cloudera.com/cdh5/one-click-install/redhat/6/x86_64/cloudera-cdh-5-0.x86_64.rpm
RUN rpm -i cloudera-cdh-5-0.x86_64.rpm; rm cloudera-cdh-5-0.x86_64.rpm
RUN rpm --import http://archive.cloudera.com/cdh5/redhat/6/x86_64/cdh/RPM-GPG-KEY-cloudera
RUN yum clean all; yum install -y hadoop-hdfs-namenode hadoop-hdfs-secondarynamenode hadoop-hdfs-datanode hive hive-metastore

ENV HADOOP_CONF_DIR /etc/hadoop/conf
ENV HADOOP_HOME /usr/lib/hadoop
ENV HADOOP_PREFIX /usr/lib/hadoop
ENV HIVE_CONF_DIR /etc/hive/conf
ENV SPARK_HOME /usr/lib/spark/1.3.1

RUN sh /tmp/install.sh

RUN sh /tmp/configure.sh

ADD bootstrap.sh /etc/bootstrap.sh
RUN chown root:root /etc/bootstrap.sh; chmod 700 /etc/bootstrap.sh

RUN rm /tmp/install.sh; rm /tmp/configure.sh

CMD ["/etc/bootstrap.sh", "-bash"]
