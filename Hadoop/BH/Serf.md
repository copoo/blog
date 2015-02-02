# Serf

让容器自动的知道彼此。服务发现，编配（应用集群管理等）工具，它去中心化，高可用并且能故障恢复（容忍）。

<https://github.com/hashicorp/serf>

<http://www.serfdom.io/intro/use-cases.html>

<http://liubin.org/2014/02/22/first-serf-experience/>

## 常用命令

	serf agent -node=foo -bind=127.0.0.1:5000 -rpc-addr=127.0.0.1:7373
	serf agent -node=bar -bind=127.0.0.1:5001 -rpc-addr=127.0.0.1:7374
	./serf agent -log-level=debug -node=node1 -rpc-addr=192.168.159.129:7373
	./serf agent -log-level=debug -node=node2 -rpc-addr=192.168.159.130:7373

	./serf agent -log-level=debug -node=node1 -rpc-addr=192.168.159.129:7373 -bind=192.168.159.129:7946
	./serf agent -log-level=debug -node=node2 -rpc-addr=192.168.159.130:7373 -bind=192.168.159.130:7946
	
	./serf join -rpc-addr=192.168.159.130:7373 192.168.159.130
	./serf join -rpc-addr=192.168.159.129:7373 192.168.159.129