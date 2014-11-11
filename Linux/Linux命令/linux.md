# Linux

发行版本：

1.  CentOS
2.  RH

查看系统版本：

1.  `lsb_release -a`
2.  `hostname -a`

## yum
    
源：

1.  EPEL

        yum install epel-release

    RPM下载安装

        wget http://dl.fedoraproject.org/pub/epel/5/i386/epel-release-5-4.noarch.rpm
        wget http://dl.fedoraproject.org/pub/epel/6/i386/epel-release-6-8.noarch.rpm
        rpm -i epel-release*.rpm

2. rpmforge

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


##  磁盘坏道


如果只是逻辑坏道
umount /dev/sdc1
fsck -y /dev/sdc1
mount /dev/sdc1

如果是物理坏道


badblocks

## 时间同步


    0 3 * * * ntpdate clock.redhat.com > /dev/null 2>&1
    0 3 * * * ( ntpdate ntp.ucweb.com && /sbin/hwclock -w ) > /dev/null 2>&1
	
## dns
