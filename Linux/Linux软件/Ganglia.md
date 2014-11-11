# Ganglia

## 简介

<http://ixdba.blog.51cto.com/2895551/1149003>

Ganglia是一个机器监控服务，包括：

1.	gmetad
	
    gmetad周期性的向data source发送轮询包，采集的metrics，经由SAX XML进行解析，更新到数据库（RRD)。任何一个gmond节点都可以接受来自其它节点（根据配置）的metrics数据。

2.	gmond

	onitoring daemon，agent

3.	ganglia-web
	
    Web展示，配合apache  

## yum安装

1.	需要先配置Yum源

    <https://fedoraproject.org/wiki/EPEL/zh-cn>
		
		mkdir -p download;
        cd download;
		wget http://dl.fedoraproject.org/pub/epel/6/i386/epel-release-6-8.noarch.rpm;
		sudo rpm -i epel-release-6-8.noarch.rpm;

2.	在不同机器选择安装

    	sudo yum install ganglia -y
    	sudo yum install ganglia-gmond -y
    	sudo yum install ganglia-gmetad -y	
    	sudo yum install ganglia-web -y

## 配置

采集形式可以配置为单播和多播，建议配置为单播，可以跨网段。

参考：

1.  <http://acidborg.wordpress.com/2010/10/08/how-to-install-and-configure-ganglia-on-red-hat-enterprise-linux-5/>

2.  <http://sourceforge.net/apps/trac/ganglia/wiki/Gmond%203.1.x%20General%20Configuration>

`gmond -t` 查看完整默认的配置  
`gmond -c` 测试配置

###	gmond

配置文件：

`/etc/gmond.conf`或者`/etc/ganglia/gmond.conf`

可以用命令行修改配置：

    sed -e "23,24s/unspecified/hadoop/" /etc/ganglia/gmond.conf
    sed -e "37s/#//"
    sed -e "/mcast_join = 239.2.11.71/d"
    sed -e "43,a/host = node99999/"

具体配置解释

*   cluster

        cluster {
            name = "Millennium Cluster"
            owner = "UC Berkeley CS Dept."
            latlong = "N37.37 W122.23"
            url = "http://www.millennium.berkeley.edu/";
        }
        
    在一个ganglia集群中可以有多个cluster，但是一个gmond实体仅属于一个cluster，它通过name和owner被唯一识别。

*   host

        host {
           location = "1,2,3"
        }
        # Rack, Rank and Plane ？

*   globals

        globals {
            daemonize = true
            setuid = true
            user = nobody
            host_dmax = 3600
        }

    *   debug_level：数字，0，无debug信息，数大信息详细，需要非daemonize方式启动。
    *   host_dmax：'delete max'。数字，秒。>0，gmond在一定时间内没有收到某host的心跳，将删除它。=0，永不删除。
    *   cleanup_threshold：清理阀值，时间。在tn>dmax时，需要清理host和对应的metrics，此值指定还能保留的时间。
    *   send_metadata_interval：metadata包是描述gmond的metrics，默认为0，表示在启动的时候发送一次。在多播模式下这是可以的。但是在‘单播’模式，此值必须指定。单位秒。
    *   module_dir：默认是/usr/lib/ganglia

*   udp_send_channel

    可以配置多个

        udp_send_channel {
            # mcast_join = 239.2.11.71 # 多播
            host = host.foo.com # 单播
            port = 2389
        }

*   udp_recv_channel

    可以指定多个

        udp_recv_channel {
            mcast_join = 239.2.11.71
            bind       = 239.2.11.71
            port       = 8649
        }

        udp_recv_channel {
            port = 8666
            family = inet4
        }

*   tcp_accept_channel

    通过web前端访问ganglia时走的端口号。

    可以指定多个

        tcp_accept_channel {
            port = 8649
        }

    *   timeout：微秒，超时，默认1秒。

