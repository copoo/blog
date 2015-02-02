# Docker

!(http://tech.uc.cn/wp-content/uploads/2014/04/docker-filesystems-multilayer.png)

<https://code.csdn.net/u010702509/docker/file/Docker.md>

## 常用命令

获取镜像

	docker pull centos:centos6

运行镜像

	docker run -i -t centos:centos6 /bin/bash 
	
创建镜像

通过命令

	sudo docker run -t -i centos:centos6 /bin/bash
	记住容器的 ID：614a6c74983d，这个在容器运行后会显示
    在容器中执行命令
    exit退出容器
	sudo docker commit -m "信息" -a "用户信息" 容器ID 仓库名/标签
	sudo docker commit -m "信息" -a "用户信息" 0b2616b0e5a8 ouruser/sinatra:v2
	sudo docker images

通过Dockerfile

	ADD 命令复制本地文件到镜像；
	EXPOSE 命令来向外部开放端口；
	CMD 命令来描述容器启动后运行的程序

	

创建Dockerfile文件

	sudo docker build -t="hontlong/bluehadoop:v1" Dockerfile所在目录

修改镜像标签

	sudo docker tag 5db5f8471261 ouruser/sinatra:devel

删除镜像

	sudo docker-ps 列出容器
	sudo docker rm 容器ID
    sudo docker images
	sudo docker rmi training/sinatra

创建磁盘卷

	-v 卷路径
	-v 主机目录:容器挂载点
	sudo docker run -d -P --name web -v /webapp training/webapp python app.py
	sudo docker run -d -P --name web -v /src/webapp:/opt/webapp training/webapp python app.py
	Dockerfile 中使用 VOLUME
	VOLUME /var/log

端口

	-p 参数来指定端口映射

## 常用命令

    docker OPTIONS (#options) COMMAND [arg...]

    docker 可以以2中方式运行，Daemon和CLI。

    选项：

      -D=true|false Enable debug mode.  Default is false.
      --help Print usage statement
      -H,  --host=[unix:///var/run/docker.sock]:  tcp://[host:port] to bind or unix://[/path/to/socket] to use.  The socket(s) to
      bind to in daemon mode specified using one or more tcp://host:port, unix:///path/to/socket, fd://* or fd://socketfd.

      --api-enable-cors=true|false Enable CORS headers in the remote API.  Default is false.

      -b="" Attach containers to a pre-existing network bridge; use 'none' to disable container networking

      --bip="" Use the provided CIDR notation address for the dynamically created bridge (docker0); Mutually exclusive of -b

      -d=true|false Enable daemon mode.  Default is false.

      --dns="" Force Docker to use specific DNS servers

      -g="" Path to use as the root of the Docker runtime.  Default is /var/lib/docker.

      --icc=true|false Enable inter-container communication.  Default is true.

      --ip="" Default IP address to use when binding container ports.  Default is 0.0.0.0.

      --iptables=true|false Disable Docker's addition of iptables rules.  Default is true.

      --mtu=VALUE Set the containers network mtu.  Default is 1500.

      -p="" Path to use for daemon PID file.  Default is /var/run/docker.pid

      -r=true|false Restart previously running containers.  Default is true.

      -s="" Force the Docker runtime to use a specific storage driver.

      -v=true|false Print version information and quit.  Default is false.

      --selinux-enabled=true|false Enable selinux support.  Default is false.  SELinux does not presently support the BTRFS stor‐
      age driver.

### 命令行

    docker-attach ：连接正在运行的容器
    docker-build ：冲配置文件中构建镜像
    docker-commit ：创建 image
    docker-cp ：拷贝文件目录
    docker-diff ：
    docker-events ：从服务器获取实时 events
    docker-export ：容器内存流出，作为tar文档
    docker-history ：显示一个镜像的历史
    docker-images ：列出镜像
    docker-import ：从tar包中创建一个新的文件系统镜像
    docker-info ：
    docker-inspect ：返回容器的低等级的信息
    docker-kill ：Kill一个正在运行的容器
    docker-load ：加载镜像从tar包
    docker-login ：注册或登录Docker注册服务器
    docker-logout ：登出
    docker-logs ：获取容器的日志
    docker-pause ：暂停容器的全部处理器
    docker-port ：查看public-facing port which is NAT-ed to PRIVATE_PORT
    docker-ps ：列出全部容器
    docker-pull ：拉取镜像或仓库
    docker-push ：提交镜像或仓库
    docker-restart ：重启
    docker-rm ：移除容器
    docker-rmi ：移除镜像
    docker-run ：在新容器中运行命令
    docker-save ：Save an image to a tar archive
    docker-search ：搜索镜像
    docker-start ：启动容器
    docker-stop ：停止容器
    docker-tag ：在仓库中Tag一个镜像
    docker-top ：查看一个容器正在运行的进程
    docker-unpause ：恢复暂停
    docker-version ：
    docker-wait ：阻塞等一个容器停止，然后打印它的退出码

### 示例

docker pull ubuntu:13.10
