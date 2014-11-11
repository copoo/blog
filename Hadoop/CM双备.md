# CM备份和灾难恢复 （BDR）

CM是单点的，CM主机故障后迁移比较麻烦。

[Cloudera Backup and Disaster Recovery](http://www.cloudera.com/content/cloudera-content/cloudera-docs/CM4Ent/4.7.3/Cloudera-Backup-Disaster-Recovery/Cloudera-Backup-Data-Recovery.html?scroll=xd_583c10bfdbd326ba-3ca24a24-13d80143249--7f77)

需要商业Liences

V4.7.3

CM的密码文件存放：

* /etc/cloudera-scm-server/db.properties
* /etc/cloudera-scm-server/db.mgmt.properties

## 数据库备份

CM的数据库

*   Cloudera Manager database: `scm`
 
    这是最重要的数据库。包含全部信息，你配置了哪些服务，它们的角色分配，全部配置历史，命令，用户和运行时进程。这是一个小数据，通常它小于100M。
    
*   Activity Monitor database: `amon`

    过去的活跃信息。在大的集群，非常巨大

*   Service Monitor database: `smon`

    后台服务的监控信息，巨大

*   Report Manager database: `rman`

    保存对磁盘使用的跟踪。中等尺寸。

*   Host Manager database: `hmon`

    保存主机状态。主机数量影响数据大小。

### MySQL

修改为主备模式

### PostgreSQL

#### CM PostgreSQL的安装情况

CM使用`cloudera-scm`作为root账号
CM使用`scm`账号进行管理

    psql -p 7432 -U cloudera-scm -d postgres
    psql -h localhost -p 7432 -U scm -d scm

默认情况下，库表情况如下：

    \l
    --

       Name    |    Owner     | Encoding | Collation  |   Ctype    |         Access privileges         |  Size   | Tablespace |        Description        
    -----------+--------------+----------+------------+------------+-----------------------------------+---------+------------+---------------------------
     amon      | amon         | UTF8     | en_US.UTF8 | en_US.UTF8 |                                   | 14 MB   | pg_default | 
     hive      | hive         | UTF8     | en_US.UTF8 | en_US.UTF8 |                                   | 7088 kB | pg_default | 
     hmon      | hmon         | UTF8     | en_US.UTF8 | en_US.UTF8 |                                   | 31 GB   | pg_default | 
     nav       | nav          | UTF8     | en_US.UTF8 | en_US.UTF8 |                                   | 5408 kB | pg_default | 
     postgres  | cloudera-scm | UTF8     | en_US.UTF8 | en_US.UTF8 |                                   | 5510 kB | pg_default | 
     rman      | rman         | UTF8     | en_US.UTF8 | en_US.UTF8 |                                   | 5408 kB | pg_default | 
     scm       | scm          | UTF8     | en_US.UTF8 | en_US.UTF8 |                                   | 280 MB  | pg_default | 
     smon      | smon         | UTF8     | en_US.UTF8 | en_US.UTF8 |                                   | 24 GB   | pg_default | 

    \du
    ---
                 List of roles
      Role name   | Attributes  | Member of 
    --------------+-------------+-----------
     amon         |             | {}
     cloudera-scm | Superuser   | {}
                  : Create role   
                  : Create DB     
     hive         |             | {}
     hmon         |             | {}
     nav          |             | {}
     rman         |             | {}
     scm          |             | {}
     smon         |             | {}

其中

    `nav`用于cloudera-scm-navigator，它是企业版功能
    `rman`没有使用

#### PostgreSQL的基本操作

[PostgreSQL新手入门](http://www.ruanyifeng.com/blog/2013/12/getting_started_with_postgresql.html)

    psql --version

    createdb testdb;
    dropdb testdb

    help
    \h：查看SQL命令的解释，比如\h select。
    \?：查看psql命令列表。
    \l+    #列出数据库
    \c [database_name]：连接其他数据库。
    \d：列出当前数据库的所有表格。
    \d [table_name]：列出某一张表格的结构。
    \dt    #列出当前库的表
    \q     #quit    
    \du：列出所有用户。
    \e：打开文本编辑器。
    \conninfo：列出当前数据库和连接的信息。

    CREATE USER dbuser WITH PASSWORD 'password';
    CREATE DATABASE exampledb OWNER dbuser;
    GRANT ALL PRIVILEGES ON DATABASE exampledb to dbuser;

#### 备份和恢复方法

##### pg_dump备份

[pg_dump](http://hi.baidu.com/bsdgo/item/50544eddb7b76e32e3108fd6)

1. `postgres`库和`scm`库
2. `amon`、`hmon`、`smon`库 存储的监控信息，不用备份
3. `rman`，`nav`库没有使用，不用创建

-

    export PGPASSWORD="hW9u47D5lS"
    # 备份全部
    pg_dump -Fc -h localhost -p 7432 -U cloudera-scm -f scm.sql scm  
    # 仅备份表结构
    pg_dump -h localhost -p 7432 -U cloudera-scm -s -f amon.s.sql amon
    pg_dump -Fc -h localhost -p 7432 -U cloudera-scm -s -f hmon.s.sql hmon
    pg_dump -Fc -h localhost -p 7432 -U cloudera-scm -s -f smon.s.sql smon

##### 其它机器安装PostgepSQL

[安装外部postgresql](http://www.cloudera.com/content/cloudera-content/cloudera-docs/CM4Ent/4.5.2/Cloudera-Manager-Enterprise-Edition-Installation-Guide/cmeeig_topic_5_6.html)

<http://hi.baidu.com/life_to_you/item/a22a28efcafd3b13595dd832>

    sudo yum install postgresql-server -y
    sudo service postgresql initdb
        旧版本 initdb -D /var/lib/pgsql/data
    sudo -u postgres psql
    postgres=# \q

    vim /etc/init.d/postgresql
        PGPORT=5432 -> 7432
    vim /var/lib/pgsql/data/pg_hba.conf
        添加：
        host    all     all     0.0.0.0/0       md5
    vim /var/lib/pgsql/data/postgresql.conf
        添加：
        listen_addresses = '*'
    /etc/init.d/postgresql restart
    sudo -u postgres psql -p 7432

**保持账户和密码一致**

    postgres=# CREATE ROLE scm LOGIN PASSWORD 'u4KCI9V5ht';
    postgres=# CREATE DATABASE scm OWNER scm ENCODING 'UTF8';

    postgres=# CREATE ROLE amon LOGIN PASSWORD 'Wf1zIq972x';
    postgres=# CREATE DATABASE amon OWNER amon ENCODING 'UTF8';

    postgres=# CREATE ROLE smon LOGIN PASSWORD 'dGdcdRtG22';
    postgres=# CREATE DATABASE smon OWNER smon ENCODING 'UTF8';

    postgres=# CREATE ROLE hmon LOGIN PASSWORD 'i4yqU2k71d';
    postgres=# CREATE DATABASE hmon OWNER hmon ENCODING 'UTF8';

    CREATE ROLE "cloudera-scm" LOGIN PASSWORD 'yuePy2HiUq';
    GRANT ALL PRIVILEGES ON TABLESPACE pg_default to "cloudera-scm";
    GRANT scm, amon, smon, hmon TO "cloudera-scm";

    postgres=# \q

##### pg_store恢复

    sudo -u postgres psql -p 7432 -d amon < ./backup/amon.s.sql
    sudo -u postgres psql -p 7432 -d smon < ./backup/smon.s.sql
    sudo -u postgres psql -p 7432 -d hmon < ./backup/hmon.s.sql

    sudo -u postgres pg_restore -d scm ./backup/scm.sql


## CM Server双备

[cloudera manager tarball安装](http://hi.baidu.com/life_to_you/item/cdeab0d89bbfa24efb5768e2)

[Installation Using Tarballs](http://www.cloudera.com/content/cloudera-content/cloudera-docs/CM4Ent/latest/Cloudera-Manager-Installation-Guide/cmig_install_path_C.html)

    mkdir /opt/cloudera-manager
    wget http://archive-primary.cloudera.com/cm4/cm/4/cloudera-manager-el6-cm4.7.3_x86_64.tar.gz
    tar xzf cloudera-manager*.tar.gz -C /opt/cloudera-manager    
    
    #useradd --system --home=/opt/cloudera-manager/cm-4.7.3/run/cloudera-scm-server --no-create-home --shell=/bin/false --comment "Cloudera SCM User" cloudera-scm

    数据库操作

    sh cm-4.7.3/share/cmf/schema/scm_prepare_database.sh -P 7432 postgresql scm scm

    <tarball root>/etc/init.d/cloudera-scm-server start


## 故障迁移脚本


配置所有的Agents
`vim <tarball root>/etc/cloudera-scm-agent/config.ini`
编辑server_host为新的server ip

    hosts="
    kpi63
    "
    
    set -e
    
    for host in $hosts; do
        echo $host
        #ssh -t -p 9922 $host "sed -i -e 's/server_host=.*/server_host=10.34.201.68/;10q;' /etc/cloudera-scm-agent/config.ini;"
        ssh -t -p 9922 $host "sed -e 's/server_host=.*/server_host=10.34.201.68/;10q;' /etc/cloudera-scm-agent/config.ini;"
        #ssh -t -p 9922 $host "sudo /etc/init.d/cloudera-scm-agent hard_restart"
    done
