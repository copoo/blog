# DNSMasq

<http://baike.baidu.com/view/6681631.htm?fr=aladdin>

[用dnsmasq搭建小型的内网DNS](http://purplegrape.blog.51cto.com/1330104/1083354)


用于配置DNS和DHCP的工具，适用于小型网络。服务那些只在本地适用的域名，这些域名是不会在全球的DNS服务器中出现的。（最多可支持1000台主机）

## 使用

	yum install dnsmasq -y 
	service dnsmasq start 

	配置文件为/etc/dnsmasq.conf,
	

	默认配置文件为/etc/dnsmasq.conf,注释掉的不是示例就是默认值。   
	   
	默认直接缓存resolv.conf中的nameserver，通过下面的选项指定其他文件   
	resolv-file=/etc/resolv.dnsmasq.conf   
	   
	默认监听本地所有端口，指定监听端口的办法(别忘了本地回环)   
	listen-address=127.0.0.1,192.168.1.56   
	  
	我要给dns记录在另外一个文件，而不是/etc/hosts  
	addn-hosts=/etc/addion_hosts  
	  
	设置dns缓存大小  
	cache-size=150  
	 
	我担心dnsmasq的稳定性怎么办 
	解决办法一：写脚本或用nagios监视dnsmasq进程，或者定时重启 
	解决办法二：在另一台机器也搭建一个dnsmasq，/etc/hosts文件拷一份过去，客户端指定2个内网DNS
 