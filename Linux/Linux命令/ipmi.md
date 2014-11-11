# IPMI

    远程管理bios等

<http://my.oschina.net/davehe/blog/88801>

pd2:

    http://10.**.102.127

默认用户名和密码：ADMIN:ADMIN


启动该驱动：
    
    service ipmi start

或者启动模块：

    modprobe ipmi_msghandler
    modprobe ipmi_devintf
    modprobe ipmi_si
    modprobe ipmi_poweroff
    modprobe ipmi_watchdog


用于查看信息

传感器，温度等

    ipmitool -I open sensor list

查看ipmi信息

    ipmitool mc info

人员

    ipmitool user list 1

查看绑定IP

    ipmitool  lan print 1

更改IP

    ipmitool lan set 1 ipaddr  x.x.x.x

更改密码

    ipmitool user list 1
    ipmitool user set password 2 "123456"

ipmitool的SQL远程控制服务器

    ipmitool -I lanplus -H x.x.x.x  -U  root -P  password sol (de)activate

强制重启(关闭或开启)被监控服务器

    ipmitool -I lanplus -H x.x.x.x -U root -P password chassis power reset (off on)

列出日志

    ipmitool sel list

快捷键

    shift + ~ +.  是退出ipmi