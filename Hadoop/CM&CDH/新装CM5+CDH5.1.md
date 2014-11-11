# 新装CDH5.1

[版本详细](http://www.cloudera.com/content/cloudera-content/cloudera-docs/CDH5/latest/CDH-Version-and-Packaging-Information/cdhvd_cdh_package_tarball.html#topic_3_unique_8)

[使用Cloudera Manager 5](http://www.cloudera.com/content/support/en/documentation/manager/cloudera-manager-v5-latest.html)

# 操作记录

1.  新配用户hadoop
    1.  useradd hadoop
    2.  passwd hadoop
    3.  visudo #配置免密码sudo用户

4.  修改hosts

4.  配置免密码登陆，配置免密码sudo

5.  系统环境
    1.  service iptables stop
    2.  关闭selinux：setenforce 0或修改/etc/selinux/config：SELINUX=disabled
    3.  epel源，用于安装python2.6【可选操作】

4.  Mysql
    1.  yum install mysql-server mysql-devel mysql -y
    2.  /etc/init.d/mysqld start
    3.  chkconfig --add mysqld
    4.  chkconfig mysqld on
    5.  mysqladmin -u root password 'root'
    6.  yum install mysql-connector-java -y

6.  初步安装
    1.  下载bin

        http://www.cloudera.com/content/support/en/downloads/cloudera_manager/cm-5-1-0.html

    2.  chmod a+x cloudera-manager-installer.bin
    3.  ./cloudera-manager-installer.bin

4.  界面安装cm

5.  界面安装cdh
    
    主机检查修改

    2.  修改/proc/sys/vm/swappiness

            echo 'vm.swappiness=0'>> /etc/sysctl.conf
            sysctl vm.swappiness=0
            cat /proc/sys/vm/swappiness

    3.  禁用THP：tdp

            echo never > /sys/kernel/mm/redhat_transparent_hugepage/defrag
            echo 'echo never > /sys/kernel/mm/redhat_transparent_hugepage/defrag' >> /etc/rc.local

6.  数据库配置

    这里是给hive用的。cm用的数据库是内置的pg。

    1.  create database hive;
    2.  grant all on hive.* to hive@"%" identified by "hive";
    3.  grant all on hive.* to hive@"cnode712" identified by "hive";
    3.  grant all on hive.* to hive@"localhost" identified by "hive";
    4.  grant all on hive.* to hive@"127.0.0.1" identified by "hive";

1.  初步参数配置：在配置页面
2.  转HA

    完成本向导后手动执行下列步骤：
    
    1.  将 Hue 服务 Hue 的 HDFS Web 界面角色 配置为 HTTPFS 角色，而非 NameNode。 Documentation
    2.  对于每个 Hive 服务 Hive，停止 Hive 服务，将 Hive Metastore 数据库备份到永久性存储中，运行服务命令"更新 Hive Metastore NameNodes"，然后重启 Hive 服务。

3.  配置时间同步crontab；关闭时间差值检测

        0 3 * * * ntpdate clock.redhat.com > /dev/null 2>&1
        #0 3 * * * ( ntpdate ntp.ucweb.com && /sbin/hwclock -w ) > /dev/null 2>&1

4.  配置各种服务

    1.  zk
    2.  hdfs
    3.  yarn
    4.  hbase
    5.  hive
    6.  impala (需要设置hdfs的实体数据目录权限为755)
    7.  oozie
    8.  spark
    8.  hue    

5.  补充LZO
    
    另有文档**cdh-lzo.md**.

    增加：http://archive.cloudera.com/gplextras5/parcels/latest
    下载，分发，激活，重启

    在界面修改，hadoop支持的编码选项，加入lzo

    测试： 1. 构建数据，lzop压缩后上传，能用hdfs text命令看到原文。
          2. 用此数据运行wordcount程序。
    
6.  公平调度器
1.  补充RM HA
6.  ＫＢ
    
     主要参考文章：<http://wenku.baidu.com/view/dd00de300b4c2e3f57276320>
     和统计组文档《CDH安全性部署手册》

        （ALL）yum install krb5-server krb5-libs krb5-workstation
        （711）编辑/etc/krb5.conf和/var/kerberos/krb5kdc/kdc.conf(711)

        （ALL)echo -e "[logging]\n default = FILE:/var/log/krb5libs.log\n kdc = FILE:/var/log/krb5kdc.log\n admin_server = FILE:/var/log/kadmind.log\n\n[libdefaults]\n default_realm = CDH\n #dns_lookup_realm = false\n #dns_lookup_kdc = false\n ticket_lifetime = 24h\n renew_lifetime = 7d\n forwardable = true\n clockskew = 120\n\n[realms]\n CDH = {\n  kdc = cnode711:88\n  admin_server = cnode711:749\n }\n\n[domain_realm]\n\n[kdc]\n profile = /var/kerberos/krb5kdc/kdc.conf" > /etc/krb5.conf

        （711）kdb5_util create -r CDH -s
        # 密码已经记录
        (711)vim /var/kerberos/krb5kdc/kadm5.acl
        (711)kadmin.local #管理，创建用户
        生成Cloudera Manger Server principal
        # 密码已经记录
    
        在CM界面的管理菜单中，开启Kerbroes功能。

        后续有些非关键步骤，不再记录

7.  业务特别环境

    1.  和Python（2.7）

    		需要模块：
    		sqlite3
    		bz2
    		dbm
    		gdbm
    		hashlib
    		zlib
    		
    		需要系统安装：
    		sudo yum install zlib-devel -y
    		sudo yum install bzip2-devel -y
    		sudo yum install gdbm-devel -y
    		sudo yum install sqlite-devel -y
    		sudo yum install libssl-dev -y
    		
    		sudo yum install zlib-devel bzip2-devel gdbm-devel sqlite-devel libssl-dev -y
    		
    		wget "http://www.python.org/ftp/python/2.7.5/Python-2.7.5.tar.bz2"
    		tar -xvf Python-2.7.5.tar.bz2
    		cd Python-2.7.5
    		./configure
    		make
    		sudo make install

### 注意事项

1. KB压缩算法不要选择rc4，因为kprop有bug。
2. KB压缩算法不要选择ace，因为需要java配置额外的策略文件

   最终选择的是：des3-cbc-sha1 arcfour-hmac-md5 des-cbc-crc des-cbc-md5 des-cbc-md4

## 补充知识

[安装和管理 Kerberos](https://www.suse.com/zh-cn/documentation/sles10/book_sle_reference/data/cha.kerbadmin.html)

## 安装遇到小问题

1.  Hue启动异常

        exec /home/cloudera/parcels/CDH-5.1.0-1.cdh5.1.0.p0.53/lib/hue/build/env/bin/hue kt_renewer

        kinit: Ticket expired while renewing credentials

    需要： modprinc -maxrenewlife 1week krbtgt/CDH

2.  rc4和kpropd的bug:
<http://krbdev.mit.edu/rt/Ticket/Display.html?id=7561&user=guest&pass=guest>

3.  创建kdc的slave时：`krb5kdc: Cannot find/read stored master key - while fetching master key K/M for realm EXAMPLE.COM`
    原因是：The slave KDC does not have a stash file (.k5.EXAMPLE.COM). You need to create one:

    可以使用命令：kdb5_util stash
    或者把master上的 /var/kerberos/ker*/.k5.CDH 拷贝过来
