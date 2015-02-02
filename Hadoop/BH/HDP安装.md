# HDP 安装

<http://docs.hortonworks.com/HDPDocuments/Ambari-1.7.0.0/Ambari_Install_v170/index.html#Item1.1>

## 准备

### 要求

1. centos 6.x
2. scp, curl, unzip, tar, and wget，net-tools（netstat)，openssh-server（sshd)
3. OpenSSL (v1.01, build 16 or later)
4. python (v2.6 or later)
5. Oracle JDK 1.7_67 64-bit (default)
6. PostgreSQL
	12. postgresql 8.4.13-1.el6_3, 
	13. postgresql-libs 8.4.13-1.el6_3, 
	14. postgresql-server 8.4.13-1.el6_3
7. MySQL
8. Derby
9. ulimit -Sn 10000
10. ulimit -Hn 10000
11. fully qualified domain name 全域名。A FQDN consists of a short host name and the DNS domain name.
12. nagios
	13. nagios 3.5.0-99
	13. nagios-devel 3.5.0-99
	14. nagios-www 3.5.0-99
	15. nagios-plugins 1.4.9-1
16. ganglia
	1. ganglia-gmetad 3.5.0-99, 
	2. ganglia-devel 3.5.0-99, 
	3. libganglia 3.5.0-99, 
	4. ganglia-web 3.5.7-99, 
	5. rrdtool 1.4.5-1.el6
	6. ganglia-gmond 3.5.0-99
	7. libganglia 3.5.0-99
8. 免密码ssh
9. ntp，时间同步
10. 配置dns或者使用/etc/hosts
11. 设置域名与FQDN相同
	1. hostname <fully.qualified.domain.name>
	2. hostname -f 检查
12. 设置网络配置
	1. vi /etc/sysconfig/network/config
	
			NETWORKING=yes
			NETWORKING_IPV6=yes
			HOSTNAME=<fully.qualified.domain.name>

13. 关闭iptables

		chkconfig iptables off
		/etc/init.d/iptables stop

14. Disable SELinux and PackageKit
15. umark为022，在 /etc/profile中设置
16. 


## dock-ambari

	cd /etc/yum.repos.d
    curl "https://raw.githubusercontent.com/sequenceiq/docker-ambari/master/ambari-server/ambari.repo" -o ambari.repo
	curl "https://raw.githubusercontent.com/sequenceiq/docker-ambari/master/ambari-server/hdp.repo" -o hdp.repo
	cd
	yum install -y openssh-server && /etc/init.d/sshd start
    # 免密码
    ssh-keygen && cd ./ssh && cp id_rsa.pub authorized_keys && chmod 600 auth* 
	yum install -y ambari-server ambari-agent
	yum install -y tar git curl
	yum install java-1.7.0-openjdk ?
	ambari-server setup --silent	
	yum install -y ambari-log4j hadoop hadoop-libhdfs hadoop-lzo hadoop-lzo-native hadoop-mapreduce hadoop-mapreduce-historyserver hadoop-yarn hadoop-yarn-nodemanager hadoop-yarn-proxyserver hadoop-yarn-resourcemanager lzo net-snmp net-snmp-utils snappy snappy-devel unzip zookeeper
	ENV JAVA_HOME /usr/jdk64/jdk1.7.0_45
	ENV PATH $PATH:$JAVA_HOME/bin
	yum install -y sudo
	需要仿照 sequenceiq/dnsmasq 安装并配置


	/etc/ambari-agent/conf/public-hostname.sh
	/etc/ambari-agent/conf/internal-hostname.sh
	/etc/ambari-agent/conf/ambari-agent.ini


hostname, hostname -f and /etc/hosts


需要的

	sequenceiq/dnsmasq
	/sequenceiq/docker-ssh
	sequenceiq/ambari-shell


在外层

	sudo echo "nameserver 8.8.8.8" >> /etc/resolve.conf

可选的

	可选 自己安装 jdk /var/lib/ambari-server/resources/jdk-7u45-linux-x64.tar.gz


Couldn't resolve host 'mirrorlist.centos.org'