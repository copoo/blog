# Linux

发行版本：

1.  CentOS
2.  RH

## 目录分配

*   /       根目录分隔越小越好，和开机、还原、修复动作有关
*   /bin    放置的是在单人维护模式下还能够被操作的指令。可以被root与一般账号所使用
*   /boot   开机会使用到的档案，包括Linux 核心档案以及开机选单与开机所需配置文件等
*   /boot/vmlinuz 核心文件
*   /boot/initrd  核心文件
*   /dev    何装置与接口设备都是以档案的型态存在于这个目录当中的
*   /dev/random 随机数生成器  0~32767
*   /dev/null
*   /usr 软件放置处
*   /usr/bin
*   /usr/sbin
*   /usr/include
*   /usr/lib
*   /usr/lib64
*   /usr/local  系统管理员自行安装的软件,非系统默认分发版本。和系统版本吧保持区别
*   /usr/share  共享文件,基本都是文本文件
*   /usr/share/man
*   /usr/src    源码
*   /usr/src/linux  linux的源码
*   /opt 第三方软件
*   /etc 配置文件
*   /etc/init.d 服务的开机启动脚本
*   /etc/rc.d/init.d
*   /etc/sysconfig/*    各种服务的初始化环境配置文件
*   /etc/xinetd.d       super daemon的配置
*   /etc/x11    x window的相关配置
*   /etc/fstab  开机挂载的磁盘
*   /etc/mtab   开机挂载的磁盘
*   /etc/sysconfig/i18n 支持的语言
*   /etc/issue, /etc/motd bash进站和欢迎信息
*   /etc/profile    login shell才会读
*   /etc/profile.d/*.sh
*   /etc/passwd
*   /etc/group
*   /etc/sudoers
*   /etc/securetty/limits.conf
*   /etc/service    设定服务于端口的对应关系
*   /etc/hosts.allow    是/usr/sbin/tcpd的配置文件,以xinetd管理的服务，可以透过它们来设定host访问控制
*   /etc/hosts.deny     凡是被libwrap支持的，都可以被此配置影响,用ldd命令可以测试
*   /etc/crontab        定时任务配置文件
*   /etc/inittab        初始启动等量级 run level
*   /etc/modprobe.conf  自定义模块
*   /etc/sysconfig/modules  自定义模块
*   /etc/sysconfig/authconfig   身份认证机制
*   /etc/sysconfig/clock    设定主机时区
*   /etc/sysconfig/i18n
*   /etc/sysconfig/network
*   /etc/sysconfig/network-scripts/ifcfg-eth*  网卡文件配置
*   /etc/resolv.conf    dns配置文件
*   /var
*   /var/cache
*   /var/lib    程序执行中，需要用的数据文件放置处，例如mysql的/var/lib/mysql
*   /var/mail
*   /var/run    启动后的pid等
*   /var/spool/news
*   /var/lock
*   /var/log
*   /var/log/secure 无法登陆时的安全信息
*   /var/log/messages
*   /home
*   /home/.bash_profile login模式下才会读取
*   /home/.bashrc 登陆和非登陆模式下都会读
*   /lib    开机时会用到的函式库,以及在/bin 或/sbin 底下的指令会呼叫的函式库
*   /lib/modules/$(uname -r)/kernel/arch/* cpu等硬件相关
*   /lib/modules/$(uname -r)/kernel/crypto/* 加密相关
*   /lib/modules/$(uname -r)/kernel/drivers/* 硬件驱动
*   /lib/modules/$(uname -r)/kernel/fs/* 文件系统驱动
*   /lib/modules/$(uname -r)/kernel/lib/* 
*   /lib/modules/$(uname -r)/kernel/net/* 网络协议，防火墙模块等
*   /lib/modules/$(uname -r)/kernel/sound/* 音效相关
*   /lib/modules/$(uname -r)/modules.dep    各个模块的依赖关系
*   /media  包括软盘、光盘、DVD 等等装置
*   /mnt
*   /root
*   /sbin   这些指令只有root 才能够利用
*   /srv
*   /tmp
*   /proc   虚拟文件系统,数据都是在内存当中,例如系统核心、行程信息
*   /proc/cpuinfo
*   /proc/devices
*   /proc/cmdline
*   /proc/filesystems 系统已经加载的文件系统
*   /proc/interrupts  终端分配状态
*   /proc/dma
*   /proc/interrupts
*   /proc/ioports       各个装置的io地址
*   /proc/kcore         内存
*   /proc/loadavg       负载
*   /proc/meminfo
*   /proc/modules       已经加载的模块列表
*   /proc/swaps
*   /proc/partitions    所有分区
*   /proc/pci           pci装置信息
*   /proc/uptime
*   /proc/version       核心版本
*   /proc/sys/kernel    核心功能
*   /proc/net/*
*   /sys

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


## 语言

    echo $LANG
    LANG="en"
    
## 忘记root密码

以单人维护模式登入即可更改你的root 密码。

1.  系统重新启动，在读秒的时候按下任意键
2.  按下『e』就能够进入grub 的编辑模式
3.  选定启动kernael，并且增加 single 标签， 标识单机启动
4.  进入新界面，已经是root，可以用passwd命令设置新密码

## 常用服务

1.  acpid 高级电源管理
2.  anacron cron相关
3.  apmd    电源电量管理
4.  atd     at的daemon
5.  auditd
6.  autofs  自动挂载来自网络上的驱动器，NFS
7.  cpuspeed    管理cpu频率，系统闲置时，自动的降低cpu频率来节省电量
8.  crond       /etc/crontab
9.  cpus        管理打印机服务，http://localhost:631可以管理
10. gpm        tty1~6下的鼠标支持
11. haldaemon  侦测usb
12. hidd       蓝牙侦测
13. bluetooth  蓝牙侦测
14. iptables   本机防火墙，ip6tables
15. irqbalance irq的自动均衡，多核心硬件必须
16. lvm2-monitor   lvm监控
17. netfs      网络驱动器,nfs,smb需要
18. network    网络设定，必须
19. nfslock    nfs的锁
20. portmap     rpc服务必须
21. sendmail    寄信，默认仅支持本机内，不能网络
22. smartd      自动侦测硬盘状态
23. sshd
24. syslog      记录系统产生的各项讯息
25. xfs         图形接口的字体服务
26. xinetd      超级daemon
27. yum-updatesd

## 功能服务

1.  dovecot     邮件服务
2.  httpd       www服务
3.  named       领域服务
4.  nfs         网络磁盘服务
5.  ntpd        网络校时服务
6.  smb         samba
7.  squid       代理服务器
8.  vsftpd      ftp服务
9.  nis         网络信息服务，集中密码验证

## 开机流程

1. BIOS与自测，获取第一设备
2. 读取MBR的boot Loader 亦即是 grub(此程序安装在开机装置的第一扇区)
3. 加载 Kernel ，Kernel 会开始侦测硬件与加载驱动程序；
4. 呼叫 init 程序
5. init 执行 /etc/rc.d/rc.sysinit 档案来准备软件执行的作业环境 (如网络、时区等)；
6. init 执行 run-level 的各个服务之启动 (script 方式)；
7. init 执行 /etc/rc.d/rc.local 档案；
8. init 执行终端机仿真程序 mingetty 来启动 login 程序，最后就等待用户登入啦；

## 常用命令

1.  chkconfig 随机启动


2.  ssh黄金参数

    ssh -o ConnectTimeout=3 -o ConnectionAttempts=5 -o PasswordAuthentication=no -o StrictHostKeyChecking=no $ip  “command”
    1 ConnectTimeout=3                    连接时超时时间，3秒
    2 ConnectionAttempts=5                连接失败后重试次数，5次
    3 PasswordAuthentication=no           是否使用密码认证，（在遇到没做信任关系时非常有用，不然会卡在那里）
    4 StrictHostKeyChecking=no            第一次登陆服务器时自动拉取key文件，（跟上面一样，并且在第一次ssh登陆时，自动应答yes）


## 鸟哥的Linux上的常用命令

1.  `date +%Y%m%d %H:%M:%S`
2.  `cal`
3.  `bc`
 
        scale=3 
        1/3 
        quit

4.  `sync` 把数据同步写入磁盘中
5.  `shutdown -h now` `reboot` `halt` `poweroff`
5.  `runlevel` 显示当前run level
6.  `init` 

        run level 0：关机
        run level 3：纯文本模式
        run level 5：含有图形接口模式
        run level 6：重新启动

7.  `ls` `chgrp` `chown` `chmod`
8.  `basename` `dirname`
9.  `od` 以二进制方式读取文件
10. `nl` 添加行号打印
11. `more` `less`
12. `umask` 文件预设权限
13. `chattr` 配置文件的隐藏属性 `lsattr`

    隐藏属性：

    *   `A` 访问不修改atime，加快io
    *   `S` 同步写文件，不会内存缓存
    *   `a` 只能增加，不能删除和修改
    *   `c` 自动压缩和解压
    *   `d` 不会被dump
    *   `i` 禁止删除、改名、写入、连接
    *   `s` 删除时彻底移除，无法挽救
    *   `u` 与`s`相反
    
14. `chmod`

    文件的特殊权限

    *   `s` 仅对可执行程序有效，执行者获得程序拥有者（或者群组group）的权限
    *   `t` 仅对目录有效，仅有自己和root有权删除
15. `file` 显示文件类型
16. `which` `whereis` `locate` `find`
17. `fdisk` 磁盘分区
18. `mkfs`  磁盘格式化
19. `fsck` `bacblocks` 磁盘检查
20. `mount` `umount`
21. `hdparm` `dhparm -Tt /dev/hdc` 测试
22. `dump` 完整备份，不仅对整个文件系统，和可以仅对文件。`restore`
23. `cpio` io流的cp
24. `iconv` 编码转换
25. `type`  命令的类型
26. `env` `set` 显示系统环境变量和bash自定义变量
26. `declare`
27. `array`
28. `ulimit`
29. `stty`      设置终端属性
30. `col`
31. `join`
32. `paste`     
33. `expand`    tab键转为空格
34. `split`
35. `printf`
36. `diff`      比较差异，还能生成patch文件 
37. `patch`     可以用上述patch文件，更新和还原
37. `useradd` 
38. `passwd` `chage`  可以让账号在第一次登陆后必须修改密码
39. `usermod` `userdel`
38. `finger`    列出账户信息
39. `chfn`      change finger
40. `chsh`      change bash
41. `id`
42. `groupadd` `groupmod` `groupdel` `gpasswd`
43. `setfacl` `getfacl` acl提供更细节支持，需要文件系统支持，ext3支持，需要开启
44. `w` `who` `last` `lastlog`
45. `write` `mesg` `wall`
46. `mail`  发送邮件
47. `nice` `renice`
48. `uptime`
49. `dmesg`
50. `vmstat`
51. `fuser` 查看文档的使用程序是哪个
52. `lsof` 查看程序使用了哪些文件
53. `xinetd` super daemon，没有客户端请求是，各项服务都是未启动的，等到有客户端要求时，super daemon才唤醒对应的服务。客户端要求结束后，被唤醒的服务也会关闭并释放资源。
54. `spawn`
55. `twist` 
56. `chkconfig` 管理系统服务默认开机启动
57. `depmod` 管理模块依赖关系
58. `lsmod` 显示已经加载的模块
59. `modinfo` 更详细的模块信息
60. `modprobe` 分析模块相关性并加载模块,也可以用-r参数卸载
61. `lspci` 查看硬件设备  /proc/bus/pci/*
62. `lsusb`
63. `sensors-detect` 侦测
64. `sensors` 温度侦测
65. `rpm`

        rpm -qa             查询全部
        rpm -q logrotate    查询特定
        rpm -ql logrotate   查询详细目录和档案
        rpm -qi logrotate   查询安装详细说明
        rpm -qc logrotate   查询配置文件
        rpm -qd logrotate   查询说明文档
        rpm -qR logrotate   查询依赖支持
        rpm -e  logrotate   卸载
66. `ifconfig`  查询、设定网络卡于ip。ifconfig可以暂时手动设定和修改。而一旦/etc/init.d/network restart，就全部恢复。可以修改/etc/sysconfig/network-scripts/ifcfg-eth*等文件

        ifconfig eth0   192.168.100.100  修改ip
        ifconfig eth0:0 192.168.50.50    在eth0的基础上再生出一个借口，就是在一个网卡上设定多个ip
        ifconfig eth0:0 down  关闭网卡

69. `route`     查询、设定路由

        route -n  单纯的观察路由

70. `ip`
71. `iwlist`    无线网卡侦测
72. `lwconfig`
73. `dhclient`
74. `ping`      
75. `traceroute`    最终两部主机自己通过的各个节点。`traceroute -n 163.com`
76. `netstat`
77. `host`
78. `nslookup` `dig`
79. `telnet`
80. `lftp`
81. `lynx`
82. `wget`
83. `tcpdump`
84. `ethereal`
85. `nc`
86. `netcat`
87. `nmap`  网络端口显示，不仅本机，也可以远程扫描
