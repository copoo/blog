# Mysql

## 安装

    yum install mysql-server mysql-devel mysql -y


### 安装在用户目录中

5.1.55

    ./configure	\
    	--prefix=$HOME/local/mysql \
    	--without-debug \
    	--with-unix-socket-path=$HOME/local/mysql/tmp/mysql.sock \
    	--with-client-ldflags=-all-static \
    	--with-mysqld-ldflags=-all-static \
    	--enable-assembler \
    	--with-extra-charsets=latin1,gbk,utf8 \
    	--with-pthread \
    	--enable-thread-safe-client \
    	--with-plugins=partition,heap,innobase,myisam,myisammrg,csv

    make -j 8	使用cpu核数
    make install


    初始MySQL配置表（用户表 权限表等）

    ./bin/mysql_install_db --basedir=/home/hadoop/local/mysql  --datadir=/home/hadoop/local/mysql/data --user=hadoop --force

5.5.29

    wget http://cdn.mysql.com/Downloads/MySQL-5.5/mysql-5.5.29.tar.gz
    安装依赖cmake
    wget http://www.cmake.org/files/v2.8/cmake-2.8.4.tar.gz
    wget http://ftp.gnu.org/gnu/bison/bison-2.5.tar.gz
    
    cmake -DCMAKE_INSTALL_PREFIX=$HOME/local/mysql \
    	-DMYSQL_UNIX_ADDR=$HOME/local/mysql/tmp/mysql.sock \
    	-DDEFAULT_CHARSET=utf8 \
    	-DDEFAULT_COLLATION=utf8_general_ci \
    	-DWITH_EXTRA_CHARSETS=all \
    	-DWITH_MYISAM_STORAGE_ENGINE=1 \
    	-DWITH_INNOBASE_STORAGE_ENGINE=1 \
    	-DWITH_MEMORY_STORAGE_ENGINE=1 \
    	-DWITH_READLINE=1 \
    	-DENABLED_LOCAL_INFILE=1 \
    	-DMYSQL_DATADIR=$HOME/local/mysql/data \
    	-DMYSQL_USER=$USER


## 配置

    vim /etc/my.cnf

    cp share/mysql/my-medium.cnf my.cnf

修改配置文件 配置数据文件、日志的路径

    su - mysql
    vi my.cnf
    basedir				= /home/mysql/local/mysql
    datadir				= /home/mysql/local/mysql/data
    socket				= /home/mysql/local/mysql/run/mysql.sock
    log-error			= /home/mysql/local/mysql/log/alert.log
    slow_query_log		= /home/mysql/local/mysql/log/slow.log
    
    innodb_data_home_dir        = /home/mysql/local/mysql/data
    innodb_data_file_path       = ibdata1:10M:autoextend
    innodb_log_group_home_dir   = /home/mysql/local/mysql/data

    mkdir log run data tmp

## 启动

    /etc/init.d/mysqld start
    chkconfig --add mysqld
    chkconfig mysqld on

    ./bin/mysqladmin -u root password 'root'


## 账号初始化

root

    mysqladmin -u root password 'root'
    mysqladmin -u root -h cnode510 password 'root'
    mysqladmin -u root -h 127.0.0.1 -P 53306 password 'root'

用户权限

	grant all on test.* to test@"%" identified by "test"
    grant all on *.* to uhp@"%" identified by "uhp"
    grant all on *.* to uhp@"`hostname`" identified by "uhp"
    grant all on *.* to uhp@"localhost" identified by "uhp"
	grant all on hive_metastore.* to hive@"space1" identified by "hive";
	grant all on bi.* to bi@"%" identified by "bi" ;
	flush privileges;

删除用户

	Delete FROM user Where User='test' and Host='localhost';
	flush privileges;
	

CREATE DATABASE "mydd" ENGINE = InnoDB



## 数据库迁移

导出

    mysqldump [OPTIONS] database [tables]
        --add-locks
        -e, --extended-insert
        -F, --flush-logs
        -h, --host=..
        --opt
        	同--quick --add-drop-table --add-locks --extended-insert --lock-tables。
        -pyour_pass
        -P port_num
        -S /path/to/socket
        -u user_name

    mysqldump --opt database > backup-file.sql
    mysqldump --opt database | mysql --host=remote-host -C database
    mysqldump -u 用户名 -p 数据库名 表名> 导出的文件名

导入

常用source 命令。进入mysql数据库控制台，如

    mysql -u root -p
    mysql>use 数据库
    mysql>source d:\wcnc_db.sql

实际使用

    mysqldump -h space1 -P 53306 -u root -proot hive_metastore > hive_metastore.sql
    mysql -h cnode431 -P 53306 -u root -proot hive_metastore < hive_metastore.sql


## Bin日志删除

    PURGE MASTER LOGS BEFORE DATE_SUB( NOW( ), INTERVAL 3 DAY);

    [mysql的binlog日志删除与限制大小](http://www.111cn.net/database/mysql/63285.htm)

    在配置文件中：    expire_logs_days=3