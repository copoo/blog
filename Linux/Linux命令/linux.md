# Linux

发行版本：

1.  CentOS
2.  RH



## 网络

从minimal iso安装的操作系统，默认不能联网，使用如下方式安装网络

<http://lintut.com/how-to-setup-network-after-rhelcentos-7-minimal-installation/>

[网卡操作命令](http://wujunfeng.blog.51cto.com/3041/965292)

1.  列出网卡

        nmcli d

2.  编辑连接

        nmtui

3.  DHCP配置

    简单图形界面选择

4.  重启服务

        /etc/init.d/network restart

查看系统版本：

1.  `uname -r`
2.  `uname -a`
2.  `cat /proc/version` 内核版本
2.  `lsb_release -a` 发行版本，扩展的命令工具

## yum
    
源：

1.  EPEL

        yum install epel-release

		sudo sed -i "s/mirrorlist=https/mirrorlist=http/" /etc/yum.repos.d/epel.repo

    RPM下载安装

        wget http://dl.fedoraproject.org/pub/epel/5/i386/epel-release-5-4.noarch.rpm
        wget http://dl.fedoraproject.org/pub/epel/6/i386/epel-release-6-8.noarch.rpm
        rpm -i epel-release*.rpm

2. rpmforge

3. nginx

    [nginx] 
    name=nginx repo 
    baseurl=http://nginx.org/packages/centos/$releasever/$basearch/ 
    gpgcheck=0 
    enabled=1


## 系统优化

### selinux

修改/etc/selinux/config文件中的SELINUX="" 为 disabled ，然后重启。

setenforce 1 设置SELinux 成为enforcing模式

setenforce 0 设置SELinux 成为permissive模式 

查看状态setstatus -v 


### swappiness

<http://blog.sina.com.cn/s/blog_60aa9ccd0100h433.html>

    cat /proc/sys/vm/swappiness
    echo 0 > /proc/sys/vm/swappiness
    sudo vim /etc/sysctl.conf
        vm.swappiness=10
    echo -e "\nvm.swappiness=0" >> /etc/sysctl.conf

### ulimit

运行ulimit只对当前session有效

编辑/etc/profile文件，例如 “ulimit -S -c 0 > /dev/null 2>&1”，对所有用户有效，但只是对以前启动的进程无效。

对整个系统有效的：`vi /etc/security/limits.conf`，对新进程有效

type：有 soft，hard 和 -，soft 指的是当前系统生效的设置值。hard 表明系统中所能设定的最大值。soft 的限制不能比har 限制高。用 - 就表明同时设置了 soft 和 hard 的值。

    进程数： ulimit   -u 10000
    数据段长度：ulimit -d unlimited
    最大内存大小：ulimit -m unlimited
    堆栈大小：ulimit -s 262140
    CPU 时间：ulimit -t unlimited
    虚拟内存：ulimit -v unlimited
    打开的文件：ulimit -n 65535

##  磁盘坏道


如果只是逻辑坏道
umount /dev/sdc1
fsck -y /dev/sdc1
mount /dev/sdc1

如果是物理坏道


badblocks


## 时间

### 时区

复制相应的时区文件，替换系统时区文件；或者创建链接文件

	cp /usr/share/zoneinfo/$主时区/$次时区 /etc/localtime

在中国可以使用：

	cp /usr/share/zoneinfo/Asia/Shanghai /etc/localtime

### 时间同步


    0 3 * * * ntpdate clock.redhat.com > /dev/null 2>&1
    0 3 * * * ( ntpdate ntp.ucweb.com && /sbin/hwclock -w ) > /dev/null 2>&1
	

## dns


## 常用命令

1.  chkconfig 随机启动


2.  ssh黄金参数

    ssh -o ConnectTimeout=3 -o ConnectionAttempts=5 -o PasswordAuthentication=no -o StrictHostKeyChecking=no $ip  “command”
    1 ConnectTimeout=3                    连接时超时时间，3秒
    2 ConnectionAttempts=5                连接失败后重试次数，5次
    3 PasswordAuthentication=no           是否使用密码认证，（在遇到没做信任关系时非常有用，不然会卡在那里）
    4 StrictHostKeyChecking=no            第一次登陆服务器时自动拉取key文件，（跟上面一样，并且在第一次ssh登陆时，自动应答yes）