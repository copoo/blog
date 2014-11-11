# kerberos 安装、配置和master slave

主要参考文章：<http://wenku.baidu.com/view/dd00de300b4c2e3f57276320>

阅读本文，务必阅读上面的参考文档。

系统环境：centos 6.4 6.3

## 安装

    yum install krb5-server krb5-libs krb5-workstation

## 配置

主要配置：

1.  /etc/krb5.conf

        [libdefaults]
        ; CDH是领域名，可以自定义，通常是域名方式
        ; 这里直接用大写是习惯，也是为了避免大小写问题
        default_realm = CDH
        dns_lookup_kdc = false
        kdc = cnode1
        dns_lookup_realm = false
        ticket_lifetime = 86400
        renew_lifetime = 604800
        forwardable = true
        ; 避免使用ace和rc4
        ; 这是基于实际应用和当前版本设定的
        default_tgs_enctypes = des3-cbc-sha1 arcfour-hmac-md5 des-cbc-crc des-cbc-md5 des-cbc-md4
        default_tkt_enctypes = des3-cbc-sha1 arcfour-hmac-md5 des-cbc-crc des-cbc-md5 des-cbc-md4
        permitted_enctypes = des3-cbc-sha1 arcfour-hmac-md5 des-cbc-crc des-cbc-md5 des-cbc-md4
        udp_preference_limit = 1
        ; 应对一些基本的网络故障，可选设置
        clockskew = 120
        [realms]
        CDH = {
        kdc = node1
        ; 第二个kdc是用于master slave的
        kdc = node2
        admin_server = node1
        }

2.  /var/kerberos/krb5kdc/*
    
        [kdcdefaults]
         kdc_ports = 88
         kdc_tcp_ports = 88
        
        [realms]
         CDH = {
          #master_key_type = aes256-cts
          acl_file = /var/kerberos/krb5kdc/kadm5.acl
          dict_file = /usr/share/dict/words
          admin_keytab = /var/kerberos/krb5kdc/kadm5.keytab
          supported_enctypes = aes256-cts:normal aes128-cts:normal des3-hmac-sha1:normal arcfour-hmac:normal des-hmac-sha1:normal des-cbc-md5:normal des-cbc-crc:normal
         }    

3.  /var/kerberos/krb5kdc/kadm5.acl

        */admin@CDH	*


其中，/etc/krb5.conf还是要每台机器都有的，并且要保持一致。另2个配置是在KDC主机上才需要的。

### 用户及管理

1.  创建数据库

        kdb5_util create -r CDH -s

        Loading random data
        Initializing database '/var/kerberos/krb5kdc/principal' for realm 'CDH',
        master key name 'K/M@CDH'
        You will be prompted for the database Master Password.
        It is important that you NOT FORGET this password.
        Enter KDC database master key: 
        Re-enter KDC database master key to verify: 

    创建数据库：CDH  
    数据库文件：/var/kerberos/krb5kdc/principal  
    数据库用户：K/M@CDH  
    数据库密码：自己设定

## master slave

master slave之间的数据用kprop传输。  此传输需要自己定时任务实现。

1. master启动服务
   
        service krb5kdc start
        service kadmin start

2. 创建管理用户

        kadmin.local         
        Kadmin.local:  addprinc root/admin@CDH

3.  创建用于kprop的用户，此用户要使用keytab方式认证身份，以长期有效
    
    *   在master上
    
            kadmin.local

            kadmin.local: addprinc  -randkey  host/node1
            # 生成keytab
            kadmin.local: ktadd  host/node1

            kadmin.local: addprinc  -randkey  host/node2

    *   在slave上
    
            kadmin # 这个命令，需要输入root/admin用户的密码
            # 生成keytab
            kadmin: ktadd  host/node2
        
    *   拷贝配置文件到slave，保持一致

            krb5.conf、kdc.conf、kadmin5.acl、.cdh.krb5（stash file）

    *   在slave上

            touch /var/kerberos/krb5kdc/kpropd.acl

            host/node1@CDH
            host/node2@CDH
    
    *   在slave上

            service kprop start

    *   在master上

            kdb5_util dump slave_datatrans
            kprop -f slave_datatrans node2

            Database propagation to ***: SUCCEEDED
    
    成功后，slave上的数据和配置就和master一致了。

## 常用操作

1.  添加用户

        kadmin.local # 在kdc主机上， 在非kdc主机

        Authenticating as principal root/admin@CDH with password.
        Kadmin.local:  addprinc root/admin@CDH
        WARNING: no policy specified for root/admin@CDH; defaulting to no policy
        Enter password for principal "root/admin@CDH": 
        Re-enter password for principal "root/admin@CDH": 
        Principal "root/admin@CDH" created.

    上述是创建了管理用户，此用户有创建admin权限，可以创建和管理其它用户。
    
        kadmin.local:  addprinc test # 创建普通用户
        kadmin.local:  listprincs # 列出用户
        kadmin.local:  help # 帮助
        kadmin.local:  addprinc -randkey host/node33@CDH # 添加随机密码用户，用keytab方式登陆
        kadmin.local:  ktadd host/gcstat1 # 结合上面的语句，生成此用户的keytab文件		

2.  认证

        kinit test # 初始化test用户的票据

        Password for test@CDH:

        klist -e # 列出当前环境的有效票据
        
		以特定keytab文件认证
		kinit -kt hiveadmin.keytab hiveadmin@CDH
		
		认证后就可以正常操作了。

3.  有root/admin的权限后，可以使用其他用户身份

        kinit root/admin
        kadmin> ktadd -k solr.kt solr
        kadmin> quit
        kinit -kt solr.kt solr
        klist

4.  keytab

        klist -e -k -t hdfs.keytab
        kinit -k -t hdfs.keytab hdfs/fully@YOUR-REALM.COM