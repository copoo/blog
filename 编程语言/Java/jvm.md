# JVM

<http://www.searchtb.com/2013/07/jvm-gc-introduction-examples.html>
<http://my.oschina.net/luffyke/blog/111442>

非常重要：
[Java 6 JVM参数选项大全](http://kenwublog.com/docs/java6-jvm-options-chinese-edition.htm)

## 基本原理
![](http://www.eleforest.us/wp-content/uploads/2013/03/jvm-300x158.jpg)


## 常用参数

	-XX:OnOutOfMemoryError="kill -9 %p"
	-XX:+HeapDumpOnOutOfMemoryError -XX:HeapDumpPath=/usr/tmp
	JVM_ARGS="-Xms1536m -Xms1536m -XX:OnOutOfMemoryError='kill -9 %p'"

	JOPTS="-server -XX:+UseParNewGC -XX:+UseConcMarkSweepGC \
	-XX:-CMSConcurrentMTEnabled -XX:CMSInitiatingOccupancyFraction=70 \
	-XX:+CMSParallelRemarkEnabled \
	-XX:+UseCMSCompactAtFullCollection \
	-XX:MaxDirectMemorySize=512m \
	-Dclient.encoding.override=UTF-8 -Dfile.encoding=UTF-8 \
	-Duser.language=zh -Duser.region=CN"

	hbase中：
	"$JAVA" -XX:OnOutOfMemoryError="kill -9 %p" $JAVA_HEAP_MAX $HBASE_OPTS -classpath "$CLASSPATH" $CLASS "$@"


	-XX:+DisableExplicitGC	可能会触发 Direct ByteBuffer 的oom，可以用 -XX:+ExplicitGCInvokesConcurrent 或 -XX:+ExplicitGCInvokesConcurrentAndUnloadsClasses  优化


## 常用GC

(1)-XX:+UseConcMarkSweepGC

 GC名：

   ParNew

   ConcurrentMarkSweep

 内存池名：

   CMS Perm Gen

   Par Eden Space

   Par Survivor Space

   Code Cache

   CMS Old Gen

(2)-XX:+UseParallelGC

    -- Parallel Scavenge

 GC名：

   PS Scavenge

   PS MarkSweep

 内存池名：

   PS Survivor Space

   PS Perm Gen

   PS Old Gen

   PS Eden Space

   Code Cache

(3)-XX:+UseParallelOldGC

 GC名：

   PS Scavenge

   PS MarkSweep

 内存池名：

   PS Survivor Space

   PS Perm Gen

   PS Old Gen

   PS Eden Space

   Code Cache

(4)-XX:+UseSerialGC

 GC名：

   Copy

   MarkSweepCompact

 内存池名：

   Survivor Space

   Perm Gen

   Tenured Gen

   Eden Space

   Code Cache

G1回收器

<http://developer.51cto.com/art/200907/138943.htm>
<http://www.oracle.com/technetwork/articles/java/g1gc-1984535.html>


## 参数


## Java状态检查

### jstat
    
    统计工具

    jstat -gcutil pid 时间间隔

jstat -gc 16136
 S0C    S1C    S0U    S1U      EC       EU        OC         OU       PC     PU    YGC     YGCT    FGC    FGCT     GCT
1024.0 1024.0  0.0    0.0    8192.0   2867.9   10240.0      0.0     21248.0 2637.2      0    0.000   0      0.000    0.000

S0C,S1C,S0U,S1U: 0/1幸存区(survivor)容量(C:Capacity)/使用量（U:Used)。
EC,EU: Eden(伊甸)区容量/用量

按照复制算法的原理将新生代分成了3个区域：Eden、Survivor0、Survivor1。

OC,OU: Old(老生代）容量/用量。老生代常用的垃圾收集器有CMS、Serial Old、Parallel Old等
PC,PU: Perm(永生代）容量/用量。
YGC/YGCT: Young GC次数和总耗费时间。
FGC/FGCT：Full GC次数和总耗费时间。
GCT：GC总耗时。

SurvivorRatio	新生代中eden的比例，如果设置为8，意味着新生代中eden占据80%的空间，两个survivor分别占据10%


java -XX:+PrintFlagsFinal -version 2>&1 | grep MaxHeapSize
打印默认值


### JConsole

使用JVM的可扩展性Java管理扩展(JMX)工具来提供关于运行于Java平台的应用程序的性能和资源消耗的信息。
需要使用-Dcom.sun.management.jmxremote	java6开始不再需要
但需要com.sun.management.jmxremote.port=portNum
http://hornetblog.sinaapp.com/?p=5	比较全的
http://docs.oracle.com/javase/6/docs/technotes/guides/management/agent.html#gdenl	如何配置远程JMX
启动远程jmx默认会需要密码和访问文件，可以使用
com.sun.management.jmxremote.authenticate=false来取消验证
com.sun.management.jmxremote.ssl=false	默认开启，需要显式取消
hadoop中启动，先设置
HADOOP_OPTS="-Dcom.sun.management.jmxremote.port=11111 -Dcom.sun.management.jmxremote.authenticate=false"
启动后远程监控
192.168.22.30:1111

### jinfo

### jmap

jmap -dump:live,format=b,file=heap.dmp PID	生成堆文件
jmap -heap PID  Heap内存信息

### jhat
内存堆分析工具
jmap导出后的映像文件可以用jhat来进行分析，
jhat -J-mx768m -port <端口号:默认为7000> heap.dmp



Java内存占用
1. JVM
2. OS链接库存放空间

3. 应用程序二进制码，即java classes
4. Java heap，对象存放在这个区域，这是一个必须连续的空间

5. 经过JIT技术编译的本地代码存放空间
6. 本地代码的heap