*   collection_group

    可以指定多个。  
    可以包含多个metric。metric可以通过`gmond -m`查看。

        collection_group {
            collect_every = 60
            time_threshold = 300
            metric {
              name = "cpu_user"
              value_threshold = 5.0
              title = "CPU User"
            }
            metric {
              name = "cpu_idle"
              value_threshold = 10.0
              title = "CPU Idle"
            }
        }

    *   collect_once：仅在启动时收集一次
    *   collect_every：秒，
    *   time_threshold：秒，默认3600。发送metric的时间阀值。受`value_threshold`影响可能提前发送。
    *   value_threshold：值变动幅度。百分比。值变动幅度达到阀值，提前发送collection_group全部metric。

*   Modules

        modules {
         module {
           name = "example_module"
           enabled = yes
           path = "modexample.so"
           params = "An extra raw parameter"
           param RandomMax {
             value = 75
           }
           param ConstantValue {
             value = 25
           }
         }
       }

    每个session包含：name, language, enabled, path and params。

    *   name：如果是c开发的，它是模块名称。如果是解释性语言开发的，例如python，是文件名。
    *   language：开发语言。
    *   params：传送一个字符串到模块的初始化函数。
    *   param：传递多个参数到初始化函数，通过多个param。

*   include

    包含附件配置文件

        include ('/etc/ganglia/conf.d/*.conf')


### gmetad

`/etc/gmetad.conf`

	# 可以只修改数据源名称，其它用默认值
    # 配置数据采集来源gmond的ip或host    
	data_source "hadoop" localhost
    
    # 可以配置多个
    data_source "Cluster A" 127.0.0.1  1.2.3.4:8655  1.2.3.5:8625
    data_source "Cluster B" 1.2.4.4:8655

###	ganglia-web

配置`/etc/ganglia/conf.php`，基本不需要修改

需要apache， 你可能需要修改配置，比如端口：

    vim /etc/httpd/conf/httpd.conf	

另外，你可能需要修改配置，允许一些网络访问web服务。默认可能范围不足。

    sudo vim /etc/httpd/conf.d/ganglia.conf
    # Deny from all # 把这个去除

## 启动

    /etc/init.d/gmond start
    /etc/init.d/gmetad start
    /usr/local/apache2/bin/apachectl start

完全启动后，可以访问  http://ip:port/ganglia

配置开机启动

    chkconfig --level 345 gmond on   
	chkconfig --level 345 gmetad on

## RRD

<http://oss.oetiker.ch/rrdtool/index.en.html>

rras:

    RRA:AVERAGE:0.5:4:1440
    RRA:AVERAGE:0.5:40:1008
    RRA:AVERAGE:0.5:120:1488
    RRA:AVERAGE:0.5:240:8784

格式说明：

    类型：合并值方式：（未知）:时间单位数：采集点次数

解释如下：

默认15秒算一个采集单位（配置可以修改），时间单位数4，表示每4*15秒（即1分钟）记录一次监控值。最多记录1440次（即24小时）

RRA数据，当记录的时间超出本级别范围，会向下一级别合并。降低精度。

---

# 补充内容

## 编译安装

编译安装需要的依赖比较多，比较繁琐。

./configure --prefix=$HOME/local/ganglia --with-librrd=$HOME/local/rrdtool --with-libapr=$HOME/local/apr/bin/apr-1-config --with-libapu=$HOME/local/apr/bin/apu-1-config --with-libexpat=$HOME/local/expat --with-libconfuse=$HOME/local/confuse --with-gmetad --enable-gexec --enable-status

## 安装Apache和Php

    yum install php-common php-cli php php-gd httpd

安装web程序，这里假定apache的root路径在/var/www/html下面。

    mkdir /var/www/html/ganglia
    cp -a -f ganglia-3.2.0/web/* /var/www/html/ganglia

禁用SELinux setenforce 0 修改rrdtool的路径，文件/var/www/html/ganglia/conf.php中的RRDTOOL

    define("RRDTOOL", "/usr/local/rrdtool/bin/rrdtool");

重启httpd服务器即可看到效果 

    service httpd restart

更多参考 http://www.imxylz.info/wiki/Ganglia/Ganglia
