# Akka

    Akka 是一个用 Scala 编写的库，用于简化编写容错的、高可伸缩性的 Java 和 Scala 的 Actor 模型应用。

[官方网站 akka.io](http://akka.io/)

Akka可以以两种不同的方式来使用

1.  以库的形式：在web应用中使用，放到 WEB-INF/lib 中或者作为一个普通的Jar包放进classpath。
2.  以微内核的形式：你可以将应用放进一个独立的内核。

## Akka的五大特性

1.  易于构建并行和分布式应用 （Simple Concurrency & Distribution）
      
    Akka在设计时采用了异步通讯和分布式架构，并对上层进行抽象，如Actors、Futures ，STM等。

2.  可靠性（Resilient by Design）

    系统具备自愈能力，在本地/远程都有监护。

3.  高性能（High Performance）

    在单机中每秒可发送50000000个消息。内存占用小，1GB内存中可保存2500000个actors。

4.  弹性，无中心（Elastic — Decentralized）

    自适应的负责均衡，路由，分区，配置

5.  可扩展（Extensible）

    可以使用Akka 扩展包进行扩展。

## 参考文章

### [akka基础 : 理解Actor 系统](http://my.oschina.net/clopopo/blog/141984)

*   一个actorSystem 是一个重量级的结构。它会分配N个线程。所以对于每一个应用来说只用创建一个ActorSystem
*   actors以树形结构组织起来，类似一个生态系统。例如，一个actor可能会把自己的任务划分成更多更小的、利于管理的子任务。

![](http://static.oschina.net/uploads/space/2013/0702/180741_lmQE_578710.png)

*   actor系统的精华就是任务的分解。任务要被分割的要足够小，每个分片都会被委托给子actor。

Actor 最佳实践

1.  actors 应该像一个优秀团队一样：高效地做着自己的工作，除了必要的交互外互不打扰，并且尽量少的占用资源。
2.  actors之间不要传递可变对象。
3.  actor是包含状态和行为的容器对象。绝对不能将actor自己的状态暴露给其它的actor。

### [akka基础：理解Actor路径](http://my.oschina.net/clopopo/blog/142550)

1.  actor路径地址由各个路径元素连接，从根节点一直到最终的actor。这些路径元素就是在寻找这个actor过程中穿过的父节点名称。各个路径元素用“/"分隔。（有点类似网络地址）

    示例：
    1.  "akka://my-sys/user/service-a/worker1" // 本地路径 
    2.  "akka://my-sys@host.example.com:5678/user/service-b" // 本地或者远程路径 
    3.  "cluster://my-cluster/service-c" //集群路径 

    本地路径组成：

    ![](http://static.oschina.net/uploads/space/2013/0704/170614_1A07_578710.png)

    system名称是使用ActorSytem.create(...)指定的名称，如果没有指定，系统会设置默认值。
    
    user是用户创建的所有的actor的守护actor，是系统自己创建的。